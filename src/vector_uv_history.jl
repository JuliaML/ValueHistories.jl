type VectorUnivalueHistory{I,V} <: AbstractVector{Tuple{I,V}}
    lastiter::I
    iterations::Vector{I}
    values::Vector{V}

    function VectorUnivalueHistory(::Type{V}, ::Type{I})
        new(typemin(I), Array(I, 0), Array(V, 0))
    end
end

function VectorUnivalueHistory{I,V}(v::Type{V}, i::Type{I} = Int64)
    VectorUnivalueHistory{I,V}(v, i)
end

# ============================================================
# AbstractArray

Base.endof(history::VectorUnivalueHistory) = length(history)
Base.size(history::VectorUnivalueHistory) = (length(history),)
#Base.linearindexing{T<:VectorUnivalueHistory}(::Type{T}) = Base.LinearFast
Base.getindex(history::VectorUnivalueHistory, idx) = (history.iterations[idx], history.values[idx])
function Base.setindex!{I,V}(history::VectorUnivalueHistory{I,V}, tup::Tuple{I,V}, idx::Int)
    i, v = tup
    history.iterations[idx] = i
    history.values[idx] = v
    history
end

# ============================================================
# Iterator

Base.start(history::VectorUnivalueHistory) = 1
function Base.next(history::VectorUnivalueHistory, state)
    i, si = next(history.iterations, state)
    v, sv = next(history.iterations, state)
    (i,v), si
end
Base.done(history::VectorUnivalueHistory, state) = done(history.iterations, state)
Base.eltype{I,V}(history::VectorUnivalueHistory{I,V}) = Tuple{I,V}
Base.length(history::VectorUnivalueHistory) = length(history.iterations)

# ============================================================
# Collection

Base.isempty(history::VectorUnivalueHistory) = isempty(history.iterations)
function Base.empty!{I}(history::VectorUnivalueHistory{I})
    empty!(history.iterations)
    empty!(history.values)
    history.lastiter = typemin(I)
    history
end

Base.first(history::VectorUnivalueHistory) = history[1]
Base.last(history::VectorUnivalueHistory) = history[end]
Base.enumerate(history::VectorUnivalueHistory) = zip(history.iterations, history.values)
Base.get(history::VectorUnivalueHistory) = history.iterations, history.values

# ============================================================
# UnivalueHistory interface

function Base.push!{I,V}(
        history::VectorUnivalueHistory{I,V},
        iteration::I,
        value::V)
    lastiter = history.lastiter
    iteration > lastiter || throw(ArgumentError("Iterations must increase over time"))
    history.lastiter = iteration
    push!(history.iterations, iteration)
    push!(history.values, value)
    history
end

function log!{I,V}(
        history::VectorUnivalueHistory{I,V},
        iteration::I,
        value::V)
    push!(history, iteration, value)
    value
end

function Base.push!{I,V}(
        history::VectorUnivalueHistory{I,V},
        value::V)
    lastiter = history.lastiter == typemin(I) ? zero(I) : history.lastiter
    iteration = lastiter + one(history.lastiter)
    history.lastiter = iteration
    push!(history.iterations, iteration)
    push!(history.values, value)
    history
end

function log!{I,V}(
        history::VectorUnivalueHistory{I,V},
        value::V)
    push!(history, value)
    value
end

Base.show{I,V}(io::IO, history::VectorUnivalueHistory{I,V}) = print(io, "$(length(history)) elements {$I,$V}")
#Base.print{I,V}(io::IO, history::VectorUnivalueHistory{I,V}) = print(io, "$(length(history)) elements {$I,$V}")

#function Base.show{I,V}(io::IO, history::VectorUnivalueHistory{I,V})
#    println(io, "VectorUnivalueHistory")
#    println(io, "  * types: $I, $V")
#    print(io,   "  * length: $(length(history))")
#end

