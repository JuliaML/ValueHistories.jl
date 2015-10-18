module ValueHistories

using DataStructures

import Base: length, push!, get, enumerate

export 

    ValueHistory,
      UnivalueHistory,
      MultivalueHistory,
        DynMultivalueHistory

include("abstract_history.jl")
include("stat_uv_history.jl")
include("dyn_mv_history.jl")

end # module
