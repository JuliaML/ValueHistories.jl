# ValueHistories

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md)

Utility package for efficient tracking of optimization histories, training curves or other information of arbitrary types and at arbitrarily spaced sampling times

## Installation

[![Package Evaluator v4](http://pkg.julialang.org/badges/ValueHistories_0.4.svg)](http://pkg.julialang.org/?pkg=ValueHistories&ver=0.4)

```Julia
Pkg.add("ValueHistories")
using ValueHistories
```

For the latest developer version:

[![Build Status](https://travis-ci.org/JuliaML/ValueHistories.jl.svg?branch=master)](https://travis-ci.org/JuliaML/ValueHistories.jl)
[![Coverage Status](https://coveralls.io/repos/github/JuliaML/ValueHistories.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaML/ValueHistories.jl?branch=master)

```Julia
Pkg.checkout("ValueHistories")
```

## Overview

Available history types:

- `QueueUnivalueHistory`
- `VectorUnivalueHistory`
- `DynMultivalueHistory`

Supported operations for univalue histories:

- `push!(history, iteration, value)`: Appends a value to the history
- `get(history)`: Returns all available observations as two vectors. The first vector contains the iterations and the second vector contains the values.
- `enumerate(history)` Returns an enumerator over the observations (as tuples)
- `first(history)`: First stored observation (as tuple)
- `last(history)`: Last stored observation (as tuple)
- `length(history)`: Number of stored observations

Supported operations for multivalue histories:

- `push!(history, key, iteration, value)`: Appends a value to the multivalue history
- `get(history, key)`: Returns all available observations as two vectors. The first vector contains the iterations and the second vector contains the values.
- `enumerate(history, key)` Returns an enumerator over the observations (as tuples)
- `first(history, key)`: First stored observation (as tuple)
- `last(history, key)`: Last stored observation (as tuple)
- `length(history, key)`: Number of stored observations

### Tracking a single value

```Julia
# Specify the type of value you wish to track
history = QueueUnivalueHistory(Float64)

for i = 1:100
  # Store some value of the specified type
  push!(history, i, i / 2)
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
```

### Tracking multiple values dynamically

```Julia
history = DynMultivalueHistory()

for i = 1:100
  # Store any kind of value without losing type stability
  # The first push! to a key defines the tracked type
  #   push!(history, key, iter, value)
  push!(history, :myval1, i, i / 2)

  # Sampling times can be arbitrarily spaced
  i % 10 == 0 && i != 20 && push!(history, :myval2, float(i), "i=$i")
end

# Access stored values as arrays
x, y = get(history, :myval1)
@assert length(x) == length(y) == 100
@assert typeof(x) <: Vector{Int}
@assert typeof(y) <: Vector{Float64}

x, y = get(history, :myval2)
@assert length(x) == length(y) == 9
@assert x == [10., 30., 40., 50., 60., 70., 80., 90., 100.]
@assert y == ["i=10", "i=30", "i=40", "i=50", "i=60", "i=70", "i=80", "i=90", "i=100"]
@assert typeof(x) <: Vector{Float64}
@assert typeof(y) <: Vector{ASCIIString}

# You can also enumerate over the observations
for (x, y) in enumerate(history, :myval2)
  @assert typeof(x) <: Float64
  @assert typeof(y) <: ASCIIString
end
```

## Benchmarks

Compilation already taken into account. The code can be found [here](https://github.com/Evizero/ValueHistories.jl/blob/master/test/bm_history.jl)

```
Baseline: 100000 iterations that accumulates a Float64
  0.018450 seconds (498.98 k allocations: 9.140 MB, 15.75% gc time)

VectorUnivalueHistory: 100000 iterations tracking accumulator of accumulator as Float64
  0.024337 seconds (599.01 k allocations: 14.667 MB, 7.92% gc time)
VectorUnivalueHistory: Converting result into arrays
  0.000009 seconds (3 allocations: 96 bytes)

QueueUnivalueHistory: 100000 iterations tracking accumulator of accumulator as Float64
  0.020105 seconds (599.17 k allocations: 12.195 MB)
QueueUnivalueHistory: Converting result into arrays
  0.003722 seconds (100.01 k allocations: 4.578 MB, 58.66% gc time)

DynMultivalueHistory: 100000 iterations tracking accumulator as Float64 and String
  0.194958 seconds (2.10 M allocations: 70.558 MB, 22.73% gc time)
DynMultivalueHistory: Converting result into arrays
  0.110471 seconds (1.39 M allocations: 28.914 MB, 17.87% gc time)
```

## License

This code is free to use under the terms of the MIT license.
