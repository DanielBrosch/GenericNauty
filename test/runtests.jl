using GenericNauty
using Test
using Aqua
using JET

@testset "GenericNauty.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(GenericNauty)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(GenericNauty; target_defined_modules=true)
    end
    # Write your tests here.
end
