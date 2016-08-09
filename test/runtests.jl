using ValueHistories

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

tests = [
    "tst_stat_uv_history.jl"
    "tst_dyn_mv_history.jl"
    "tst_recipes.jl"
]

perf = [
    "bm_history.jl"
]

for t in tests
    @testset "[->] $t" begin
        include(t)
    end
end

for p in perf
    @testset "[->] $p" begin
        include(p)
    end
end
