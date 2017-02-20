# fe_solvers.jl


abstract FE_Solver{ELT} <: AbstractOperator{ELT}

problem(s::FE_Solver) = s.problem

# Delegation methods
for op in (:frequency_basis, :frequency_basis_ext, :time_basis, :time_basis_ext,
    :time_basis_restricted, :operator, :operator_transpose, :domain)
    @eval $op(s::FE_Solver) = $op(problem(s))
end

size(s::FE_Solver, j::Int) = size(problem(s), j)

src(s::FE_Solver) = time_basis_restricted(s)

dest(s::FE_Solver) = frequency_basis(s)



immutable FE_DirectSolver{ELT} <: FE_Solver{ELT}
    problem ::  FE_Problem
    QR      ::  Factorization

    function FE_DirectSolver(problem::FE_Problem)
        new(problem, qrfact(matrix(operator(problem)),Val{true}))
    end
end

FE_DirectSolver(problem::FE_Problem; options...) =
    FE_DirectSolver{eltype(problem)}(problem)

function apply!(s::FE_DirectSolver, coef_dest, coef_src)
    coef_dest[:] = s.QR \ coef_src
    apply!(normalization(problem(s)), coef_dest, coef_dest)
end

immutable ContinuousDirectSolver{T} <: AbstractOperator{T}
  src                     :: FunctionSet
  mixedgramfactorization  :: Factorization
  normalizationofb        :: AbstractOperator
  scratch                 :: Array{T,1}
  # ContinuousDirectSolver(frame::ExtensionFrame; options...) = new(qrfact(matrix(MixedGram(frame; options...)),Val{true}), DualGram(frame; options...), zeros(eltype(frame),length(frame)))
end
dest(s::ContinuousDirectSolver) = s.src
ContinuousDirectSolver(frame::ExtensionFrame; options...) =
    ContinuousDirectSolver{eltype(frame)}(frame, qrfact(matrix(MixedGram(frame; options...)),Val{true}), DualGram(basis(frame); options...), zeros(eltype(frame),length(frame)))

function apply!(s::ContinuousDirectSolver, coef_dest, coef_src)
  println(coef_src)
  apply!(s.normalizationofb, s.scratch, coef_src)
  println(s.scratch)
  println(inv(s.mixedgramfactorization \ eye(length(s.scratch))))
  coef_dest[:] = s.mixedgramfactorization \ s.scratch
  println(coef_dest)
end

immutable ContinuousTruncatedSolver{T} <: AbstractOperator{T}
  src                     :: FunctionSet
  mixedgramsvd            :: AbstractOperator
  normalizationofb        :: AbstractOperator
  scratch                 :: Array{T,1}
  # ContinuousDirectSolver(frame::ExtensionFrame; options...) = new(qrfact(matrix(MixedGram(frame; options...)),Val{true}), DualGram(frame; options...), zeros(eltype(frame),length(frame)))
end
dest(s::ContinuousTruncatedSolver) = s.src
ContinuousTruncatedSolver(frame::ExtensionFrame; cutoff=1e-5, options...) =
    ContinuousTruncatedSolver{eltype(frame)}(frame, FrameFun.TruncatedSvdSolver(MixedGram(frame; options...); cutoff=cutoff), DualGram(basis(frame); options...), zeros(eltype(frame),length(frame)))

function apply!(s::ContinuousTruncatedSolver, coef_dest, coef_src)
  apply!(s.normalizationofb, s.scratch, coef_src)
  coef_dest[:] = s.mixedgramsvd*s.scratch
  # apply!(s::TruncatedSvdSolver, destset, srcset, coef_dest, coef_src)
  # coef_dest[:] = s.mixedgramsvd \ s.scratch
end
## abstract FE_IterativeSolver <: FE_Solver


## immutable FE_IterativeSolverLSQR <: FE_IterativeSolver
##     problem ::  FE_Problem
## end


## function solve!{T}(s::FE_IterativeSolverLSQR, coef::AbstractArray{T}, rhs::AbstractArray{T})
##     op = operator(s)
##     opt = operator_transpose(s)

##     my_A_mul_B!(output, x) =  ( apply!(op,  reshape(output, size(dest(op ))), reshape(x, size(src(op )))); output )
##     my_Ac_mul_B!(output, y) = ( apply!(opt, reshape(output, size(dest(opt))), reshape(y, size(src(opt)))); output )

##     matcfcn = MatrixCFcn{T}(size(op, 1), size(op, 2), my_A_mul_B!, my_Ac_mul_B!)

##     coef[:] = 0
##     y,ch = lsqr!(coef, matcfcn, rhs, maxiter = 100)

##     println("Stopped after ", ch.mvps, " iterations with residual ", abs(ch.residuals[end]), ".")
## end
