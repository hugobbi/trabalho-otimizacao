n = 10
delta = 50
T = 70

resource_groups = [(10, 3), (20, 3), (30, 3), (40, 3)]

t_min = 5
t_max = 10

open(ARGS[1], "w") do file
    println(file, "$n $delta $T")
    println(file, length(resource_groups))

    for group in resource_groups
        println(file, "$(group[1]) $(group[2])")
    end

    for x in 0:(n - 1)
        for y in 0:(n - 1)
            if checkindex(Bool, 0:(n - 1), x - 1) && checkindex(Bool, 0:(n - 1), y)
                println(file, "$x-$y $(x - 1)-$y $(rand(t_min:t_max))")
            end

            if checkindex(Bool, 0:(n - 1), x + 1) && checkindex(Bool, 0:(n - 1), y)
                println(file, "$x-$y $(x + 1)-$y $(rand(t_min:t_max))")
            end

            if checkindex(Bool, 0:(n - 1), x) && checkindex(Bool, 0:(n - 1), y + 1)
                println(file, "$x-$y $x-$(y + 1) $(rand(t_min:t_max))")
            end
             
            if checkindex(Bool, 0:(n - 1), x) && checkindex(Bool, 0:(n - 1), y - 1)
                println(file, "$x-$y $x-$(y - 1) $(rand(t_min:t_max))")
            end
        end
    end
end