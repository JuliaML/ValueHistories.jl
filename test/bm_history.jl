using ValueHistories

function msg(args...; newline = true)
    print("   --> ", args...)
    newline && println()
end

n = 100 # increase to match benchmark

msg("Baseline: $n loops that accumulates a Float64")

function f(n)
    tmp = 0.
    for i=1:n
        tmp += i * 3.
    end
    tmp
end

@time f(n)
@time f(n)

#-----------------------------------------------------------

for T in [VectorUnivalueHistory, QueueUnivalueHistory]

    msg("$(T.name.name): $n loops tracking accumulator as Float64")

    function g(_history,n)
        tmp = 0.
        for i=1:n
            tmp += i * 3.
            push!(_history, i, tmp)
        end
        tmp
    end

    _history = T(Float64)
    @time g(_history,n)

    _history = T(Float64)
    @time g(_history,n)

    msg("$(T.name.name): Converting result into arrays")

    @time x,y = get(_history)
    @time x,y = get(_history)
end

#-----------------------------------------------------------

msg("DynMultivalueHistory: $n loops tracking accumulator as Float64 and String")

function g(_history,n)
    tmp = 0.
    for i=1:n
        tmp += i * 3.
        push!(_history, :myint, i, tmp)
        push!(_history, :mystr, i, string(tmp))
    end
    tmp
end

_history = DynMultivalueHistory(VectorUnivalueHistory)
@time g(_history,n)

_history = DynMultivalueHistory(VectorUnivalueHistory)
@time g(_history,n)

msg("DynMultivalueHistory: Converting result into arrays")

@time x,y = get(_history, :mystr)
@time x,y = get(_history, :mystr)

@assert length(y) == n
@assert typeof(y) <: Vector{ASCIIString}
