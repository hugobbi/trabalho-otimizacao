function writetofile(file_name::String, seed::Int, time_elapsed::Float64, answer::Int)
    open(file_name, "w") do file
        println(file, seed)
        println(file, time_elapsed)
        println(file, answer)
    end
end