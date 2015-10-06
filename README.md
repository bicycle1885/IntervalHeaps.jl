# IntervalHeaps

[![Build Status](https://travis-ci.org/bicycle1885/IntervalHeaps.jl.svg?branch=master)](https://travis-ci.org/bicycle1885/IntervalHeaps.jl)

[Double-ended priority queue (DEPQ)](https://en.wikipedia.org/wiki/Double-ended_priority_queue) based on the interval heap (Leeuwen and Wood, 1993).

Example
-------

```julia
julia> using IntervalHeaps

julia> heap = IntervalHeap([3, 1, 5, 2])
IntervalHeap{Int64}([1,2,5,3])

julia> minimum(heap), maximum(heap)
(1,5)

julia> popmin!(heap)
1

julia> minimum(heap)
2

julia> popmax!(heap)
5

julia> maximum(heap)
3

julia> push!(heap, 8)
IntervalHeap{Int64}([2,3,8])

julia> maximum(heap)
8

```

Time Complexities
-----------------

* `IntervalHeap(xs)`: O(n)
* `minimum(heap)`: O(1)
* `maximum(heap)`: O(1)
* `push!(heap)`: O(log n)
* `popmin!(heap)`: O(log n)
* `popmax!(heap)`: O(log n)


Reference
---------

* [van Leeuwen, Jan, and Derick Wood. "Interval heaps." *The Computer Journal* 36.3 (1993): 209-216.](http://comjnl.oxfordjournals.org/content/36/3/209.short)
