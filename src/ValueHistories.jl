module ValueHistories

using DataStructures
using RecipesBase

export

    ValueHistory,
      UnivalueHistory,
        VectorUnivalueHistory,
        QueueUnivalueHistory,
      MultivalueHistory,
        DynMultivalueHistory

include("abstract_history.jl")
include("queue_uv_history.jl")
include("vector_uv_history.jl")
include("dyn_mv_history.jl")
include("recipes.jl")

end # module
