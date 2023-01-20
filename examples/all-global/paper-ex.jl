using ParameterEstimation
using ModelingToolkit # ODE definitions

# define toy model
@parameters mu
@variables t x1(t) y1(t)
D = Differential(t)
@named model = ODESystem([D(x1) ~ -mu * x1],
                         t, [x1], [mu])
# data sampling
outs = [y1 ~ x1 + x1^2]
time = [0.0, 1.0] # sampling interval
data = Dict{Any, Vector{Float64}}("t" => [0.0, 1 / 3, 2 / 3, 1.0],
                                  x1 + x1^2 => [2.0, 1.56301,
                                      1.22995, 0.97441])
# identifiabliity,
# interpolation and estimation (steps 1-5)
res = estimate(model, outs, data, time)
identifiability_result = ParameterEstimation.check_identifiability(model;
                                                                   measured_quantities = outs)
res = ParameterEstimation.estimate_fixed_degree(model, outs, data, time,
                                                identifiability_result, 1)