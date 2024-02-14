# Solving Atrapalhando Fugitivos using Simulated Annealing

using DataStructures
using Random
using Printf

include("input/InputReader.jl")
include("algorithm/SimmulatedAnnealing.jl")
include("output/OutputFormatter.jl")

# Simulated Annealing parameters
const random_seed = 11235813
const T = 10000
const Tf = 0.001
const r = 0.99
const I = 1000

function main(output_file::String, n::Int)
    data = readfromstdin(n)

    Random.seed!(random_seed)
    time_elapsed = @elapsed begin
        best_solution = simulatedAnnealing(data, T, Tf, r, I)
    end

    writetofile(output_file, random_seed, time_elapsed, best_solution)
end

main(ARGS[1], parse(Int, ARGS[2]))