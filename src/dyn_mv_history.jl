immutable DynMultivalueHistory{I<:Integer, H<:UnivalueHistory} <: MultivalueHistory
  storage::Dict{Symbol, H}
end

function DynMultivalueHistory{I<:Integer, H<:UnivalueHistory}(::Type{H} = QueueUnivalueHistory, ::Type{I} = Int64)
  DynMultivalueHistory{I,H}(Dict{Symbol, H}())
end

# ==========================================================================
# Functions

length(history::DynMultivalueHistory, key::Symbol) = length(history.storage[key])
enumerate(history::DynMultivalueHistory, key::Symbol) = enumerate(history.storage[key])
first(history::DynMultivalueHistory, key::Symbol) = first(history.storage[key])
last(history::DynMultivalueHistory, key::Symbol) = last(history.storage[key])

function push!{I<:Integer,H<:UnivalueHistory,V}(
    history::DynMultivalueHistory{I,H},
    key::Symbol,
    iteration::I,
    value::V)
  if !haskey(history.storage, key)
    _hist = H(V, I)
    push!(_hist, iteration, value)
    history.storage[key] = _hist
  else
    push!(history.storage[key], iteration, value)
  end
  value
end

function get{I<:Integer}(history::DynMultivalueHistory{I}, key::Symbol)
  l = length(history, key)
  k, v = first(history.storage[key])
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
