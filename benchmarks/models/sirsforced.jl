using ModelingToolkit, DifferentialEquations#, Plots
using ParameterEstimation
solver = Tsit5()

@parameters b0 b1 g M mu nu
@variables t i(t) r(t) s(t) x1(t) x2(t) y1(t) y2(t)
D = Differential(t)
states = [i, r, s, x1, x2]
parameters = [b0, b1, g, M, mu, nu]

@named model = ODESystem([
                             D(s) ~ mu - mu * s - b0 * (1 + b1 * x1) * i * s + g * r,
                             D(i) ~ b0 * (1 + b1 * x1) * i * s - (nu + mu) * i,
                             D(r) ~ nu * i - (mu + g) * r,
                             D(x1) ~ -M * x2,
                             D(x2) ~ M * x1,
                         ], t, states, parameters)
measured_quantities = [
    y1 ~ i,
    y2 ~ r,
]

ic = [0.167, 0.333, 0.5, 0.667, 0.833]
p_true = [0.143, 0.286, 0.429, 0.571, 0.714, 0.857]
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
