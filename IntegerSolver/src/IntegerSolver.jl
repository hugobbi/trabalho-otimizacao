module IntegerSolver

include("input/InputReader.jl")

function main(output_file::String, n::Int)
    data = InputReader.readfromstdin(n)

    open(output_file, "w") do file
        println(file, data.delta)
        println(file, data.T)
        println(file, data.r)
        println(file, data.k)
        println(file, length(data.V))
    end
end

end
