
"""
    generateAll(::Type{T}, maxVertices::Int) where {T<:Model}

Generates a list of all models of type `T` up to isomorphism on `maxVertices` vertices.
"""
function generateAll(::Type{T}, maxVertices::Int) where {T<:Model}
    models::Vector{T} = T[T()]
    for i in 1:maxVertices
        @info "Extending to $i vertices"
        extended::Vector{T} = reduce(vcat, extend(G) for G in models)
        models = unique(canonical.(extended))
    end
    return models
end
