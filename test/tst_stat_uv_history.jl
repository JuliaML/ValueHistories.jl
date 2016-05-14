for T in [VectorUnivalueHistory, QueueUnivalueHistory]
    @testset "$(T.name.name): Basic functions" begin
        _history = T(Float64)

        @test push!(_history, 1, 10.) == 10.
        @test push!(_history, 2, 21.) == 21.

        @test_throws ArgumentError push!(_history, 1, 11.)
        @test_throws ArgumentError push!(_history, 2, 10)

        _history = T(Float64)

        numbers = collect(1:100)
        push!(_history, 10, Float64(5))
        for i = numbers
            @test push!(_history, Float64(i + 1)) == Float64(i + 1)
        end

        @test first(_history) == (10, 5.)
        @test last(_history) == (110, 101.)

        _history = T(Float64)

        numbers = collect(1:2:200)
        for i = numbers
            @test push!(_history, i, Float64(i + 1)) == Float64(i + 1)
        end

        println(_history)
        show(_history); println()

        @test first(_history) == (1, 2.)
        @test last(_history) == (199, 200.)

        for (i, v) in enumerate(_history)
            @test in(i, numbers)
            @test Float64(i + 1) == v
        end

        a1, a2 = get(_history)
        @test typeof(a1) <: Vector{Int} && typeof(a2) <: Vector{Float64}
        @test length(a1) == length(a2) == length(numbers) == length(_history)
        @test convert(Vector{Float64}, a1 + 1) == a2
    end

    @testset "$(T.name.name): No explicit iteration" begin
        _history = T(Float64)
    end

    @testset "$(T.name.name): Storing arbitrary types" begin
        _history = T(ASCIIString, UInt8)

        for i = 1:100
            @test push!(_history, i % UInt8, string("i=", i + 1)) == string("i=", i+1)
        end

        show(_history); println()

        a1, a2 = get(_history)
        @test typeof(a1) <: Vector{UInt8}
        @test typeof(a2) <: Vector{ASCIIString}
    end
end
