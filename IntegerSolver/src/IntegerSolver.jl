include("input/InputReader.jl")
include("solver/Solver.jl")

const TIMEOUT_SECONDS = 1800.0

function main(output_file::String, n::Int)
    data = readfromstdin(n)
    summary = solveinstance(data, TIMEOUT_SECONDS)

    open(output_file, "w") do file
        println(file, summary.status)
        println(file, summary.time_elapsed)
        println(file, summary.optimal_value)
    end
end

main(ARGS[1], parse(Int, ARGS[2]))
