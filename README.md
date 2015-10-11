# IntervalHeaps

[![Build Status](https://travis-ci.org/bicycle1885/IntervalHeaps.jl.svg?branch=master)](https://travis-ci.org/bicycle1885/IntervalHeaps.jl)

[Double-ended priority queue (DEPQ)](https://en.wikipedia.org/wiki/Double-ended_priority_queue) based on the interval heap (Leeuwen and Wood, 1993).

The following operations are supported (n is the number of elements):

* `IntervalHeap(xs)`: construct an interval heap from the vector `xs`, O(n)
* `push!(heap, val)`: push `val` into `heap`, O(log n)
* `pop!(heap)`: pop an element from `heap`, O(1)
* `popmin!(heap)`: pop the minimum element from `heap`, O(log n)
* `popmax!(heap)`: pop the maximum element from `heap`, O(log n)
* `minimum(heap)`: return the minimum element from `heap`, O(1)
* `maximum(heap)`: return the maximum element from `heap`, O(1)


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

julia> for x in heap; @show x; end
x = 2
x = 3
x = 8

```


Benchmarks
----------

See this Jupyter Notebook: [benchmark.ipynb](benchmark.ipynb).

Reference
---------

* [van Leeuwen, Jan, and Derick Wood. "Interval heaps." *The Computer Journal* 36.3 (1993): 209-216.](http://comjnl.oxfordjournals.org/content/36/3/209.short)
