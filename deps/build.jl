
Pkg.clone("https://github.com/vincentcp/LinearAlgebra.jl.git")
Pkg.clone("https://github.com/daanhb/Domains.jl")
Pkg.clone("https://github.com/daanhb/BasisFunctions.jl")
Pkg.checkout("BasisFunctions", "julia-0.7")
Pkg.build("BasisFunctions")
