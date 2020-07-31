# juliaAllotter

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://saurabhkm.github.io/juliaAllotter.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://saurabhkm.github.io/juliaAllotter.jl/dev)
[![Build Status](https://travis-ci.com/saurabhkm/juliaAllotter.jl.svg?branch=master)](https://travis-ci.com/saurabhkm/juliaAllotter.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/saurabhkm/juliaAllotter.jl?svg=true)](https://ci.appveyor.com/project/saurabhkm/juliaAllotter-jl)
[![Codecov](https://codecov.io/gh/saurabhkm/juliaAllotter.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/saurabhkm/juliaAllotter.jl)
[![Coveralls](https://coveralls.io/repos/github/saurabhkm/juliaAllotter.jl/badge.svg?branch=master)](https://coveralls.io/github/saurabhkm/juliaAllotter.jl?branch=master)


This is the code for the Teaching Assistant allocation problem modelled as bipartite graph matching which is solved using markov chain monte carlo based method.

## Requirements
- CSV
- LinearAlgebra
- Statistics
- JLD

**Note**: The packaging of this code is currently underway for potentially expanding it for solving general allotment problems of this kind. For now, if you want to use the code with your dataset, please call the juliaAllotter.jl file in 'src' in julia REPL. This will generate the myfile.jld file in the results directory and the performance metrics can be visualized using the visual.ipynb file provided.