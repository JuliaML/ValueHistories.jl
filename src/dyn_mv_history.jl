immutable DictMultivalueHistory{H<:UnivalueHistory} <: Associative{Symbol,H}
    storage::Dict{Symbol, H}
end

function DictMultivalueHistory{H<:UnivalueHistory}(::Type{H} = VectorUnivalueHistory)
    DictMultivalueHistory{H}(Dict{Symbol, H}())
end

# ============================================================
# Iterator and Associative

for fun in (:start, :enumerate, :isempty, :keytype, :valtype,
            :keys, :values, :eltype, :empty!, :length)
    @eval ($fun)(history::DictMultivalueHistory) = ($fun)(history.storage)
end

for fun in (:next, :done, :getindex)
    @eval ($fun)(history::DictMultivalueHistory, arg) = ($fun)(history.storage, arg)
end

Base.haskey(history::DictMultivalueHistory, key) = Base.haskey(history.storage, key)
Base.get(history::DictMultivalueHistory, key, default) = Base.get(history.storage, key, default)

# ============================================================
# UnivalueHistory-like interface

for fun in (:length, :enumerate, :first, :last)
    @eval ($fun)(history::DictMultivalueHistory, key::Symbol) = ($fun)(history.storage[key])
end

function Base.push!{I,H<:UnivalueHistory,V}(
        history::DictMultivalueHistory{H},
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
    history
end

function log!{I,H<:UnivalueHistory,V}(
        history::DictMultivalueHistory{H},
        key::Symbol,
        iteration::I,
        value::V)
    push!(history, key, iteration, value)
    value
end

function Base.push!{H<:UnivalueHistory,V}(
        history::DictMultivalueHistory{H},
        key::Symbol,
        value::V)
    if !haskey(history.storage, key)
        _hist = H(V, Int)
        push!(_hist, value)
        history.storage[key] = _hist
    else
        push!(history.storage[key], value)
    end
    history
end

function log!{H<:UnivalueHistory,V}(
        history::DictMultivalueHistory{H},
        key::Symbol,
        value::V)
    push!(history, key, value)
    value
end

function Base.get(history::DictMultivalueHistory, key::Symbol)
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

function Base.show{H}(io::IO, history::DictMultivalueHistory{H})
    print(io, "DictMultivalueHistory{$H}")
    for (key, val) in history.storage
        print(io, "\n", "  :$(key) => $(val)")
    end
end

