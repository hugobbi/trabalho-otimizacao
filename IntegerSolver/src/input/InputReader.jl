module InputReader

struct InputData
    delta::Int
    T::Int
    r::Array{Int}
    k::Int
    adjacency_matrix::Array{Float64, 2}
    V::Set{Int}
end

function readheader()
    input_line = readline()
    line_tokens = split(input_line)
    line_numbers = parse.(Int, line_tokens)
    delta = line_numbers[2]
    max_time = line_numbers[3]
    return delta, max_time
end

function readresources()
    input_line = readline()
    resource_groups_number = parse(Int, input_line)

    resource_list = []

    for _ in 1:resource_groups_number
        input_line = readline()
        line_tokens = split(input_line)
        line_numbers = parse.(Int, line_tokens)
        
        for _ in 1:line_numbers[2]
            push!(resource_list, line_numbers[1])
        end
    end

    return resource_list
end

function creatematrix(vertex_number::Int)
    return fill(Inf, vertex_number, vertex_number)
end

function getvertexindexonlist(x::Int, y::Int, n::Int)
    return n * (x - 1) + y
end

function converttojuliaindex(index::Int)
    return index + 1
end

function readedges(adjacency_matrix::Array{Float64, 2}, n::Int)
    input_line = readline()

    while !isempty(input_line)
        line_tokens = split(input_line, r"[ -]")
        line_numbers = parse.(Int, line_tokens)

        starting_vertex_index = getvertexindexonlist(
                converttojuliaindex(line_numbers[1]),
                converttojuliaindex(line_numbers[2]),
                n
        )

        ending_vertex_index = getvertexindexonlist(
                converttojuliaindex(line_numbers[3]),
                converttojuliaindex(line_numbers[4]),
                n
        )

        adjacency_matrix[starting_vertex_index, ending_vertex_index] = convert(Float64, line_numbers[5])

        input_line = readline()
    end
end

function listvertices(adjacency_matrix::Array{Float64, 2})
    vertices_set = Set()

    line_count, column_count = size(adjacency_matrix)

    for x in 1:line_count
        for y in 1:column_count
            if !isinf(adjacency_matrix[x, y])
                push!(vertices_set, x)
                push!(vertices_set, y)
            end
        end
    end

    return vertices_set
end

function readfromstdin(n::Int)
    delta, max_time = readheader()

    resource_list = readresources()

    adjacency_matrix = creatematrix(n^2)
    readedges(adjacency_matrix, n)

    vertices_set = listvertices(adjacency_matrix)

    return InputData(delta, max_time, resource_list, length(resource_list), adjacency_matrix, vertices_set)
end
end