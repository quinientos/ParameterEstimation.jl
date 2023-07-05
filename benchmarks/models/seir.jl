using ModelingToolkit, DifferentialEquations#, Plots
using ParameterEstimation
solver = Tsit5()

@parameters a b nu
@variables t S(t) E(t) In(t) N(t) y1(t) y2(t)
D = Differential(t)
states = [S, E, In, N]
parameters = [a, b, nu]

@named model = ODESystem([
                             D(S) ~ -b * S * In / N,
                             D(E) ~ b * S * In / N - nu * E,
                             D(In) ~ nu * E - a * In,
                             D(N) ~ 0
                         ], t, states, parameters)
measured_quantities = [
    y1 ~ In,
    y2 ~ N,
]

ic = [0.2, 0.4, 0.6, 0.8]
p_true = [0.25, 0.5, 0.75]
time_interval = [-0.5, 0.5]
datasize = 20
data_sample = ParameterEstimation.sample_data(model, measured_quantities, time_interval,
                                              p_true, ic,
                                              datasize; solver = solver)
res = ParameterEstimation.estimate(model, measured_quantities, data_sample; degree_range=3:(datasize-1))
all_params = vcat(ic, p_true)
for each in res
    estimates = vcat(collect(values(each.states)), collect(values(each.parameters)))
    println("Max abs rel. err: ",
            maximum(abs.((estimates .- all_params) ./ (all_params))))
end
