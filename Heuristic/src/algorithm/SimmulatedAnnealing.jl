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
    resDict = resToDict(R, S)

    dist = fill(INT_MAX, length(V))
    Q = copy(V)

    dist[start] = 0

    while !isempty(Q)
        pos_u = 0
        minimum_dist = INT_MAX
        for (pos, v) in enumerate(Q)
            if dist[v] < minimum_dist
                pos_u = pos
                minimum_dist = dist[v]
            end
        end

        u = Q[pos_u]
        splice!(Q, pos_u)

        for (v, time) in enumerate(g[u, :])
            if (time >= 0) && (v in Q)
                alt = dist[u] + time
                if haskey(resDict, u) && resDict[u] <= dist[u]
                    alt += delta_t
                end
                if alt < dist[v]
                    dist[v] = alt
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

function simulatedAnnealing(input_data, timeout_seconds, T, Tf, r, I)
    starting_time = time()

    S_current = randperm(length(input_data.V))[1:input_data.k]
    F_current = numReachableVertices(input_data.adjacency_matrix,
                                     input_data.V,
                                     input_data.s,
                                     input_data.T,
                                     input_data.r,
                                     S_current,
                                     input_data.delta)

    while T > Tf
        for _ in 1:I
            S_next = generateNextSolution(S_current, length(input_data.V))
            F_next = numReachableVertices(input_data.adjacency_matrix,
                                          input_data.V,
                                          input_data.s,
                                          input_data.T,
                                          input_data.r,
                                          S_next,
                                          input_data.delta)

            delta_f = F_next - F_current
            if delta_f <= 0
                S_current = S_next
                F_current = F_next
            else
                if exp(-delta_f/T) > rand()
                    S_current = S_next
                    F_current = F_next
                end 
            end

            if time() - starting_time > timeout_seconds
                return F_current
            end
        end
        T *= r
    end
    
    return F_current
end