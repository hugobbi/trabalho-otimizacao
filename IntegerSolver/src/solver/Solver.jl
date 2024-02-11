using JuMP
using GLPK

struct TerminationSummary
    status::MOI.TerminationStatusCode
    time_elapsed::Float64
    optimal_value::Float64
end

function listneighbors(adjacency_matrix::Array{Int, 2}, vertex_index::Int)
    column = adjacency_matrix[:, vertex_index]
    return [vl for vl in 1:length(column) if column[vl] >= 0]
end

function isavailable(r::Array{Int}, k::Int, t::Int)
    checkavailability(i) = r[i] > t ? 0 : 1
    return [checkavailability(index) for index in 1:k]
end

function N(input_data::InputData, v::Int)
    return listneighbors(input_data.adjacency_matrix, v)
end

function b(input_data::InputData, vl::Int, v::Int)
    return input_data.adjacency_matrix[vl, v]
end

function B(input_data::InputData, vl::Int, v::Int)
    return input_data.adjacency_matrix[vl, v] + input_data.delta
end

function R(input_data::InputData, t::Int, vl::Int, v::Int)
    return isavailable(input_data.r, input_data.k, t - b(input_data, vl, v))
end

function createmodel(input_data::InputData, timeout_seconds::Float64)
    model = JuMP.Model(GLPK.Optimizer)
    set_time_limit_sec(model, timeout_seconds)

    @variable(model, x[v in input_data.V, t in 1:input_data.T], Bin)
    @variable(model, y[v in input_data.V, i in 1:input_data.k], Bin)
    @objective(model, Min, sum(x[:, input_data.T]))
    @constraint(model, x[input_data.s, 1] == 1)
    @constraint(model, [v in input_data.V, t in 1:(input_data.T - 1)], x[v, t + 1] >= x[v, t])
    @constraint(model, [v in input_data.V], sum(y[v, :]) <= 1)
    @constraint(model, [i in 1:input_data.k], sum(y[:, i]) <= 1)
    @constraint(model, sum(y) == input_data.k)
    @constraint(model, [v in input_data.V, vl in N(input_data, v), t in (b(input_data, vl, v) + 1):input_data.T],
                x[v, t] >= x[vl, t - b(input_data, vl, v)] - sum(R(input_data, t, vl, v) .* y[vl, :]))
    @constraint(model, [v in input_data.V, vl in N(input_data, v), t in (B(input_data, vl, v) + 1):input_data.T],
                x[v, t] >= x[vl, t - B(input_data, vl, v)])

    return model
end

function solveinstance(input_data::InputData, timeout_seconds::Float64)
    model = createmodel(input_data, timeout_seconds)
    optimize!(model)
    
    if termination_status(model) == MOI.TIME_LIMIT
        return TerminationSummary(termination_status(model), solve_time(model), NaN64)
    end
        
    return TerminationSummary(termination_status(model), solve_time(model), objective_value(model))
end