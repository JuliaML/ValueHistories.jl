@testset "DataFrame" begin
    h = History(Float64)
    mvh = MVHistory()
    for i in 1:10
        push!(h, i, rand())
        push!(mvh, :val1, i, "$i")
        push!(mvh, :val2, i, rand(3))
    end

    dfh = convert(DataFrame, h)
    @test names(dfh) == [:iter, :val]
    @test size(dfh) == (10, 2)
    @test eltype(dfh.val) == Float64

    push!(mvh, :val1, 13, "notmissing")
    dfmvh = convert(DataFrame, mvh)
    @test names(dfmvh) == vcat(:iter, collect(keys(mvh)))
    @test size(dfmvh) == (11, 3)
    @test eltype(dfmvh.val1) == Union{Missing, String}
end
