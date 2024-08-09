using GenericNauty
using GenericNauty: Models.Graph
using LinearAlgebra
using Random

##
Random.seed!(12345)

@testset "Random graph labeling" begin
    for n in [10, 50, 100, 200]
        @testset "Graphs of size $n" begin
            for _ in 1:20
                d = rand(2:10)
                A = rand(1:d, n, n) .== 1
                A[diagind(A)] .= 0
                A = Symmetric(BitMatrix(A))

                G1 = Graph(A)

                p = randperm(n)
                B = A[p, p]
                G2 = Graph(B)

                G1c = label(G1)[1]
                G2c = label(G2)[1]

                @test G1c.A == G2c.A
            end
        end
    end
end