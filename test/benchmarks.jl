using GenericNauty
using GenericNauty: Models.Graph
using BenchmarkTools
using BenchmarkPlots
using StatsPlots
using Random

#TODO: Could keep track of performance changes with https://github.com/benchmark-action/github-action-benchmark/blob/master/examples/julia/README.md

function randGraph(n::Int, density::Int=2)
    A = rand(1:density, n, n) .== 1
    A[diagind(A)] .= 0

    return Graph(A)
end

##
Random.seed!(12345)

@benchmark label(H) seconds = 10 setup = (H = randGraph(rand(10:1000), rand(2:20)))

## Benchmarks for various graph sizes, densities
Random.seed!(12345)

graphBenchmarks::BenchmarkGroup = BenchmarkGroup()
for d in [2, 5, 10, 20]
    graphBenchmarks[d] = BenchmarkGroup()
    for n in 100:100:1000
        graphBenchmarks[d][n] = @benchmarkable label(H) setup = (H = randGraph($n, $d))
    end
end

tune!(graphBenchmarks; verbose=true)
results = run(graphBenchmarks; verbose=true)

@recipe function f(g::BenchmarkGroup, keys=sort!(collect(keys(g))))
    legend --> false
    yguide --> "t / ns"
    fillalpha --> 0.5
    yscale --> :log10
    for k in keys
        @series begin
            label --> string(k)
            xticks --> true
            color --> :blue
            [string(k)], g[k]
        end
    end
end

plot(results[2])
plot!(results[5]; color=:orange)
plot!(results[10]; color=:red)
plot!(results[20]; color=:purple)
