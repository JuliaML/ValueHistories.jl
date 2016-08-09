function msg(args...; newline = true)
    print("   --> ", args...)
    newline && println()
end

n = 100

msg("Baseline: $n loops that accumulates a Float64")

function f()
    tmp = 0.
    for i=1:n
        tmp += i * 3.
    end
end

@time f()
@time f()

#-----------------------------------------------------------

for T in [VectorUnivalueHistory, QueueUnivalueHistory]

    msg("$(T.name.name): $n loops tracking accumulator of accumulator as Float64")

    function g()
        tmp = 0.
        for i=1:n
            tmp += i * 3.
            push!(_history, i, tmp)
        end
    end

    _history = T(Float64)
    @time g()

    _history = T(Float64)
    @time g()

    msg("$(T.name.name): Converting result into arrays")

    @time x,y = get(_history)
    @time x,y = get(_history)
end

#-----------------------------------------------------------

msg("DynMultivalueHistory: $n loops tracking accumulator as Float64 and String")

function g()
    tmp = 0.
    for i=1:n
        tmp += i * 3.
        push!(_history, :myint, i, tmp)
        push!(_history, :mystr, i, string(tmp))
    end
end

_history = DynMultivalueHistory(VectorUnivalueHistory)
@time g()

_history = DynMultivalueHistory(VectorUnivalueHistory)
@time g()

msg("DynMultivalueHistory: Converting result into arrays")

@time x,y = get(_history, :mystr)
@time x,y = get(_history, :mystr)

@test length(y) == n
@test typeof(y) <: Vector{ASCIIString}
