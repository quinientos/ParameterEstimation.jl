   ***********************************
   *    AMIGO2, Copyright @CSIC      *
   *    AMIGO2_R2019a [March 2019]    *
   *********************************** 

Date: 02-Jun-2023
Problem folder:	 Results/Problem
Results folder in problem folder:	 Results/Problem/PE_problem_eSS_run1 


-------------------------------
Optimisation related active settings
-------------------------------


------> Global Optimizer: Enhanced SCATTER SEARCH for parameter estimation

		>Summary of selected eSS options: 
ess_options.
	dim_refset:	'auto'
	inter_save:	0
	iterprint:	1
	local:	(1x1 struct)
	log_var:	(1x8 double)
	maxeval:	100000
	maxtime:	600
	ndiverse:	'auto'
nl2sol_settings.
	display:	2
	grad:	[]
	iterfun:	[]
	maxfeval:	2000
	maxiter:	1000
	objrtol:	1e-10
	tolafun:	1e-10
	tolrfun:	1e-10

		>Bounds on the unknowns:

		v_guess(1)=1.000000;  v_min(1)=0.000000; v_max(1)=2.000000;
		v_guess(2)=1.000000;  v_min(2)=0.000000; v_max(2)=2.000000;
		v_guess(3)=1.000000;  v_min(3)=0.000000; v_max(3)=2.000000;
		v_guess(4)=1.000000;  v_min(4)=0.000000; v_max(4)=2.000000;
		v_guess(5)=1.000000;  v_min(5)=0.000000; v_max(5)=2.000000;
		v_guess(6)=1.000000;  v_min(6)=0.000000; v_max(6)=2.000000;
		v_guess(7)=1.000000;  v_min(7)=0.000000; v_max(7)=2.000000;
		v_guess(8)=1.000000;  v_min(8)=0.000000; v_max(8)=2.000000;



-----------------------------------------------
 Initial value problem related active settings
-----------------------------------------------
ivpsolver: cvodes
RelTol: 1e-12
AbsTol: 1e-12
MaxStepSize: Inf
MaxNumberOfSteps: 1e+06


---------------------------------------------------
Local sensitivity problem related active settings
---------------------------------------------------
senssolver: cvodes
ivp_RelTol: 1e-12
ivp_AbsTol: 1e-12
sensmex: cvodesg_problem
MaxStepSize: Inf
MaxNumberOfSteps: 1e+06


-------------------------------
   Model related information
-------------------------------

--> Number of states: 3


--> Number of model parameters: 5

--> Vector of parameters (nominal values):

	par0=[   0.16700     0.33300     0.50000     0.66700     0.83300  ]


-------------------------------------------
  Experimental scheme related information
-------------------------------------------


-->Number of experiments: 1


-->Initial conditions for each experiment:
		Experiment 1: 
			exp_y0=[2.500e-01  5.000e-01  7.500e-01  ]

-->Final process time for each experiment: 
		Experiment 1: 	 1.000000


-->Sampling times for each experiment: 
		Experiment 1: 	 		Experiment 110: 	 		Experiment 95: 	 		Experiment 115: 	 		Experiment 58: 	 		Experiment 32: 	 		Experiment 37: 	 		Experiment 105: 	 		Experiment 32: 	 		Experiment 92: 	 		Experiment 116: 	 		Experiment 20: 	 0.000e+00  5.263e-02  1.053e-01  1.579e-01  2.105e-01  2.632e-01  3.158e-01  3.684e-01  4.211e-01  4.737e-01  5.263e-01  5.789e-01  6.316e-01  6.842e-01  7.368e-01  7.895e-01  8.421e-01  8.947e-01  9.474e-01  1.000e+00  

--> There is no manipulable (control, stimulus, input) variable, inputs.model.n_stimulus=0


-->Number of observables:
	Experiment 1: 2

-->Observables:
		Experiment 1:
			y1=x1
			y2=x2

-->Number of sampling times for each experiment:
		Experiment 1: 	 20

-->Sampling times for each experiment:
		Experiment 1, 
			t_s=[   0.000     0.053     0.105     0.158     0.211     0.263     0.316     0.368     0.421     0.474     0.526     0.579     0.632     0.684     0.737     0.789     0.842     0.895     0.947     1.000  ]


