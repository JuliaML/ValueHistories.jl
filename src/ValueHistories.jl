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


end # module
