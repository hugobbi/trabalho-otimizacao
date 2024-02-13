# Solving Atrapalhando Fugitivos using Simulated Annealing

using DataStructures

const INT_MAX = typemax(Int64)

function addr(i, j, n)
    return (i-1) * n + j
end

# Dijkstra for adjecency matrix
function dijkstra(g, s)
    # Initialization
    dist = fill(INT_MAX, num_vertices)
    visited = fill(false, num_vertices)
    dist[s] = 0 

    # Generating Q arrays as min-heap
    Q = PriorityQueue{Int64, Int64}()
    Q[s] = dist[s]

    # Main loop
    while !isempty(Q)
        u, du = peek(Q)
        dequeue!(Q)
        if !visited[u]
            visited[u] = true
            adjacent_u = g[u, :]
            for v in 1:length(adjacent_u)
                if adjacent_u[v] > -1
                    if dist[v] > (du + adjacent_u[v])
                        dist[v] = du + adjacent_u[v]
                        Q[v] = dist[v]
                    end
                end
            end 
        end  
    end 

    return dist
end
