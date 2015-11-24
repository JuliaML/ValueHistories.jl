using ValueHistories
using Base.Test

function msg(args...; newline = true)
    print("   --> ", args...)
    newline && println()
end

# ==========================================================================
# Specify tests

tests = [
    "tst_stat_uv_history.jl"
    "tst_dyn_mv_history.jl"
]

perf = [
    "bm_history.jl"
]

for t in tests
    println("[->] $t")
    include(t)
    println("[OK] $t")
    println("====================================================================")
end

for p in perf
    println("[->] $p")
    include(p)
    println("[OK] $p")
    println("====================================================================")
end
