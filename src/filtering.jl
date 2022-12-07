"""
    solve_ode(model, estimate::EstimationResult, tsteps, data_sample; solver = Tsit5(),
              return_ode = false)

Solves the ODE system `model` with the parameters and initial conditions given by `estimate`.
Compute the error between the solution and the data sample. The error is recorded in the `EstimationResult`.

# Arguments
- `model`: the ODE system to be solved.
- `estimate::EstimationResult`: the parameters and initial conditions of the ODE system.
- `tsteps`: the time steps of the ODE system. See `ModelingToolkit.solve`.
- `data_sample`: the data sample used for estimation (same functions as `measured_quantities`).
                 The keys of the dictionary are the measured quantities
                 and the values are the corresponding data samples.
- `solver = Tsit5()`: (optional) the solver used to solve the ODE system, see `DifferentialEquations` for available solvers.
- `return_ode = false`: (optional) whether to return the ODE solution.

# Returns
- ode_solution: the solution of the ODE system (if `return_ode` is set to `true`).
- `EstimationResult`: the estimated parameters and initial conditions of the model.
"""
function solve_ode(model, estimate::EstimationResult, tsteps, data_sample; solver = Tsit5(),
                   return_ode = false)
    initial_conditions = [estimate[s] for s in ModelingToolkit.states(model)]
    parameter_values = [estimate[p] for p in ModelingToolkit.parameters(model)]
    prob = ModelingToolkit.ODEProblem(model, initial_conditions,
                                      (tsteps[1], tsteps[end]),
                                      parameter_values)
    ode_solution = ModelingToolkit.solve(prob, solver, saveat = tsteps)
    if ode_solution.retcode == ReturnCode.Success
        err = 0
        for (key, sample) in data_sample
            err += ParameterEstimation.mean_abs_err(ode_solution[key], sample)
        end
        err /= length(data_sample)
    else
        err = 1e+10
    end
    if return_ode
        return ode_solution,
               EstimationResult(estimate.parameters, estimate.states,
                                estimate.degree, err,
                                estimate.return_code)
    else
        return EstimationResult(estimate.parameters, estimate.states,
                                estimate.degree, err,
                                estimate.return_code)
    end
end

"""
    solve_ode!(model, estimates::Vector{EstimationResult}, tsteps, data_sample; solver = Tsit5())

Run solve_ode for multiple estimates and store the results (error between solution and sample) in each estimate.
This is done in-place.
"""
function solve_ode!(model, estimates::Vector{EstimationResult},
                    tsteps, data_sample; solver = Tsit5())
    estimates[:] = map(each -> solve_ode(model, each, tsteps, data_sample, solver = solver),
                       estimates)
end

"""
    filter_solutions(results::Vector{EstimationResult},
                     identifiability_result::IdentifiabilityData,
                     model::ModelingToolkit.ODESystem,
                     data_sample::Dict{Num, Vector{T}} = Dict{Num, Vector{T}}(),
                     time_interval = Vector{T}(); topk = 1) where {T <: Float}

Filter estimation results stored in `results` vector based on ODE solving and checking against the sample.
In addition, takes into account global and local identifiability of parameters when filtering.

# Arguments
- `results::Vector{EstimationResult}`: the vector of estimation results.
- `identifiability_result::IdentifiabilityData`: the result of identifiability analysis.
- `model::ModelingToolkit.ODESystem`: the ODE system.
- `data_sample::Dict{Num, Vector{T}} = Dict{Num, Vector{T}}()`: the data sample used for estimation (same functions as `measured_quantities`).
                                                                The keys of the dictionary are the measured quantities
                                                                and the values are the corresponding data samples.
- `time_interval = Vector{T}()`: the time interval of the ODE system.
- `topk = 1`: (optional) the number of best estimates to return.

# Returns
- `EstimationResult`: the best estimate (if `topk = 1`) or the vector of best estimates (if `topk > 1`).
"""
function filter_solutions(results::Vector{EstimationResult},
                          identifiability_result::IdentifiabilityData,
                          model::ModelingToolkit.ODESystem,
                          data_sample::Dict{Num, Vector{T}} = Dict{Num, Vector{T}}(),
                          time_interval = Vector{T}(), id_combs = [];
                          topk = 1) where {T <: Float}
    @info "Filtering"
    if all(each -> each.return_code == ReturnCode.Failure, results)
        return results
    end
    min_error = 1e+10
    best_estimate = nothing
    tsteps = range(time_interval[1], time_interval[2],
                   length = length(first(values(data_sample))))
    if length(identifiability_result["identifiability"]["nonidentifiable"]) > 0
        @warn "The model contains non-identifiable parameters, no filtering was done."
        return results
    end
    filtered_results = []
    if length(identifiability_result["identifiability"]["locally_not_globally"]) > 0
        if length(id_combs) == 0
            clustered = ParameterEstimation.cluster_estimates(model, results, tsteps,
                                                              data_sample)
        else
            clustered = ParameterEstimation.cluster_estimates(model, results, tsteps,
                                                              data_sample, id_combs)
        end
        for (id, group) in pairs(clustered)
            solve_ode!(model, group, tsteps, data_sample)
            sorted = sort(group, by = x -> x.err)
            if topk == 1
                @info "Group $id. Best estimate yelds ODE solution error $(sorted[1].err)"
                push!(filtered_results, sorted[1])
            else
                @info "Group $id. Best $(topk) estimates yeld ODE solution errors $([s.err for s in sorted[1:topk]])"
                push!(filtered_results, sorted[1:topk])
            end
        end
    else
        solve_ode!(model, results, tsteps, data_sample)
        sorted = sort(results, by = x -> x.err)
        if topk == 1
            @info "Best estimate yelds ODE solution error $(sorted[1].err)"
            push!(filtered_results, sorted[1])
        else
            @info "Best $(topk) estimates yeld ODE solution errors $([s.err for s in sorted[1:topk]])"
            push!(filtered_results, sorted[1:topk])
        end
    end
    return filtered_results
end

function cluster_estimates(model, res, tsteps, data_sample; ε = 1e-6)
    # clusrers the estimates by their error
    ParameterEstimation.solve_ode!(model, res, tsteps, data_sample)
    clustered = Dict()
    #nearest neighbor search by err
    for i in 1:length(res)
        for j in (i + 1):length(res)
            if abs(res[i].err - res[j].err) < ε
                if !haskey(clustered, i)
                    clustered[i] = Vector{ParameterEstimation.EstimationResult}([])
                end
                push!(clustered[i], res[j])
            end
        end
    end
    return clustered
end

function cluster_estimates(model, res, tsteps, data_sample, id_combs; ε = 1e-6)
    # clusrers the estimates by their id_combs
    ParameterEstimation.solve_ode!(model, res, tsteps, data_sample)
    clustered = Dict()
    #a la nearest neighbor search by err
    for i in 1:length(res)
        for j in (i + 1):length(res)
            if isequal(substitute(id_combs, Dict(res[i].parameters)),
                       substitute(id_combs, Dict(res[j].parameters)))
                if !haskey(clustered, i)
                    clustered[i] = []
                end
                push!(clustered[i], res[j])
            end
        end
    end
    return clustered
end