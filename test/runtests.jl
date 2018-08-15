using ValueHistories
using Test

tests = [
    "tst_history.jl"
    "tst_mvhistory.jl"
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
