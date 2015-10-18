immutable UnivalueHistory{I<:Integer,V} <: ValueHistory
  storage::Queue{Deque{Tuple{I,V}}}
end

function UnivalueHistory{I<:Integer,V}(::Type{V}, ::Type{I} = Int64)
  UnivalueHistory{I,V}(Queue(Tuple{I,V}))
end

# ==========================================================================
#

length(history::UnivalueHistory) = length(history.storage)
enumerate(history::UnivalueHistory) = history.storage.store

function push!{I<:Integer,V}(
    history::UnivalueHistory{I,V},
    iteration::I,
    value::V)
  lastiter = zero(I)
  if !isempty(history.storage)
    lastiter, _ = back(history.storage)
    iteration > lastiter || throw(ArgumentError("Iterations must increase over time"))
  end
  enqueue!(history.storage, (iteration, value))
  value
end

function get{I<:Integer,V}(history::UnivalueHistory{I,V})
  l = length(history)
  k, v = front(history.storage)
  karray = zeros(I, l)
  varray = Array(V, l)
  i = 1
  for (k, v) in enumerate(history)
    karray[i] = k
    varray[i] = v
    i += 1
  end
  karray, varray
end
