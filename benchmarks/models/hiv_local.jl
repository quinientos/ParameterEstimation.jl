using ModelingToolkit, DifferentialEquations#, Plots
using ParameterEstimation
solver = Tsit5()

@parameters b c d k1 k2 mu1 mu2 q1 q2 s 
@variables t x1(t) x2(t) x3(t) x4(t) y1(t) y2(t)
D = Differential(t)
states = [x1, x2, x3, x4]
parameters = [b, c, d, k1, k2, mu1, mu2, q1, q2, s]

@named model = ODESystem([
                             D(x1) ~ -b * x1 * x4 - d * x1 + s,
                             D(x2) ~ b * q1 * x1 * x4 - k1 * x2 - mu1 * x2,
                             D(x3) ~ b * q2 * x1 * x4 + k1 * x2 - mu2 * x3,
                             D(x4) ~ -c * x4 + k2 * x3,
                         ], t, states, parameters)
measured_quantities = [
    y1 ~ x1,
    y2 ~ x4,
]

ic = [0.2, 0.4, 0.6, 0.8]
p_true = [0.091, 0.182, 0.273, 0.364, 0.455, 0.545, 0.636, 0.727, 0.818, 0.909]
time_interval = [-0.5, 0.5]
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
