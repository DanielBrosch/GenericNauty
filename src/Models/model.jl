export Model

abstract type Model end

function permute(G::T, p::Vector{Int})::T where {T<:Model}
    error("permute not implemented for $T.")
    return G
end

function distinguish(G::T, v::Int, W::BitVector)::UInt where {T<:Model}
    error("distinguish not implemented for $T.")
    return UInt(0)
end

"""
    vertexColor(G::T, v)::Int where {T<:Model}

The initial color of a vertex `v` of `G`, used for the initial coloring of the labeling algorithm. Defaults to `1`.
"""
function vertexColor(G::T, v)::Int where {T<:Model}
    return 1
end

"""
    extend(G::T)::Vector{T} where {T<:Model}

Adds one vertex in all possible ways to `G`, potentially including multiple isomorphic copies of a model.
"""
function extend(G::T)::Vector{T} where {T<:Model}
    error("extend not implemented for $T.")
    return T[]
end
