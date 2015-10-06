module IntervalHeaps

export
    IntervalHeap,
    popmin!,
    popmax!

type IntervalHeap{T}
    minheap::Vector{T}
    maxheap::Vector{T}
    len::Int
end

function Base.call{T}(::Type{IntervalHeap{T}})
    return IntervalHeap{T}(T[], T[], 0)
end

function Base.call(::Type{IntervalHeap})
    return IntervalHeap{Any}([], [], 0)
end

function Base.convert{T}(::Type{IntervalHeap}, xs::AbstractVector{T})
    heap = IntervalHeap{T}()
    if isempty(xs)
        return heap
    end
    minheap = heap.minheap
    maxheap = heap.maxheap
    n = cld(length(xs), 2)
    resize!(minheap, n)
    resize!(maxheap, n)
    for i in 1:n-1
        minheap[i] = xs[2i-1]
        maxheap[i] = xs[2i]
    end
    # the last node needs special handling
    if iseven(length(xs))
        minheap[n] = xs[2n-1]
        maxheap[n] = xs[2n]
    else
        minheap[n] = xs[2n-1]
        maxheap[n] = xs[2n-1]
    end
    heap.len = length(xs)
    for i in n:-1:1
        fix_down!(heap, i)
    end
    return heap
end

Base.isempty(h::IntervalHeap) = h.len == 0
Base.length(h::IntervalHeap)  = h.len

function Base.push!{T}(heap::IntervalHeap{T}, val::T)
    minheap = heap.minheap
    maxheap = heap.maxheap
    if iseven(length(heap))
        push!(minheap, val)
        push!(maxheap, val)
    else
        maxheap[end] = val
    end
    heap.len += 1
    fix_up!(heap, endof(minheap))
    return heap
end

function popmin!(heap::IntervalHeap)
    check_nonempty(heap)
    minheap = heap.minheap
    maxheap = heap.maxheap
    min = heap.minheap[1]
    if iseven(length(heap))
        minheap[1] = maxheap[end]
        maxheap[end] = minheap[end]
    else
        minheap[1] = minheap[end]
        pop!(minheap)
        pop!(maxheap)
    end
    heap.len -= 1
    fix_down!(heap, 1)
    return min
end

function popmax!(heap::IntervalHeap)
    check_nonempty(heap)
    minheap = heap.minheap
    maxheap = heap.maxheap
    max = heap.maxheap[1]
    if iseven(length(heap))
        maxheap[1] = minheap[end]
        minheap[end] = maxheap[end]
    else
        maxheap[1] = maxheap[end]
        pop!(minheap)
        pop!(maxheap)
    end
    heap.len -= 1
    fix_down!(heap, 1)
    return max
end

function fix_interval!(heap, i)
    minheap = heap.minheap
    maxheap = heap.maxheap
    if minheap[i] > maxheap[i]
        minheap[i], maxheap[i] = maxheap[i], minheap[i]
    end
end

function fix_up!(heap, i)
    minheap = heap.minheap
    maxheap = heap.maxheap
    fix_interval!(heap, i)
    if !isroot(i)
        p = parent(i)
        if minheap[p] > minheap[i]
            swapmin!(heap, p, i)
            fix_up!(heap, p)
        end
        if maxheap[p] < maxheap[i]
            swapmax!(heap, p, i)
            fix_up!(heap, p)
        end
    end
end

function fix_down!(heap, i)
    if isempty(heap)
        return
    end
    minheap = heap.minheap
    maxheap = heap.maxheap
    fix_interval!(heap, i)
    l = left(i)
    r = right(i)
    # fix minheap
    min = i
    if l ≤ endof(minheap) && minheap[l] < minheap[min]
        min = l
    end
    if r ≤ endof(minheap) && minheap[r] < minheap[min]
        min = r
    end
    if min != i
        swapmin!(heap, i, min)
        fix_down!(heap, min)
    end
    # fix maxheap
    max = i
    if l ≤ endof(maxheap) && maxheap[l] > maxheap[max]
        max = l
    end
    if r ≤ endof(maxheap) && maxheap[r] > maxheap[max]
        max = r
    end
    if max != i
        swapmax!(heap, i, max)
        fix_down!(heap, max)
    end
    return
end

function swapmin!(heap, p, i)
    @assert p < i
    minheap = heap.minheap
    maxheap = heap.maxheap
    minheap[i], minheap[p] = minheap[p], minheap[i]
    if i == endof(minheap) && isodd(length(heap))
        maxheap[i] = minheap[i]
    end
end

function swapmax!(heap, p, i)
    @assert p < i
    minheap = heap.minheap
    maxheap = heap.maxheap
    maxheap[i], maxheap[p] = maxheap[p], maxheap[i]
    if i == endof(maxheap) && isodd(length(heap))
        minheap[i] = maxheap[i]
    end
end

Base.start(heap::IntervalHeap) = 1
Base.done(heap::IntervalHeap, i) = i > length(heap)
function Base.next(heap::IntervalHeap, i)
    if i ≤ endof(heap.minheap)
        return heap.minheap[i], i + 1
    else
        return heap.maxheap[i-length(heap.minheap)], i + 1
    end
end

# accessors
function Base.minimum(heap::IntervalHeap)
    check_nonempty(heap)
    return heap.minheap[1]
end

function Base.maximum(heap::IntervalHeap)
    check_nonempty(heap)
    return heap.maxheap[1]
end

function Base.extrema(heap::IntervalHeap)
    return minimum(heap), maximum(heap)
end

function Base.show{T}(io::IO, heap::IntervalHeap{T})
    xs = Vector{T}()
    for x in heap
        push!(xs, x)
    end
    print(io, "IntervalHeap{", T, "}(", xs, ")")
end

function check_nonempty(heap)
    isempty(heap) && throw(ArgumentError("heap is empty"))
end

# implicit tree structure
isroot(i) = i == 1
parent(i) = div(i, 2)
left(i) = 2i
right(i) = 2i + 1

end # module
