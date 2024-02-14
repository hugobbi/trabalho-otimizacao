# Solving Atrapalhando Fugitivos using Simulated Annealing

using DataStructures
using Random
using Printf

include("input/InputReader.jl")
include("algorithm/SimmulatedAnnealing.jl")
include("output/OutputFormatter.jl")

const Tf = 0.001
const TIMEOUT_SECONDS = 1800.0

function main(output_file::String, n::Int, random_seed::Int, T::Int, r::Float64, I::Int)
    data = readfromstdin(n)

    Random.seed!(random_seed)
    time_elapsed = @elapsed begin
        best_solution = simulatedAnnealing(data, TIMEOUT_SECONDS, T, Tf, r, I)
    end

    writetofile(output_file, random_seed, time_elapsed, best_solution)
end

main(ARGS[1], parse(Int, ARGS[2]), parse(Int, ARGS[3]), parse(Int, ARGS[4]),
     parse(Float64, ARGS[5]), parse(Int, ARGS[6]))