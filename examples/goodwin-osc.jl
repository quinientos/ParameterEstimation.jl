# Citation: Zamudio Lara, J.M.; Dewasme, L.; Hernández Escoto, H.; Vande Wouwer, A.
# Parameter Estimation of Dynamic Beer Fermentation Models. Foods 2022, 11, 3602.

using ModelingToolkit, DifferentialEquations, Plots
using Nemo, HomotopyContinuation

import ParameterEstimation

@parameters k1 k2 k3 k4 k5 k6 Ki
@variables t x1(t) x2(t) x3(t) y1(t) y2(t)
D = Differential(t)
@named model = ODESystem([
                             D(x1) ~ k1 * Ki^2 / (Ki^2 + x3^2) - k2 * x1,
                             D(x2) ~ k3 * x1 - k4 * x2,
                             D(x3) ~ k5 * x2 - k6 * x3,
                         ])
measured_quantities = [
    y1 ~ x1,
    y2 ~ x3,
]

u0 = [1 / 10, 2 / 10, 25 / 10]
time_interval = (-4, -2.0)
datasize = 10
tsteps = range(time_interval[1], time_interval[2], length = datasize)
p_true = [1, 1 / 10, 1, 1 / 10, 1, 1 / 10, 1] # True Parameters
states = [x1, x2, x3]
parameters = [k1, k2, k3, k4, k5, k6, Ki]

prob_true = ODEProblem(model, u0, time_interval, p_true)
solution_true = ModelingToolkit.solve(prob_true, Tsit5(), p = p_true, saveat = tsteps)

data_sample = Dict(Num(v.rhs) => solution_true[Num(v.rhs)] for v in measured_quantities)
plot(solution_true)
identifiability_result = ParameterEstimation.check_identifiability(model;
                                                                   measured_quantities = measured_quantities)
interpolation_degree = 8
results = ParameterEstimation.estimate(model, measured_quantities, data_sample,
                                       time_interval, identifiability_result,
                                       interpolation_degree)
best = ParameterEstimation.filter_solutions(results, identifiability_result, model,
                                            data_sample, time_interval)
results = ParameterEstimation.estimate_over_degrees(model, measured_quantities, data_sample,
                                                    time_interval;)