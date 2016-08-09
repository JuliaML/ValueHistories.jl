immutable DynMultivalueHistory{H<:UnivalueHistory} <: MultivalueHistory
    storage::Dict{Symbol, H}
end

function DynMultivalueHistory{H<:UnivalueHistory}(::Type{H} = VectorUnivalueHistory)
    DynMultivalueHistory{H}(Dict{Symbol, H}())
end

# ==========================================================================
# Functions

Base.length(history::DynMultivalueHistory, key::Symbol) = length(history.storage[key])
Base.enumerate(history::DynMultivalueHistory, key::Symbol) = enumerate(history.storage[key])
Base.first(history::DynMultivalueHistory, key::Symbol) = first(history.storage[key])
Base.last(history::DynMultivalueHistory, key::Symbol) = last(history.storage[key])

function Base.push!{I,H<:UnivalueHistory,V}(
        history::DynMultivalueHistory{H},
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

function Base.push!{H<:UnivalueHistory,V}(
        history::DynMultivalueHistory{H},
        key::Symbol,
        value::V)
    if !haskey(history.storage, key)
        _hist = H(V, Int)
        push!(_hist, value)
        history.storage[key] = _hist
    else
        push!(history.storage[key], value)
    end
    value
end

function Base.getindex(history::DynMultivalueHistory, key::Symbol)
    history.storage[key]
end

function Base.get(history::DynMultivalueHistory, key::Symbol)
    l = length(history, key)
    k, v = first(history.storage[key])
    karray = zeros(typeof(k), l)
    varray = Array(typeof(v), l)
    i = 1
    for (k, v) in enumerate(history, key)
        karray[i] = k
        varray[i] = v
        i += 1
    end
    karray, varray
end

function Base.show{H}(io::IO, history::DynMultivalueHistory{H})
    print(io, "DynMultivalueHistory{$H}")
    for (key, val) in history.storage
        print(io, "\n", "  :$(key) => $(val)")
    end
end
