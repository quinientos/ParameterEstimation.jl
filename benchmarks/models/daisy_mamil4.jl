import ParameterEstimation
using ModelingToolkit, DifferentialEquations#, Plots
solver = Tsit5()

@parameters k01, k12, k13, k14, k21, k31, k41
@variables t x1(t) x2(t) x3(t) x4(t) y1(t) y2(t) y3(t)
D = Differential(t)

ic = [0.2, 0.4, 0.6, 0.8]
time_interval = [0.0, 1.0]
datasize = 20
sampling_times = range(time_interval[1], time_interval[2], length = datasize)
p_true = [0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875] # True Parameters

states = [x1, x2, x3, x4]
parameters = [k01, k12, k13, k14, k21, k31, k41]
@named model = ODESystem([D(x1) ~ -k01 * x1 + k12 * x2 + k13 * x3 + k14 * x4 - k21 * x1 - k31 * x1 - k41 * x1,
                             D(x2) ~ -k12 * x2 + k21 * x1,
                             D(x3) ~ -k13 * x3 + k31 * x1,
                             D(x4) ~ -k14 * x4 + k41 * x1],
                         t, states, parameters)
measured_quantities = [y1 ~ x1, y2 ~ x2, y3 ~ x3+x4]
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
