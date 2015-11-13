type QueueUnivalueHistory{I,V} <: UnivalueHistory{I}
  lastiter::I
  storage::Deque{Tuple{I,V}}

  function QueueUnivalueHistory(::Type{V}, ::Type{I})
    new(typemin(I), Deque{Tuple{I,V}}())
  end
end

function QueueUnivalueHistory{I,V}(v::Type{V}, i::Type{I} = Int64)
  QueueUnivalueHistory{I,V}(v, i)
end

# ==========================================================================
#

length(history::QueueUnivalueHistory) = length(history.storage)
enumerate(history::QueueUnivalueHistory) = history.storage
first(history::QueueUnivalueHistory) = front(history.storage)
last(history::QueueUnivalueHistory) = back(history.storage)

function push!{I,V}(
    history::QueueUnivalueHistory{I,V},
    iteration::I,
    value::V)
  lastiter = history.lastiter
  iteration > lastiter || throw(ArgumentError("Iterations must increase over time"))
  history.lastiter = iteration
  push!(history.storage, (iteration, value))
  value
end

function get{I,V}(history::QueueUnivalueHistory{I,V})
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
