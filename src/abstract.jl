abstract type ValueHistory end
abstract type UnivalueHistory{I} <: ValueHistory end
abstract type MultivalueHistory <: ValueHistory end

Base.push!(history::UnivalueHistory, iteration, value) =
    throw(ArgumentError("The specified arguments are of incompatible type"))

# length(history::ValueHistory) =  error()
# enumerate(history::ValueHistory) = error()
# get(history::ValueHistory) = error()
# first(history::ValueHistory) = error()
# last(history::ValueHistory) = error()
