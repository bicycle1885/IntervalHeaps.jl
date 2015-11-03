using IntervalHeaps
using Iterators

if VERSION >= v"0.5-"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end

srand(12345)

@testset begin
    @testset "examples" begin
        heap = IntervalHeap{Int}()
        # heap: []
        @test isempty(heap)
        @test length(heap) == 0
        push!(heap, 1)
        # heap: [1]
        @test !isempty(heap)
        @test length(heap) == 1
        @test extrema(heap) == (1, 1)
        push!(heap, 2)
        # heap: [1, 2]
        @test !isempty(heap)
        @test length(heap) == 2
        @test extrema(heap) == (1, 2)
        push!(heap, 3)
        @test extrema(heap) == (1, 3)
        push!(heap, 4)
        @test extrema(heap) == (1, 4)
        push!(heap, -1)
        @test extrema(heap) == (-1, 4)
        push!(heap, -2)
        @test extrema(heap) == (-2, 4)
        push!(heap, 5)
        # heap: [-2, -1, 1, 2, 3, 4, 5]
        n = 0
        for x in heap
            @test x ∈ [-2, -1, 1, 2, 3, 4, 5]
            n += 1
        end
        @test n == 7
        @test extrema(heap) == (-2, 5)
        @test length(heap) == 7
        min = popmin!(heap)
        # heap: [-1, 1, 2, 3, 4, 5]
        @test min == -2
        @test extrema(heap) == (-1, 5)
        @test length(heap) == 6
        max = popmax!(heap)
        # heap: [-1, 1, 2, 3, 4]
        @test max == 5
        @test extrema(heap) == (-1, 4)
        @test length(heap) == 5
        push!(heap, 1)
        # heap: [-1, 1, 1, 2, 3, 4]
        n = 0
        for x in heap
            @test x ∈ [-1, 1, 2, 3, 4]
            n += 1
        end
        @test n == 6
        @test extrema(heap) == (-1, 4)
        @test length(heap) == 6
        push!(heap, -10)
        # heap: [-10, -1, 1, 1, 2, 3, 4]
        @test extrema(heap) == (-10, 4)
        @test popmax!(heap) == 4
        @test popmax!(heap) == 3
        @test popmin!(heap) == -10
        @test popmin!(heap) == -1
        @test popmin!(heap) == 1
        @test popmax!(heap) == 2
        @test popmin!(heap) == 1
        @test isempty(heap)
    end

    @testset "IntervalHeap{Any}" begin
        # heap of any element
        heap = IntervalHeap()
        @test typeof(heap) === IntervalHeap{Any}
        push!(heap, 1)
        push!(heap, -1.2)
        push!(heap, 0x03)
        @test minimum(heap) === -1.2
        @test maximum(heap) === 0x03

        heap = IntervalHeap(Any[-5, -2.0, 8, 0x05])
        @test typeof(heap) === IntervalHeap{Any}
        @test minimum(heap) === -5
        @test maximum(heap) === 8
    end

    @testset "pop!" begin
        # pop! an element
        for xs in ([1,2], [1,2,3], [1,2,3,4])
            heap = IntervalHeap(xs)
            ys = Int[]
            while !isempty(heap)
                elm = pop!(heap)
                push!(ys, elm)
            end
            @test xs == sort(ys)
        end
    end

    @testset "Float64 and Int" begin
        # Float64
        xs = randn(10)
        heap = IntervalHeap(xs)
        @test isa(heap, IntervalHeap{Float64})
        @test length(heap) == length(xs)
        @test extrema(heap) == extrema(xs)
        # Int
        xs = rand(Int, 10)
        heap = IntervalHeap(xs)
        @test isa(heap, IntervalHeap{Int})
        @test length(heap) == length(xs)
        @test extrema(heap) == extrema(xs)
    end

    @testset "type conversion" begin
        # push values of a convertible type
        heap = IntervalHeap([1,2,3])
        @test length(heap) == 3
        push!(heap, 1.0)
        @test length(heap) == 4
        @test sort(collect(heap)) == [1, 1, 2, 3]

        heap = IntervalHeap([1.0, 2.0, 3.0])
        @test length(heap) == 3
        push!(heap, 1)
        @test length(heap) == 4
        @test sort(collect(heap)) == [1.0, 1.0, 2.0, 3.0]
    end

    @testset "empty!" begin
        heap = IntervalHeap([1,2,3])
        @test !isempty(heap)
        @test empty!(heap) === heap
        @test isempty(heap)
        @test sizehint!(heap, 10) === heap
    end

    @testset "empty heap" begin
        heap = IntervalHeap(Int[])
        @test isempty(heap)
        @test_throws ArgumentError minimum(heap)
        @test_throws ArgumentError maximum(heap)
        @test_throws ArgumentError extrema(heap)
        @test_throws ArgumentError pop!(heap)
        @test_throws ArgumentError popmin!(heap)
        @test_throws ArgumentError popmax!(heap)
    end

    @testset "iterator" begin
        heap = IntervalHeap()
        n = 0
        for x in heap
            n += 1
        end
        @test n == 0

        heap = IntervalHeap([1])
        n = 0
        for x in heap
            @test x == 1
            n += 1
        end
        @test n == 1

        heap = IntervalHeap([2,1])
        n = 0
        for x in heap
            @test x == 1 || x == 2
            n += 1
        end
        @test n == 2
    end

    @testloop "property-based test" for n in 1:8
        for _ in 1:5, xs in chain(permutations(randn(n)), permutations(rand(0:1, n)))
            @testset "constructor" begin
                # Prop: the heap constructor creates a valid double-ended heap
                heap = IntervalHeap(xs)
                @test extrema(heap) == extrema(xs)
                @test length(heap) == length(xs)
            end

            @testset "pop!" begin
                # Prop: iterative pop! generates an arbitrarily-ordered vector of the original vector
                heap = IntervalHeap(xs)
                ys = []
                while !isempty(heap)
                    push!(ys, pop!(heap))
                end
                @test sort(ys) == sort(xs)
            end

            @testset "popmin!" begin
                # Prop: iterative popmin! generates an increasingly-sorted vector of the original vector
                heap = IntervalHeap(xs)
                ys = []
                while !isempty(heap)
                    push!(ys, popmin!(heap))
                end
                @test ys == sort(xs)
            end

            @testset "popmax!" begin
                # Prop: iterative popmax! generates an decreasingly-sorted vector of the original vector
                heap = IntervalHeap(xs)
                ys = []
                while !isempty(heap)
                    push!(ys, popmax!(heap))
                end
                @test ys == sort(xs, rev=true)
            end
        end
    end
end
