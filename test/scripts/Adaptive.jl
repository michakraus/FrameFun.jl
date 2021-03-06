
using BasisFunctions
using FrameFun
using DomainSets
using Plots
gr()

D = interval(-0.5,0.5)

F = FourierSpace(-1,1)
C = ChebyshevSpace()
Dictionary(F,4)

f0 = x->x
f1 =(x)->cos(3*x)
f2 =(x)->cos(80*x)
f3 =(x)->cos(10*x.^2)

FF = FeFun(f0)

plot(FF,plot_ext=true,layout=2)
plot!(f0,FF,plot_ext=true,subplot=2)

FF = FeFun(f0,Omega=interval(-1,.1),Gamma=interval(-1.5,.1))

FC1 = FunConstructor(F, D)
F1 = FC1(f0)

F1 = FC1(f0,afun=FrameFun.fun_simple)

plot(abs.(coefficients(F1)),yscale=:log10)

F1 = FC1(f0,afun=FrameFun.fun_greedy)

plot(abs.(coefficients(F1)),yscale=:log10)

plot(F1,f0)

FC2 = FunConstructor(C, interval(-.5,.5))
F2 = FC2(f2)

plot(F2,f2)

FC3 = FunConstructor(F, interval(-1.0,-0.5)∪interval(-0.2,0.5))
F3 = FC3(f3, max_logn_coefs=12, solver=AZSolver)
F3 = FC3(f3, max_logn_coefs=12, solver=DirectSolver)

l = @layout [Plots.grid(1,1); Plots.grid(1,2)]
plot(F3, layout=l)
plot!(F3, subplot=2, plot_ext=true)
plot!(F3,f3, subplot=3)

x = FC1(identity)

f4 = x->sin(cos(x))
F4 = sin(cos(x))

plot(F4,f4;layout=2)
plot!(F4;subplot=2)

f5 = x->exp(cos(100x))
F5 = exp(cos(100x); max_logn_coefs=10)

plot(F5,f5)

FF = FeFun((x,y)->exp(x-y),2,Omega=disk(),adaptive_verbose=true,cutoff=1e-5)

plot(FF)

gr()

D = interval(0.,.5)^2
FF = FourierSpace()⊗FourierSpace()
f = (x,y) -> exp(y*2*x)
FC = FunConstructor(FF, D)

F0 = FC(f,tol=1e-12, max_logn_coefs=12)
F1 = FC(f,tol=1e-12, max_logn_coefs=12, solver=AZSolver)
F2 = FC(f,tol=1e-12, max_logn_coefs=12, solver=DirectSolver)

plot(F1,f)
