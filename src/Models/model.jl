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

function vertexColor(G::T, v) where {T<:Model}
    error("vertexColor not implemented for $T.")
    return 1
end
