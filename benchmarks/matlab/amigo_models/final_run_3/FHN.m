addpath(genpath('../../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='FHNModel'; % Folder to keep results
inputs.pathd.short_name='FHN';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=2;                                  % Number of states
inputs.model.n_par=3;                                 % Number of model parameters
%inputs.model.n_stimulus=0;                            % Number of inputs, stimuli or control variables
inputs.model.st_names=char('x1','x2');    %x1=V, x2=R        % Names of the states
inputs.model.par_names=char('g','a','b');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char('dx1 = g * (x1 - x1^3/3 + x2);', 'dx2 = 1/g * (x1 - a + b * x2);');                                 % Equations describing system dynamics.
inputs.model.par = [0.25, 0.5, 0.75];         % Nominal value for the parameters
% inputs.model.AMIGOsensrhs = 1;                       % Generate the sensitivity equations for exact
%                                                      % Jacobian computation
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.333 0.67];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=1;                       % Number of observables
inputs.exps.obs_names{1}=char('Y'); % Names of the observables
inputs.exps.obs{1}=char('Y=x1');
inputs.exps.t_con{1}=[0 1];                 % Input swithching times including:
inputs.exps.n_s{1}=20;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.333
0.3466101338418157
0.36151735431523135
0.37797431460474024
0.39628144419271977
0.4167958554234532
0.43994184869308234
0.4662232703905155
0.49623799915450345
0.5306948466034608
0.5704331478200156
0.6164452669490624
0.6699021263015821
0.7321816376840742
0.8048995024558003
0.8899411438356175
0.9894923837811481
1.1060646558841645
1.242507775568018
1.4019992760045652
];

inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=3.0*ones(1,3);
inputs.PEsol.global_theta_min=0.0001*ones(1,3);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=3.0*ones(1,2);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0001*ones(1,2);
%=============================================================
% COST FUNCTION RELATED DATA
% SOLVING THE PROBLEM WITH WEIGHTED LEAST SQUARES FUNCTION
%=============================================================
inputs.PEsol.PEcost_type='lsq';          % 'lsq' (weighted least squares default)
inputs.PEsol.lsq_type='Q_I';             % Weights:
                                         % Q_I: identity matrix; Q_expmax: maximum experimental data
                                         % Q_expmean: mean experimental data;
                                         % Q_mat: user selected weighting matrix
% OPTIMIZATION
%inputs.nlpsol.nlpsolver='local_lsqnonlin';  % In this case the problem will be solved with
                                         % a local non linear least squares
                                         % method.AMIGO_Prep(inputs);
% %
 inputs.nlpsol.nlpsolver='eSS';                      % Solver used for optimization
inputs.nlpsol.eSS.log_var = 1:5;                    % Index of parameters to be considered in log scale
inputs.nlpsol.eSS.maxeval = 100000;                  % Maximum number of cost function evaluations                       
inputs.nlpsol.eSS.maxtime = 600;                    % Maximum time spent for optimization                                
inputs.nlpsol.eSS.local.solver = 'nl2sol';                                                                             inputs.nlpsol.eSS.local.finish = 'nl2sol';         
inputs.nlpsol.eSS.local.nl2sol.maxiter             =      1000;                                                          
inputs.nlpsol.eSS.local.nl2sol.maxfeval            =      2000;                                                          
inputs.nlpsol.eSS.local.nl2sol.tolrfun             =     1e-10;                                                          
inputs.nlpsol.eSS.local.nl2sol.tolafun             =     1e-10;
inputs.nlpsol.eSS.local.nl2sol.objrtol                   =     1e-10;
% inputs.exps.u_interp{1}='sustained';          % Stimuli definition for experiment 1
                                              % Initial and final time
%inputs.exps.u{1}=1;                           % Values of the inputs for exp 1
AMIGO_Prep(inputs);
AMIGO_PE(inputs);
