module Models
export vertexColor, distinguish, permute

vertexColor(F, v)::Int = 1
distinguish(F, v::Int, W::BitVector)::UInt = 0
function permute(F::T, p)::T where {T}
    @error "Mising"
    return F
end

include("graph.jl")

end
