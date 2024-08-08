using GenericNauty
using LinearAlgebra
using Profile

import .VSCodeServer.view_profile
function view_profile(data=Profile.fetch(); C=false, kwargs...)
    d = Dict{String,VSCodeServer.ProfileFrame}()

    if VERSION >= v"1.8.0-DEV.460"
        threads = ["all", 1:Threads.nthreads()...]
    else
        threads = ["all"]
    end

    if isempty(data)
        Profile.warning_empty()
        return nothing
    end

    lidict = Profile.getdict(unique(data))
    data_u64 = convert(Vector{UInt64}, data)
    for thread in threads
        graph = VSCodeServer.stackframetree(data_u64, lidict; thread=thread, kwargs...)
        d[string(thread)] = VSCodeServer.make_tree(
            VSCodeServer.ProfileFrame(
                "root",
                "",
                "",
                0,
                graph.count,
                missing,
                0x0,
                missing,
                VSCodeServer.ProfileFrame[],
            ),
            graph;
            C=C,
        )
    end

    return VSCodeServer.JSONRPC.send(
        VSCodeServer.conn_endpoint[],
        VSCodeServer.repl_showprofileresult_notification_type,
        (; trace=d, typ="Thread"),
    )
end

struct Graph
    A::Symmetric{Bool,BitMatrix}

    Graph(A::Matrix{Bool}) = new(Symmetric(BitMatrix(A)))
    Graph(A::Symmetric{Bool,BitMatrix}) = new(A)
    Graph(A::BitMatrix) = new(Symmetric(A))
    Graph() = new(Symmetric(BitMatrix(undef, 0, 0)))
end

function GenericNauty.permute(G::Graph, p::Vector{Int})
    # @error "A"
    n = size(G)
    res = BitMatrix(zeros(n, n))
    res[p, p] .= G.A
    return Graph(res)
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

function GenericNauty.distinguish(F, v::Int, W::BitVector)::UInt
    # @error "B"
    # @error "code reached"
    res = 0
    n = size(F)
    for i in 1:n
        if W[i] && F.A[i, v]
            res += 1
        end
    end
    return hash(res)
    # @inbounds return hash(sum(F.A[W, v]))

    # Jets.@report_opt does not like @views?
    # @inbounds @views return hash(sum(F.A[W, v]))
end

function GenericNauty.vertexColor(G::Graph, v)
    # @error "C"
    return 1
end

A = rand(Bool, 10000, 10000)
A[diagind(A)] .= 0
A = BitMatrix(Symmetric(A))

G = Graph(A)

@time Gc, auts = label(G)
@timev Gc, auts = label(G)

Profile.init(10_000_000, 0.0001)
@profview Gc, auts = label(G) #recur=:flat
@profview_allocs Gc, auts = label(G) recur = :flat

##
using AbstractAlgebra
A = rand(Bool, 5, 5)
A[diagind(A)] .= 0
A = BitMatrix(Symmetric(A))
G1 = Graph(A)

p = rand(SymmetricGroup(size(A, 1))).d
B = A[p, p]
G2 = Graph(B)

G1c = label(G1)[1]
G2c = label(G2)[1]

G1c.A == G2c.A

## 

# in REPL
using JET
@report_opt label(G)
@report_call label(G)
@code_warntype label(G)

# using Aqua
# Aqua.test_all(GenericNauty)
