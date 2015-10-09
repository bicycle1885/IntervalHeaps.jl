using IntervalHeaps

srand(12345)

function bench_construction(n, size)
    heap = IntervalHeap(randn(size))
    best = Inf
    for _ in 1:n
        xs = randn(size)
        best = min(best, @elapsed begin
            IntervalHeap(xs)
        end)
    end
    return best
end

function bench_minimum(n, size)
    heap = IntervalHeap(randn(size))
    minimum(heap)
    m = 100
    best = Inf
    for _ in 1:n
        heap = IntervalHeap(randn(size))
        best = min(best, @elapsed begin
            for _ in 1:m
                minimum(heap)
            end
        end)
    end
    return best / m
end

function bench_maximum(n, size)
    heap = IntervalHeap(randn(size))
    maximum(heap)
    m = 100
    best = Inf
    for _ in 1:n
        heap = IntervalHeap(randn(size))
        best = min(best, @elapsed begin
            for _ in 1:m
                maximum(heap)
            end
        end)
    end
    return best / m
end

function bench_push!(n, size)
    heap = IntervalHeap(randn(size))
    push!(heap, randn())
    m = 10
    best = Inf
    for _ in 1:n
        heap = IntervalHeap(randn(size))
        best = min(best, @elapsed begin
            # push 0, but variance is reduced
            for _ in 1:m
                push!(heap, randn() * 0.1)
            end
        end)
    end
    return best / m
end

function bench_pop!(n, size)
    heap = IntervalHeap(randn(size))
    pop!(heap)
    m = 10
    best = Inf
    for _ in 1:n
        heap = IntervalHeap(randn(size))
        best = min(best, @elapsed begin
            for _ in 1:m
                pop!(heap)
            end
        end)
    end
    return best / m
end

function bench_popmin!(n, size)
    heap = IntervalHeap(randn(size))
    popmin!(heap)
    m = 10
    best = Inf
    for _ in 1:n
        heap = IntervalHeap(randn(size))
        best = min(best, @elapsed begin
            for _ in 1:m
                popmin!(heap)
            end
        end)
    end
    return best / m
end

function bench_popmax!(n, size)
    heap = IntervalHeap(randn(size))
    popmax!(heap)
    m = 10
    best = Inf
    for _ in 1:n
        heap = IntervalHeap(randn(size))
        best = min(best, @elapsed begin
            for _ in 1:m
                popmax!(heap)
            end
        end)
    end
    return best / m
end

let
    println("size\tconstruction\tminimum\tmaximum\tpush!\tpop!\tpopmin!\tpopmax!")
    n = 8
    for x in logspace(2, 7, 20)
        size = floor(Int, x)
        println(
            size, "\t",
            bench_construction(n, size), "\t",
            bench_minimum(n, size), "\t",
            bench_maximum(n, size), "\t",
            bench_push!(4n, size),  "\t",
            bench_pop!(n, size),    "\t",
            bench_popmin!(n, size), "\t",
            bench_popmax!(n, size)
        )
    end
end
