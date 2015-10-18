module ValueHistories

using DataStructures

import Base: length, push!, get, enumerate, last, first

export 

    ValueHistory,
      UnivalueHistory,
        QueueUnivalueHistory,
      MultivalueHistory,
        DynMultivalueHistory

include("abstract_history.jl")
include("queue_uv_history.jl")
include("dyn_mv_history.jl")

end # module
