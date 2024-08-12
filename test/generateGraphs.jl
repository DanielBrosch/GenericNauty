using GenericNauty
using GenericNauty: Models.Graph

@testset "Generate graphs" begin
    # OEIS Sequence A000088: 1, 1, 2, 4, 11, 34, 156, 1044, 12346,...
    @test length(generateAll(Graph, 0)) == 1
    @test length(generateAll(Graph, 1)) == 1
    @test length(generateAll(Graph, 2)) == 2
    @test length(generateAll(Graph, 3)) == 4
    @test length(generateAll(Graph, 4)) == 11
    @test length(generateAll(Graph, 5)) == 34
    @test length(generateAll(Graph, 6)) == 156
    @test length(generateAll(Graph, 7)) == 1044
    @test length(generateAll(Graph, 8)) == 12346
end