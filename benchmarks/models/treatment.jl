using ModelingToolkit, DifferentialEquations#, Plots
using ParameterEstimation
solver = Tsit5()

@parameters a b d g nu
@variables t In(t) N(t) S(t) Tr(t) y1(t) y2(t)
D = Differential(t)
states = [In, N, S, Tr]
parameters = [a, b, d, g, nu]

@named model = ODESystem([
                             D(S) ~ -b * S * In / N - d * b * S * Tr / N,
                             D(In) ~ b * S * In / N + d * b * S * Tr / N - (a + g) * In,
                             D(Tr) ~ g * In - nu * Tr,
                             D(N) ~ 0,
                         ], t, states, parameters)
measured_quantities = [
    y1 ~ Tr,
    y2 ~ N,
]

ic = [0.2, 0.4, 0.6, 0.8]
p_true = [0.167, 0.333, 0.5, 0.667, 0.833]
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
