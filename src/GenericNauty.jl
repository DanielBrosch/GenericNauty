module GenericNauty

export label, generateAll, canonical

# Write your package code here.
include("Models/Models.jl")

include("label.jl")
include("generateAll.jl")

end
