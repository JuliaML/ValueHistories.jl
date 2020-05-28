using ValueHistories
using Test
using DataFrames

tests = [
    "tst_history.jl"
    "tst_mvhistory.jl"
    "tst_dataframe.jl"
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
