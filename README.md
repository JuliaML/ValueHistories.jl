# ValueHistories

## Installation

Developed for Julia  v0.4

[![Package Evaluator v4](http://pkg.julialang.org/badges/ValueHistories_0.4.svg)](http://pkg.julialang.org/?pkg=ValueHistories&ver=0.4)

```Julia
Pkg.add("ValueHistories")
using ValueHistories
```

For the latest developer version:

[![Build Status](https://travis-ci.org/Evizero/ValueHistories.jl.svg?branch=master)](https://travis-ci.org/Evizero/ValueHistories.jl)

```Julia
Pkg.checkout("ValueHistories")
```

## Benchmarks

```
Baseline: 100000 loops that accumulates a Float64
  0.018450 seconds (498.98 k allocations: 9.140 MB, 15.75% gc time)

VectorUnivalueHistory: 100000 loops tracking accumulator of accumulator as Float64
  0.024337 seconds (599.01 k allocations: 14.667 MB, 7.92% gc time)
VectorUnivalueHistory: Converting result into arrays
  0.000009 seconds (3 allocations: 96 bytes)

QueueUnivalueHistory: 100000 loops tracking accumulator of accumulator as Float64
  0.020105 seconds (599.17 k allocations: 12.195 MB)
QueueUnivalueHistory: Converting result into arrays
  0.003722 seconds (100.01 k allocations: 4.578 MB, 58.66% gc time)

DynMultivalueHistory: 100000 loops tracking accumulator as Float64 and String
  0.194958 seconds (2.10 M allocations: 70.558 MB, 22.73% gc time)
DynMultivalueHistory: Converting result into arrays
  0.110471 seconds (1.39 M allocations: 28.914 MB, 17.87% gc time)
```

## License

This code is free to use under the terms of the MIT license.
