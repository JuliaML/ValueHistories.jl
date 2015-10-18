
#-----------------------------------------------------------

msg("QueueUnivalueHistory: Basic functions")

_history = QueueUnivalueHistory(Float64)

@test push!(_history, 0, 10.) == 10.
@test push!(_history, 1, 21.) == 21.

@test_throws ArgumentError push!(_history, 0, 11.)
@test_throws ArgumentError push!(_history, 2, 10)

_history = QueueUnivalueHistory(Float64)

numbers = collect(1:2:200)
for i = numbers
  @test push!(_history, i, Float64(i + 1)) == Float64(i + 1)
end

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

#-----------------------------------------------------------

msg("QueueUnivalueHistory: Storing arbitrary types")

_history = QueueUnivalueHistory(ASCIIString, UInt8)

for i = 1:100
  @test push!(_history, i % UInt8, string("i=", i + 1)) == string("i=", i+1)
end

a1, a2 = get(_history)
@test typeof(a1) <: Vector{UInt8}
@test typeof(a2) <: Vector{ASCIIString}
