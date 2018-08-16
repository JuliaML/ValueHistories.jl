# ValueHistories

*Utility package for efficient tracking of optimization histories,
training curves or other information of arbitrary types and at
arbitrarily spaced sampling times*

| **Package Status** | **Package Evaluator** | **Build Status**  |
|:------------------:|:---------------------:|:-----------------:|
| [![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md) | [![ValueHistories](http://pkg.julialang.org/badges/ValueHistories_0.6.svg)](http://pkg.julialang.org/?pkg=ValueHistories) [![ValueHistories](http://pkg.julialang.org/badges/ValueHistories_0.7.svg)](http://pkg.julialang.org/?pkg=ValueHistories) | [![Build Status](https://travis-ci.org/JuliaML/ValueHistories.jl.svg?branch=master)](https://travis-ci.org/JuliaML/ValueHistories.jl) [![Build status](https://ci.appveyor.com/api/projects/status/8v1n9hqfnn5jslyn/branch/master?svg=true)](https://ci.appveyor.com/project/Evizero/valuehistories-jl/branch/master) [![Coverage Status](https://coveralls.io/repos/github/JuliaML/ValueHistories.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaML/ValueHistories.jl?branch=master) |

## Installation

This package is registered in `METADATA.jl` and can be installed as usual

```julia
pkg> add ValueHistories
```

## Overview

We provide two basic approaches for logging information over time
or iterations. The sample points do not have to be equally spaced as
long as time/iteration is strictly increasing.

- **Univalue histories**: Intended for tracking the evolution of
a single value over time.
- **Multivalue histories**: Track an arbitrary amount of values over
time, each of which can be of a different type and associated with
a label

*Note that both approaches are typestable.*

### Univalue Histories

This package provide two different concrete implementations

- `QHistory`: Logs the values using a `Dequeue`
- `History`: Logs the values using a `Vector`

Supported operations for univalue histories:

- `push!(history, iteration, value)`: Appends a value to the history
- `get(history)`: Returns all available observations as two vectors. The first vector contains the iterations and the second vector contains the values.
- `enumerate(history)` Returns an enumerator over the observations (as tuples)
- `first(history)`: First stored observation (as tuple)
- `last(history)`: Last stored observation (as tuple)
- `length(history)`: Number of stored observations
- `increment!(history, iteration, value)`: Similar to `push!` but increments the `value` if the `iteration` already exists. Only supported by `History`.

Here is a little example code showing the basic usage:

```julia
using Primes

# Specify the type of value you wish to track
history = QHistory(Float64)

for i = 1:100
  # Store some value of the specified type
  # Note how the sampling times are not equally spaced
  isprime(i) && push!(history, i, sin(.1*i))
end

# Access stored values as arrays
x, y = get(history)
@assert typeof(x) <: Vector{Int}
@assert typeof(y) <: Vector{Float64}

# You can also enumerate over the observations
for (x, y) in enumerate(history)
  @assert typeof(x) <: Int
  @assert typeof(y) <: Float64
end

# Let's see how this prints to the REPL
history
```

```
QHistory
    types: Int64, Float64
    length: 25
```

For easy visualisation we also provide recipes for `Plots.jl`.
Note that this is only supported for `Real` types.

```julia
using Plots
plot(history, legend=false)
```

![qhistory](https://rawgithub.com/JuliaML/FileStorage/master/ValueHistories/qhistory.svg)

### Multivalue Histories

Multivalue histories are more or less a dynamic collection of a number
of univalue histories. Each individual univalue history is associated
with a symbol `key`. If the user stores a value under a `key` that
has no univalue history associated with it, then a new one is allocated
and specialized for the given type.

Supported operations for multivalue histories:

- `push!(history, key, iteration, value)`: Appends a value to the multivalue history
- `get(history, key)`: Returns all available observations as two vectors. The first vector contains the iterations and the second vector contains the values.
- `enumerate(history, key)` Returns an enumerator over the observations (as tuples)
- `first(history, key)`: First stored observation (as tuple)
- `last(history, key)`: Last stored observation (as tuple)
- `length(history, key)`: Number of stored observations
- `increment!(history, key, iteration, value)`: Similar to `push!` but increments the `value` if the `key` and `iteration` combination already exists.

Here is a little example code showing the basic usage:

```julia
using ValueHistories, Primes
history = MVHistory()

for i=1:100
    x = 0.1i

    # Store any kind of value without losing type stability
    # The first push! to a key defines the tracked type
    #   push!(history, key, iter, value)
    push!(history, :mysin, x, sin(x))
    push!(history, :mystring, i, "i=$i")

    # Sampling times can be arbitrarily spaced
    # Note how we store the sampling time as a Float32 this time
    isprime(i) && push!(history, :mycos, Float32(x), cos(x))
end

# Access stored values as arrays
x, y = get(history, :mysin)
@assert length(x) == length(y) == 100
@assert typeof(x) <: Vector{Float64}
@assert typeof(y) <: Vector{Float64}

# Each key can be queried individually
x, y = get(history, :mystring)
@assert length(x) == length(y) == 100
@assert typeof(x) <: Vector{Int64}
@assert typeof(y) <: Vector{String}
@assert y[1] == "i=1"

# You can also enumerate over the observations
for (x, y) in enumerate(history, :mycos)
  @assert typeof(x) <: Float32
  @assert typeof(y) <: Float64
end

# Let's see how this prints to the REPL
history
```

```
MVHistory{ValueHistories.History{I,V}}
  :mysin => 100 elements {Float64,Float64}
  :mystring => 100 elements {Int64,String}
  :mycos => 25 elements {Float32,Float64}
```

For easy visualisation we also provide recipes for `Plots.jl`.
Note that this is only supported for `Real` types.

```julia
using Plots
plot(history)
```

![mvhistory](https://rawgithub.com/JuliaML/FileStorage/master/ValueHistories/mvhistory.svg)

## License

This code is free to use under the terms of the MIT license.
