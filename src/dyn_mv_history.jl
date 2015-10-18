immutable DynMultivalueHistory{I<:Integer} <: MultivalueHistory
  storage::Dict{Symbol, Queue}
end

function DynMultivalueHistory{I<:Integer}(::Type{I} = Int64)
  DynMultivalueHistory{I}(Dict{Symbol, Queue}())
end

# ==========================================================================
# Functions

length(history::DynMultivalueHistory, key::Symbol) = length(history.storage[key])
enumerate(history::DynMultivalueHistory, key::Symbol) = history.storage[key].store

function push!{I<:Integer,V<:Any}(
    history::DynMultivalueHistory{I},
    iteration::I,
    key::Symbol,
    value::V)
  lastiter = zero(I)
  if !haskey(history.storage, key)
    iteration >= lastiter || throw(ArgumentError("Iterations must be greater than or equal to 0"))
    history.storage[key] = Queue(Tuple{I,V})
  else
    lastiter, _ = back(history.storage[key])
    iteration > lastiter || throw(ArgumentError("Iterations must increase over time"))
  end
  enqueue!(history.storage[key], (iteration, value))
  value
end

function get{I<:Integer}(history::DynMultivalueHistory{I}, key::Symbol)
  l = length(history, key)
  k, v = front(history.storage[key])
  karray = zeros(I, l)
  varray = Array(typeof(v), l)
  i = 1
  for (k, v) in enumerate(history, key)
    karray[i] = k
    varray[i] = v
    i += 1
  end
  karray, varray
end
