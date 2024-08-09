using GenericNauty
using GenericNauty: Models.Graph
using LinearAlgebra
using Profile

#TODO: Delete view_profile once VSCodeServer is updated
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

##

function randGraph(n::Int, density::Int=2)
    A = rand(1:density, n, n) .== 1
    A[diagind(A)] .= 0

    return Graph(A)
end

G::Graph = randGraph(2_000, 5)
@timev Gc::Graph, auts::GenericNauty.Group = label(G)

## Time profiling
Profile.init(10_000_000, 0.0001)
@profview Gc::Graph, auts::Group = label(G) recur = :flat

## Memory profiling
@profview_allocs Gc, auts = label(G) recur = :flat
