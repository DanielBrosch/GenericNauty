using GenericNauty
using Test
using Aqua
using JET
using Documenter

@testset "GenericNauty.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(GenericNauty; deps_compat=(ignore=[:LinearAlgebra],))
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(GenericNauty; target_defined_modules=true)
    end
    # Write your tests here.
    @testset "Label" begin
        include("labelTests.jl")
    end

    @testset "Doctests" begin
        doctest(GenericNauty)
    end
end
