using LinearAlgebra

struct Graph
    A::Symmetric{Bool,BitMatrix}

    Graph(A::Matrix{Bool}) = new(Symmetric(BitMatrix(A)))
    Graph(A::Symmetric{Bool,BitMatrix}) = new(A)
    Graph(A::BitMatrix) = new(Symmetric(A))
    Graph() = new(Symmetric(BitMatrix(undef, 0, 0)))
end

import Base.==
function ==(A::Graph, B::Graph)
    return A.A == B.A
end
import Base.hash
function hash(A::Graph, h::UInt)
    # @error "E"
    return hash(A.A, hash(:Graph, h))
end

import Base.size
function size(G::Graph)::Int
    # @error "D"
    return size(G.A, 1)
end

function permute(G::Graph, p::Vector{Int})
    # @error "A"
    n = size(G)
    res = BitMatrix(zeros(n, n))
    res[p, p] .= G.A
    return Graph(res)
end

function distinguish(G::Graph, v::Int, W::BitVector)::UInt
    # @error "B"
    # @error "code reached"
    res = 0
    n = size(G)
    for i in 1:n
        if W[i] && G.A[i, v]
            res += 1
        end
    end
    return hash(res)
    # @inbounds return hash(sum(F.A[W, v]))

    # Jets.@report_opt does not like @views?
    # @inbounds @views return hash(sum(F.A[W, v]))
end

function vertexColor(G::Graph, v)
    # @error "C"
    return 1
end
