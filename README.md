# ValueHistories

Utility package for efficient tracking of optimization histories, training curves or other information of arbitray types with arbitrary sampling times

## Installation

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
