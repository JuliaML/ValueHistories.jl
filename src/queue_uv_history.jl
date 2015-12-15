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

Base.length(history::QueueUnivalueHistory) = length(history.storage)
Base.enumerate(history::QueueUnivalueHistory) = history.storage
Base.first(history::QueueUnivalueHistory) = front(history.storage)
Base.last(history::QueueUnivalueHistory) = back(history.storage)

function Base.push!{I,V}(
        history::QueueUnivalueHistory{I,V},
        iteration::I,
        value::V)
    lastiter = history.lastiter
    iteration > lastiter || throw(ArgumentError("Iterations must increase over time"))
    history.lastiter = iteration
    push!(history.storage, (iteration, value))
    value
end

function Base.push!{I,V}(
        history::QueueUnivalueHistory{I,V},
        value::V)
    lastiter = history.lastiter == typemin(I) ? zero(I) : history.lastiter
    iteration = lastiter + one(history.lastiter)
    history.lastiter = iteration
    push!(history.storage, (iteration, value))
    value
end

function Base.get{I,V}(history::QueueUnivalueHistory{I,V})
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

Base.print{I,V}(io::IO, history::QueueUnivalueHistory{I,V}) = print(io, "$(length(history)) elements {$I,$V}")

function Base.show{I,V}(io::IO, history::QueueUnivalueHistory{I,V})
    println(io, "QueueUnivalueHistory")
    println(io, "    types: $I, $V")
    print(io,   "    length: $(length(history))")
end
