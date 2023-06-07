using ParameterEstimation
using ModelingToolkit, DifferentialEquations
solver = Tsit5()

@parameters mu_N mu_EE mu_LE mu_LL mu_M mu_P mu_PE mu_PL delta_NE delta_EL delta_LM rho_E rho_P
@variables t N(t) E(t) S(t) M(t) P(t) y1(t) y2(t) y3(t) y4(t)
D = Differential(t)
states = [N, E, S, M, P]
parameters = [
    mu_N,
    mu_EE,
    mu_LE,
    mu_LL,
    mu_M,
    mu_P,
    mu_PE,
    mu_PL,
    delta_NE,
    delta_EL,
    delta_LM,
    rho_E,
    rho_P,
]
@named model = ODESystem([
                             D(N) ~ -N * mu_N - N * P * delta_NE,
                             D(E) ~ N * P * delta_NE - E^2 * mu_EE -
                                    E * delta_EL + E * P * rho_E,
                             D(S) ~ S * delta_EL - S * delta_LM - S^2 * mu_LL -
                                    E * S * mu_LE,
                             D(M) ~ S * delta_LM - mu_M * M,
                             D(P) ~ P^2 * rho_P - P * mu_P - E * P * mu_PE -
                                    S * P * mu_PL,
                         ], t, states, parameters)
measured_quantities = [y1 ~ N, y2 ~ E, y3 ~ S + M, y4 ~ P]

ic = [0.167, 0.333, 0.5, 0.667, 0.833]
time_interval = [0.0, 1.0]
datasize = 20
p_true = [0.071, 0.143, 0.214, 0.286, 0.357, 0.429, 0.5, 0.571, 0.643, 0.714, 0.786, 0.857, 0.929] # True Parameters
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
