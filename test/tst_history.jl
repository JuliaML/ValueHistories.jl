for T in [History, QHistory]
    @testset "$(T): Basic functions" begin
        _history = T(Float64)

        @test push!(_history, 1, 10.) == Float64(10.)
        @test push!(_history, 2, Float64(21.)) == Float64(21.)

        @test_throws ArgumentError push!(_history, 1, Float64(11.))
        @test_throws ArgumentError push!(_history, 2, 10)
        @test_throws ArgumentError push!(_history, 3, Float32(10))

        _history = T(Float64)

        numbers = collect(1:100)
        push!(_history, 10, Float64(5))
        for i = numbers
            @test push!(_history, Float64(i + 1)) == Float64(i + 1)
        end

        @test first(_history) == (10, Float64(5.))
        @test last(_history) == (110, Float64(101.))

        _history = T(Float64)

        numbers = collect(1:2:200)
        for i = numbers
            @test push!(_history, i, Float64(i + 1)) == Float64(i + 1)
        end

        println(_history)
        show(_history); println()

        @test first(_history) == (1, Float64(2.))
        @test last(_history) == (199, Float64(200.))

        for (i, v) in enumerate(_history)
            @test in(i, numbers)
            @test Float64(i + 1) == v
        end

        a1, a2 = get(_history)
        @test typeof(a1) <: Vector{Int} && typeof(a2) <: Vector{Float64}
        @test length(a1) == length(a2) == length(numbers) == length(_history)
        @test convert(Vector{Float64}, a1 .+ 1) == a2
    end

    @testset "$(T): No explicit iteration" begin
        _history = T(Float64)
    end

    @testset "$(T): Storing arbitrary types" begin
        _history = T(String, UInt8)

        for i = 1:100
            @test push!(_history, i % UInt8, string("i=", i + 1)) == string("i=", i+1)
        end

        show(_history); println()

        a1, a2 = get(_history)
        @test typeof(a1) <: Vector{UInt8}
        @test typeof(a2) <: Vector{String}
    end
end


@testset "History: increment!" begin
    _history = History(Float64)
    val = 1.
    @test increment!(_history, 0, val) == val
    @test increment!(_history, 0, val) == 2val
    @test increment!(_history, 2, 4val) == 4val
    @test increment!(_history, 10, 5val) == 5val
    _history2 = QHistory(Float64)
    @test_throws MethodError increment!(_history2, 1, val) == val
end
