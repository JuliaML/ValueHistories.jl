type VectorUnivalueHistory{I,V} <: UnivalueHistory{I}
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

Base.length(history::VectorUnivalueHistory) = length(history.iterations)
Base.enumerate(history::VectorUnivalueHistory) = zip(history.iterations, history.values)
Base.first(history::VectorUnivalueHistory) = history.iterations[1], history.values[1]
Base.last(history::VectorUnivalueHistory) = history.iterations[end], history.values[end]
Base.get(history::VectorUnivalueHistory) = history.iterations, history.values

function Base.push!{I,V}(
        history::VectorUnivalueHistory{I,V},
        iteration::I,
        value::V)
    lastiter = history.lastiter
    iteration > lastiter || throw(ArgumentError("Iterations must increase over time"))
    history.lastiter = iteration
    push!(history.iterations, iteration)
    push!(history.values, value)
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
    value
end

Base.print{I,V}(io::IO, history::VectorUnivalueHistory{I,V}) = print(io, "$(length(history)) elements {$I,$V}")

function Base.show{I,V}(io::IO, history::VectorUnivalueHistory{I,V})
    println(io, "VectorUnivalueHistory")
    println(io, "  * types: $I, $V")
    print(io,   "  * length: $(length(history))")
end
