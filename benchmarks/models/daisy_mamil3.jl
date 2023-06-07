import ParameterEstimation
using ModelingToolkit, DifferentialEquations#, Plots
solver = Tsit5()

@parameters a12 a13 a21 a31 a01
@variables t x1(t) x2(t) x3(t) y1(t) y2(t)
D = Differential(t)

ic = [0.25, 0.5, 0.75]
time_interval = [0.0, 1.0]
datasize = 20
sampling_times = range(time_interval[1], time_interval[2], length = datasize)
p_true = [0.167, 0.333, 0.5, 0.667, 0.833] # True Parameters

states = [x1, x2, x3]
parameters = [a12, a13, a21, a31, a01]
@named model = ODESystem([D(x1) ~ -(a21 + a31 + a01) * x1 + a12 * x2 + a13 * x3,
                             D(x2) ~ a21 * x1 - a12 * x2,
                             D(x3) ~ a31 * x1 - a13 * x3],
                         t, states, parameters)
measured_quantities = [y1 ~ x1, y2 ~ x2]
data_sample = ParameterEstimation.sample_data(model, measured_quantities, time_interval,
                                              p_true, ic, datasize; solver = solver)

res = ParameterEstimation.estimate(model, measured_quantities, data_sample;
                                   solver = solver)
all_params = vcat(ic, p_true)
for each in res
    estimates = vcat(collect(values(each.states)), collect(values(each.parameters)))
    println("Max abs rel. err: ",
            maximum(abs.((estimates .- all_params) ./ (all_params))))
end
