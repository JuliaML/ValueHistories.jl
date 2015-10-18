
#-----------------------------------------------------------

msg("DynMultivalueHistory: Basic functions")

_history = DynMultivalueHistory()

function f(i, b; muh=10)
  @test b == "yo"
  @test muh == .3
  i
end

function f2(i, b; muh=10)
  @test b == "my"
  @test muh == .1
  i
end

@test_throws ArgumentError push!(_history, -1, :myf, f(10, "yo", muh = .3))

numbers = collect(0:2:100)
for i = numbers
  @test push!(_history, i, :myf, f(i + 1, "yo", muh = .3)) == i + 1
end

for (i, v) in enumerate(_history, :myf)
  @test in(i, numbers)
  @test i + 1 == v
end

a1, a2 = get(_history, :myf)
@test typeof(a1) <: Vector && typeof(a2) <: Vector
@test length(a1) == length(a2) == length(numbers) == length(_history, :myf)
@test a1 + 1 == a2

@test_throws ArgumentError push!(_history, 10, :myf, f(10, "yo", muh = .3))
@test_throws KeyError enumerate(_history, :sign)
@test_throws KeyError length(_history, :sign)

#-----------------------------------------------------------

msg("DynMultivalueHistory: Storing arbitrary types")

_history = DynMultivalueHistory(UInt8)

for i = 1:100
  @test push!(_history, i % UInt8, :mystring, string("i=", i + 1)) == string("i=", i+1)
  @test push!(_history, i % UInt8, :myfloat, Float32(i + 1)) == Float32(i+1)
end

a1, a2 = get(_history, :mystring)
@test typeof(a1) <: Vector{UInt8}
for entry in a2
  @test typeof(entry) <: ASCIIString
end

a1, a2 = get(_history, :myfloat)
@test typeof(a1) <: Vector{UInt8}
for entry in a2
  @test typeof(entry) <: Float32
end
