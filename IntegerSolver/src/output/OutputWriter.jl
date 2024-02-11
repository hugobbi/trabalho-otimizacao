function writetofile(file_name::String, termination_summary::TerminationSummary)
    open(file_name, "w") do file
        println(file, termination_summary.status)
        println(file, termination_summary.time_elapsed)
        println(file, termination_summary.optimal_value)
    end
end