--------------------------------------------------------------------------

-->Experimental data for each experiment:
		
Experiment 1: 
		inputs.exp_data{1}=[
		0.25  0.5
		0.241641  0.502063
		0.234057  0.5039
		0.227167  0.505531
		0.220895  0.506975
		0.215177  0.50825
		0.209955  0.509371
		0.205176  0.51035
		0.200793  0.511202
		0.196764  0.511935
		0.193054  0.512561
		0.189628  0.513089
		0.186456  0.513525
		0.183513  0.513877
		0.180775  0.514152
		0.178221  0.514355
		0.175831  0.514492
		0.17359  0.514567
		0.171482  0.514584
		0.169493  0.514547
		];



-------------------------------------------------------------------------------------------
>>>>    Mean / Maximum value of the residuals in percentage (100*(data-model)/data):

		Experiment 1 : 
		 Observable 1 --> mean error: 0.000563 %	 max error: 0.001320 %
		 Observable 2 --> mean error: 0.000012 %	 max error: 0.000027 %

--------------------------------------------------------------------------

--------------------------------------------------------------------
>>>>  Maximum absolute value of the residuals (data-model):

		Experiment 1 : 
		 Observable 1 -->  max residual: 0.000002 max data: 0.250000
		 Observable 2 -->  max residual: 0.000000 max data: 0.514584

--------------------------------------------------------------------------	   

>>>> Best objective function: 0.000000 
	   

>>>> Computational cost: 70.100000 s
> 100.00% of successful simulationn
> 100.00% of successful sensitivity calculations


>>> Best values found and the corresponding asymptotic confidence intervals



>>> Estimated global parameters: 

	a12 : 1.6700e-01  +-  4.6575e-05 (  0.0279%); 
	a13 : 5.9704e-01  +-  8.4162e-02 (    14.1%); 
	a21 : 5.0000e-01  +-  1.2009e-04 (   0.024%); 
	a31 : 8.3780e-01  +-  7.5867e-03 (   0.906%); 
	a01 : 5.0048e-01  +-  5.9111e-02 (    11.8%); 


>>> Estimated global initial conditions: 

	x1 : 2.5000e-01  +-  1.5860e-06 (0.000634%); 
	x2 : 5.0000e-01  +-  1.1765e-06 (0.000235%); 
	x3 : 3.5048e-01  +-  7.1022e-02 (    20.3%); 


>>> Correlation matrix for the global unknowns:

	 1.000000e+00	 -8.543263e-03	 9.984375e-01	 -2.088812e-02	 9.519837e-03	 -6.169878e-03	 -7.161572e-01	 8.476471e-03
	 -8.543263e-03	 1.000000e+00	 -8.355223e-03	 9.980181e-01	 -9.999025e-01	 3.987779e-01	 1.406408e-02	 -9.999741e-01
	 9.984375e-01	 -8.355223e-03	 1.000000e+00	 -2.069835e-02	 9.311128e-03	 -6.415913e-03	 -7.477977e-01	 8.283015e-03
	 -2.088812e-02	 9.980181e-01	 -2.069835e-02	 1.000000e+00	 -9.971102e-01	 4.335829e-01	 2.388430e-02	 -9.975568e-01
	 9.519837e-03	 -9.999025e-01	 9.311128e-03	 -9.971102e-01	 1.000000e+00	 -3.924787e-01	 -1.446072e-02	 9.999764e-01
	 -6.169878e-03	 3.987779e-01	 -6.415913e-03	 4.335829e-01	 -3.924787e-01	 1.000000e+00	 -1.625654e-02	 -3.952500e-01
	 -7.161572e-01	 1.406408e-02	 -7.477977e-01	 2.388430e-02	 -1.446072e-02	 -1.625654e-02	 1.000000e+00	 -1.389343e-02
	 8.476471e-03	 -9.999741e-01	 8.283015e-03	 -9.975568e-01	 9.999764e-01	 -3.952500e-01	 -1.389343e-02	 1.000000e+00
