module ValueHistories

using DataStructures
using RecipesBase
using Requires

export

    ValueHistory,
      UnivalueHistory,
        History,
        QHistory,
      MultivalueHistory,
        MVHistory,
        increment!,
    @trace

include("abstract.jl")
include("history.jl")
include("qhistory.jl")
include("mvhistory.jl")
include("recipes.jl")

function __init__()
    @require DataFrames="a93c6f00-e57d-5684-b7b6-d8193f3e46c0" include("dataframe.jl")
end

end # module
