include("input/InputReader.jl")
include("solver/Solver.jl")
include("output/OutputWriter.jl")

const TIMEOUT_SECONDS = 1800.0

function main(output_file::String, n::Int)
    data = readfromstdin(n)
    summary = solveinstance(data, TIMEOUT_SECONDS)
    writetofile(output_file, summary)
end

main(ARGS[1], parse(Int, ARGS[2]))
