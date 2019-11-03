using Documenter, juliaAllotter

makedocs(;
    modules=[juliaAllotter],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/saurabhkm/juliaAllotter.jl/blob/{commit}{path}#L{line}",
    sitename="juliaAllotter.jl",
    authors="Saurabh Kumar, Indian Institute of Technology Bombay",
    assets=String[],
)

deploydocs(;
    repo="github.com/saurabhkm/juliaAllotter.jl",
)
