module ValueHistories

using DataStructures

import Base: length, push!, get, enumerate, last, first, getindex

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

end # module
