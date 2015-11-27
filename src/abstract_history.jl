abstract ValueHistory
abstract UnivalueHistory{I} <: ValueHistory
abstract MultivalueHistory <: ValueHistory

Base.push!(history::UnivalueHistory, iteration, value) =
    throw(ArgumentError("The specified arguments are of incompatible type"))

# length(history::ValueHistory) =  error()
# enumerate(history::ValueHistory) = error()
# get(history::ValueHistory) = error()
# first(history::ValueHistory) = error()
# last(history::ValueHistory) = error()
