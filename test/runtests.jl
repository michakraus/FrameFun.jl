include("test_suite_support.jl")
include("test_suite.jl")
include("test_suite_applications.jl")
include("test_continuous_approximation.jl")
include("test_suite_adaptive.jl")
include("test_suite_domains.jl")
include("test_suite_gram.jl")
include("test_platforms.jl")


include("test_plots.jl")

# jupyter = (VERSION < v"0.7-") ? homedir()*"/.julia/v0.6/Conda/deps/usr/bin/jupyter" :
                                # homedir()*"/.julia/packages/Conda/S0nV/deps/usr/bin/jupyter"
# include("test_notebooks.jl")
# println("Create README.md")
# run(`$jupyter nbconvert --execute --to markdown --output README.md README.ipynb`)


println("All tests succeeded!!!")
