const INT_MAX = typemax(Int64)

function addr(i, j, n)
    return (i-1) * n + j
end

function resToDict(R, S)
    resDict = Dict{Int64, Int64}()
    for i in 1:length(S)
        resDict[S[i]] = R[i]
    end

    return resDict
end

function dijkstraWithResources(g, V, start, R, S, delta_t)
    # Initialization
    dist = fill(INT_MAX, length(V))
    visited = fill(false, length(V))
    dist[start] = 0 

    # Generating Q array as min-heap
    Q = PriorityQueue{Int64, Int64}()
    Q[start] = dist[start]

    # Generate resource dictionary
    resDict = resToDict(R, S)

    # Main loop
    while !isempty(Q)
        u, du = peek(Q)
        dequeue!(Q)
        if !visited[u]
            visited[u] = true
            adjacent_u = g[u, :]
            for v in 1:length(adjacent_u)
                if adjacent_u[v] > -1
                    cost_to_v = du + adjacent_u[v]
                    if dist[v] > cost_to_v
                        dist[v] = cost_to_v
                        # Apply resource
                        if haskey(resDict, u)
                            if du >= resDict[u]
                                dist[v] += delta_t
                            end
                        end
                        Q[v] = dist[v]
                    end
                end
            end 
        end  
    end 

    return dist
end 

function numReachableVertices(g, V, start, t_max, R, S, delta_t)
    distances = dijkstraWithResources(g, V, start, R, S, delta_t)
    numVertices = 0
    for d in distances
        if d <= t_max
            numVertices += 1
        end
    end
    
    return numVertices
end

function generateNextSolution(S, num_vertices)
    n = length(S)
    index = rand(1:n)
    S_next = copy(S)

    random_vertex = rand(1:num_vertices)
    while random_vertex in S
        random_vertex = rand(1:num_vertices)
    end

    S_next[index] = random_vertex

    return S_next
end

function simulatedAnnealing(input_data, T, Tf, r, I)
    S_current = randperm(length(input_data.V))[1:input_data.k]
    F_current = numReachableVertices(input_data.adjacency_matrix,
                                     input_data.V,
                                     1,
                                     input_data.T,
                                     input_data.r,
                                     S_current,
                                     input_data.delta)
    while T > Tf
        for _ in 1:I
            S_next = generateNextSolution(S_current, length(input_data.V))
            F_next = numReachableVertices(input_data.adjacency_matrix,
                                          input_data.V,
                                          1,
                                          input_data.T,
                                          input_data.r,
                                          S_next,
                                          input_data.delta)
            F_current = numReachableVertices(input_data.adjacency_matrix,
                                             input_data.V,
                                             1,
                                             input_data.T,
                                             input_data.r,
                                             S_current,
                                             input_data.delta)
            delta_f = F_next - F_current
            if delta_f <= 0
                S_current = S_next
            else
                if exp(-delta_f/T) > rand()
                    S_current = S_next
                end 
            end 
            
        end
        T *= r
    end
    
    return F_current
end