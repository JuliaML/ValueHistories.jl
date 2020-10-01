_is_plotable_history(::UnivalueHistory) = false
_is_plotable_history(::QHistory{I,V}) where {I,V<:Real} = true
_is_plotable_history(::History{I,V}) where {I,V<:Real} = true

_filter_plotable_histories(h::MVHistory) =
    filter(p -> _is_plotable_history(p.second), h.storage)

@recipe function plot(h::Union{History,QHistory})
    markershape --> :ellipse
    title       --> "Value History"
    get(h)
end

@recipe function plot(h::MVHistory)
    filtered = _filter_plotable_histories(h)
    k_vec = [k for (k, v) in filtered]
    v_vec = [v for (k, v) in filtered]
    if length(v_vec) > 0
        markershape --> :ellipse
        label       --> reshape(map(string, k_vec), (1,length(k_vec)))
        if get(plotattributes, :layout, nothing) != nothing
            title  --> plotattributes[:label]
            legend --> false
        else
            title  --> "Multivalue History"
        end
        get_vec = map(get, v_vec)
        [x for (x, y) in get_vec], [y for (x, y) in get_vec]
    else
        throw(ArgumentError("Can't plot an empty history, nor a history with strange types"))
    end
end

@recipe function plot(hs::AbstractVector{T}) where {T<:ValueHistories.UnivalueHistory}
    for h in hs
        @series begin
            h
        end
    end
end

