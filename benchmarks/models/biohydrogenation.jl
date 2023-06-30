using ModelingToolkit, DifferentialEquations#, Plots
using ParameterEstimation
solver = Tsit5()

@parameters k5 k6 k7 k8 k9 k10
@variables t x4(t) x5(t) x6(t) x7(t) y1(t) y2(t)
D = Differential(t)
states = [x4, x5, x6, x7]
parameters = [k5, k6, k7, k8, k9, k10]

@named model = ODESystem([
                             D(x4) ~ - k5 * x4 / (k6 + x4),
                             D(x5) ~ k5 * x4 / (k6 + x4) - k7 * x5/(k8 + x5 + x6),
                             D(x6) ~ k7 * x5 / (k8 + x5 + x6) - k9 * x6 * (k10 - x6) / k10,
                             D(x7) ~ k9 * x6 * (k10 - x6) / k10,
                         ], t, states, parameters)
measured_quantities = [
    y1 ~ x4,
    y2 ~ x5,
]

ic = [0.2, 0.4, 0.6, 0.8]
p_true = [0.143, 0.286, 0.429, 0.571, 0.714, 0.857]
time_interval = [-0.5, 0.5] #[-1.0, 1.0] #[-0.5, 0.5]
datasize = 20
data_sample = ParameterEstimation.sample_data(model, measured_quantities, time_interval,
                                              p_true, ic,
                                              datasize; solver = solver)
res = ParameterEstimation.estimate(model, measured_quantities, data_sample)
all_params = vcat(ic, p_true)
for each in res
    estimates = vcat(collect(values(each.states)), collect(values(each.parameters)))
    println("Max abs rel. err: ",
            maximum(abs.((estimates .- all_params) ./ (all_params))))
end
