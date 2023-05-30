using ModelingToolkit, DifferentialEquations, Optimization, OptimizationPolyalgorithms,
      OptimizationOptimJL, SciMLSensitivity, ForwardDiff, Plots
using Distributions, Random
solver = Tsit5()

@parameters p1 p2 p3 p4 p6 p7
@variables t x1(t) x2(t) x3(t) u0(t) y1(t) y2(t)
D = Differential(t)
states = [x1, x2, x3, u0]
parameters = [p1, p3, p4, p6, p7]
@named model = ODESystem([
                             D(x1) ~ -1 * p1 * x1 + x2 + u0,
                             D(x2) ~ p3 * x1 - p4 * x2 + x3,
                             D(x3) ~ p6 * x1 - p7 * x3,
                             D(u0) ~ 1,
                         ], t, states, parameters)
measured_quantities = [
    y1 ~ x1,
    y2 ~ u0,
]

ic = [0.2, 0.4, 0.6, 0.8]
time_interval = [0.0, 1.0]
datasize = 20
sampling_times = range(time_interval[1], time_interval[2], length = datasize)
p_true = [0.167, 0.333, 0.5, 0.667, 0.833] # True Parameters
prob_true = ODEProblem(model, ic, time_interval, p_true)
solution_true = solve(prob_true, solver, p = p_true, saveat = sampling_times;
                      abstol = 1e-12, reltol = 1e-12)

data_sample = Dict(v.rhs => solution_true[v.rhs] for v in measured_quantities)

p_rand = rand(Uniform(0.0, 1.0), length(ic) + length(p_true)) # Random Parameters
prob = ODEProblem(model, ic, time_interval,
                  p_rand)

function loss(p)
    sol = solve(remake(prob; u0 = p[1:length(ic)]), Tsit5(), p = p[(length(ic) + 1):end],
                saveat = sampling_times;
		abstol = 1e-12, reltol = 1e-12)
    data_true = [data_sample[v.rhs] for v in measured_quantities]
    data = [(sol[1, :]), (sol[4, :])]

    if sol.retcode == ReturnCode.Success
        loss = sum(sum((data[i] .- data_true[i]) .^ 2) for i in eachindex(data))
        return loss, sol
    else
        return Inf, sol
    end
end

callback = function (p, l, pred)
    display(l)
    #     plt = plot(pred, ylim = (0, 6))
    #     display(plt)
    # Tell Optimization.solve to not halt the optimization. If return true, then
    # optimization stops.
    return false
end

adtype = Optimization.AutoForwardDiff()
optf = Optimization.OptimizationFunction((x, p) -> loss(x), adtype)
optprob = Optimization.OptimizationProblem(optf, p_rand)

@time result_ode = Optimization.solve(optprob, PolyOpt(), callback = callback, maxiters = 1000)

println(result_ode.u)

all_params = vcat(ic, p_true)
println("Max. relative abs. error between true and estimated parameters:",
        maximum(abs.((result_ode.u .- all_params) ./ (all_params))))
