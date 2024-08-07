using GenericNauty
using Documenter

DocMeta.setdocmeta!(GenericNauty, :DocTestSetup, :(using GenericNauty); recursive=true)

makedocs(;
    modules=[GenericNauty],
    authors="Daniel Brosch <73886037+DanielBrosch@users.noreply.github.com> and contributors",
    sitename="GenericNauty.jl",
    format=Documenter.HTML(;
        canonical="https://DanielBrosch.github.io/GenericNauty.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/DanielBrosch/GenericNauty.jl",
    devbranch="main",
)
