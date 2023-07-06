using ModelingToolkit, DifferentialEquations
using Sundials, ParameterEstimation
solver = CVODE_BDF()
@parameters k1 k2 eB
@variables t xA(t) xB(t) xC(t) eA(t) eC(t) y1(t) y2(t) y3(t) y4(t) #eA(t) eC(t)
D = Differential(t)
states = [xA, xB, xC, eA, eC]
parameters = [k1, k2, eB]
@named model = ODESystem([ 
                 			 D(xA) ~ -k1 * xA,
                  		 D(xB) ~ k1 * xA - k2 * xB,
                       D(xC) ~ k2 * xB,
                       D(eA) ~ 0,
                       D(eC) ~ 0
			], t, states, parameters)

measured_quantities = [y1 ~ xC, y2 ~ eA * xA + eB * xB + eC * xC, y3 ~ eA, y4 ~ eC] 
ic = [0.166, 0.333, 0.5, 0.666, 0.833]
time_interval = [-0.5, 0.5]
datasize = 20
p_true = [0.25, 0.5, 0.75] # True Parameters

data_sample = ParameterEstimation.sample_data(model, measured_quantities, time_interval, p_true, ic, datasize; solver = solver)

res = ParameterEstimation.estimate(model, measured_quantities, data_sample; solver = solver)
