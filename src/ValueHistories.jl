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

include("abstract_history.jl")
include("queue_uv_history.jl")
include("vector_uv_history.jl")
include("dyn_mv_history.jl")
include("recipes.jl")

Base.@deprecate_binding VectorUnivalueHistory History
Base.@deprecate_binding QueueUnivalueHistory QHistory
Base.@deprecate_binding DynMultivalueHistory MVHistory


end # module
