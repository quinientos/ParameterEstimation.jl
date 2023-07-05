addpath(genpath('../src'))
 addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='SlowFastModel'; % Folder to keep results
inputs.pathd.short_name='SlowFast';                 % To identify figures and reports
             

inputs.pathd.runident='r8';                           % [] Identifier required in order not to overwrite previous results
                                                       %    This may be modified from command line. 'run1'(default)
                                                     
%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=5;                                  % Number of states
inputs.model.n_par=3;                                 % Number of model parameters
%inputs.model.n_stimulus=0;                            % Number of inputs, stimuli or control variables
inputs.model.st_names=char('xA', 'xB', 'xC', 'eA', 'eC');           % Names of the states
inputs.model.par_names=char('k1', 'k2', 'eB');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char('dxA = -k1*xA;', 'dxB = k1*xA-k2*xB;', 'dxC = k2*xB;', 'deA = 0;', 'deC = 0;');                                 % Equations describing system dynamics.
                            %Time derivatives are regarded 'd'st_name''
inputs.model.par = [0.25, 0.5, 0.75];         % Nominal value for the parameters
% inputs.model.AMIGOsensrhs = 1;                       % Generate the sensitivity equations for exact
%                                                      % Jacobian computation
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.166, 0.333, 0.5, 0.666, 0.833];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('y1', 'y2', 'y3', 'y4'); % Names of the observables
inputs.exps.obs{1}=char('y1 = xC', 'y2 = eA * xA + eB * xB + eC * xC', 'y3 = eA', 'y4 = eC');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=20;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[

];


inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=1.0*ones(1,3);
inputs.PEsol.global_theta_min=0.0*ones(1,3);

inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=1.0*ones(1,5);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,5);                % Minimum allowed values for the initial conditions

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
 inputs.nlpsol.nlpsolver='ess';                      % Solver used for optimization
 inputs.nlpsol.eSS.log_var =1:8;                    % Index of parameters to be considered in log scale
 inputs.nlpsol.eSS.maxeval =100000;                  % Maximum number of cost function evaluations
 inputs.nlpsol.eSS.maxtime = 600;                    % Maximum time spent for optimization
 inputs.nlpsol.eSS.local.solver = 'nl2sol';
 inputs.nlpsol.eSS.local.finish = 'nl2sol';
 
 inputs.nlpsol.eSS.local.nl2sol.maxiter             =      1000;
 inputs.nlpsol.eSS.local.nl2sol.maxfeval            =      2000;
 inputs.nlpsol.eSS.local.nl2sol.display             =        1;
 inputs.nlpsol.eSS.local.nl2sol.tolrfun             =     1e-10;
 inputs.nlpsol.eSS.local.nl2sol.tolafun             =     1e-10;
 %inputs.nlpsol.eSS.local.nl2sol.iterfun             =       [];     
 inputs.nlpsol.eSS.local.nl2sol.objrtol			 =     1e-10;
%  inputs.nlpsol.eSS.local.nl2sol.maxiter = 150;       % Parameters for local solver
%  inputs.nlpsol.eSS.local.nl2sol.maxfeval = 200;
  inputs.nlpsol.eSS.local.nl2sol.display = 1;
%  inputs.nlpsol.eSS.local.nl2sol.objrtol = 1e-6;
%  inputs.nlpsol.eSS.local.nl2sol.tolrfun = 1e-5;
% %
% inputs.exps.u_interp{1}='sustained';          % Stimuli definition for experiment 1
                                              % Initial and final time
%inputs.exps.u{1}=1;                           % Values of the inputs for exp 1
AMIGO_Prep(inputs);
AMIGO_PE(inputs);

