module ValueHistories

using DataStructures
using RecipesBase

export

    ValueHistory,
      UnivalueHistory,
        History,
        QHistory,
      MultivalueHistory,
        MVHistory,
    @trace

include("abstract.jl")
include("history.jl")
include("qhistory.jl")
include("mvhistory.jl")
include("recipes.jl")

Base.@deprecate_binding VectorUnivalueHistory History
Base.@deprecate_binding QueueUnivalueHistory QHistory
Base.@deprecate_binding DynMultivalueHistory MVHistory


end # module
