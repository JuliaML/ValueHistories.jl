module ValueHistories

using DataStructures
using RecipesBase

import DataStructures: front, back
import Base: start, enumerate, isempty,
             eltype, empty!, length,
             next, done, getindex,
             first, last

export

    log!,

    UnivalueHistory,
        VectorUnivalueHistory,
        QueueUnivalueHistory,
    MultivalueHistory,
        DictMultivalueHistory,
        DynMultivalueHistory # deprecated

include("queue_uv_history.jl")
include("vector_uv_history.jl")

typealias UnivalueHistory{I} Union{VectorUnivalueHistory{I}, QueueUnivalueHistory{I}}
Base.push!(history::UnivalueHistory, iteration, value) =
    throw(ArgumentError("The specified arguments are of incompatible type"))

include("dyn_mv_history.jl")

typealias MultivalueHistory DictMultivalueHistory
typealias ValueHistory Union{MultivalueHistory,UnivalueHistory}

include("recipes.jl")

Base.@deprecate_binding DynMultivalueHistory DictMultivalueHistory

end

