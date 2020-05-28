function Base.convert(::Type{DataFrame}, h::MVHistory)
    names = collect(keys(h))
    dfs = map(names) do key
        iters, vals = get(h, key)
        DataFrame([iters, vals], [:iter, key])
    end
    return join(dfs..., on = :iter, kind = :outer)
end

function Base.convert(::Type{DataFrame}, h::History)
    DataFrame(get(h), [:iter, :val])
end
