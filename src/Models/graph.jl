using LinearAlgebra
using Combinatorics

struct Graph <: Model
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
    return hash(A.A, hash(:Graph, h))
end

import Base.size
function size(G::Graph)::Int
    return size(G.A, 1)
end

function permute(G::Graph, p::Vector{Int})
    n = size(G)
    res = BitMatrix(zeros(n, n))
    res[p, p] .= G.A
    return Graph(res)
end

function distinguish(G::Graph, v::Int, W::BitVector)::UInt
    res = 0
    n = size(G)
    for i in 1:n
        if W[i] && G.A[i, v]
            res += 1
        end
    end
    return hash(res)
end

function extend(G::Graph)::Vector{Graph}
    n = size(G)
    A = BitMatrix(zeros(n + 1, n + 1))
    A[1:n, 1:n] .= G.A

    newGs::Vector{Graph} = Graph[Graph(A)]
    sizehint!(newGs, 2^n)
    for c in combinations(1:n)
        A2 = copy(A)
        A2[c, end] .= 1
        A2[end, c] .= 1
        push!(newGs, Graph(A2))
    end

    return newGs
end
