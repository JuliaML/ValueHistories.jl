immutable QueueUnivalueHistory{I<:Real,V} <: UnivalueHistory{I}
  lastiter::I
  storage::Queue{Deque{Tuple{I,V}}}

  function QueueUnivalueHistory(::Type{V}, ::Type{I})
    new(zero(I), Queue(Tuple{I,V}))
  end
end

function QueueUnivalueHistory{I,V}(v::Type{V}, i::Type{I} = Int64)
  QueueUnivalueHistory{I,V}(v, i)
end

# ==========================================================================
#

length(history::QueueUnivalueHistory) = length(history.storage)
enumerate(history::QueueUnivalueHistory) = history.storage.store
first(history::QueueUnivalueHistory) = front(history.storage)
last(history::QueueUnivalueHistory) = back(history.storage)

function push!{I<:Real,V}(
    history::QueueUnivalueHistory{I,V},
    iteration::I,
    value::V)
  lastiter = zero(I)
  if !isempty(history.storage)
    lastiter = history.lastiter
    iteration > lastiter || throw(ArgumentError("Iterations must increase over time"))
  end
  enqueue!(history.storage, (iteration, value))
  value
end

function get{I<:Real,V}(history::QueueUnivalueHistory{I,V})
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
