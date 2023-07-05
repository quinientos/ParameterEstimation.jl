addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='SeirModel'; % Folder to keep results
inputs.pathd.short_name='Seir';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=4;                                  % Number of states
inputs.model.n_par=3;                                 % Number of model parameters
%inputs.model.n_stimulus=0;                            % Number of inputs, stimuli or control variables
inputs.model.st_names=char('S', 'E', 'In', 'N');    %x1=V, x2=R        % Names of the states
inputs.model.par_names=char('a','b', 'nu');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char('dS = -b* S * In / N;', 'dE = b * S * In / N - nu * E;', 'dIn = nu * E - a * In', 'dN = 0');                                 % Equations describing system dynamics.
inputs.model.par = [0.2, 0.4, 0.6, 0.8];         % Nominal value for the parameters
% inputs.model.AMIGOsensrhs = 1;                       % Generate the sensitivity equations for exact
%                                                      % Jacobian computation
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.25, 0.5, 0.75];        % Initial conditions
inputs.exps.t_f{1}=1
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('Y1', 'Y2'); % Names of the observable
inputs.exps.obs{1}=char('Y1=In', 'Y2=N');
inputs.exps.t_con{1}=[-0.5 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=20;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.6 0.8
0.6076131789672516 0.8
0.6146792755833733 0.8
0.6212214829980278 0.8
0.6272619036973741 0.8
0.632821611227949 0.8
0.6379207082402614 0.8
0.642578381057376 0.8
0.6468129509470278 0.8
0.6506419222722198 0.8
0.6540820276967279 0.8
0.6571492706109203 0.8
0.6598589649325685 0.8
0.6622257724535925 0.8
0.6642637378503197 0.8
0.6659863215159018 0.8
0.6674064303509646 0.8
0.6685364466432833 0.8
0.6693882551218686 0.8
0.669973268318622 0.8
];
inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=1.0*ones(1,3);
inputs.PEsol.global_theta_min=0.0*ones(1,3);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=1.0*ones(1,4);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,4);
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
inputs.nlpsol.eSS.log_var = 1:7;                    % Index of parameters to be considered in log scale
inputs.nlpsol.eSS.maxeval = 100000;                  % Maximum number of cost function evaluations                       
inputs.nlpsol.eSS.maxtime = 600;                    % Maximum time spent for optimization                                
inputs.nlpsol.eSS.local.solver = 'nl2sol';                                                                               
inputs.nlpsol.eSS.local.finish = 'nl2sol';         
inputs.nlpsol.eSS.local.nl2sol.maxiter             =      1000;                                                          
inputs.nlpsol.eSS.local.nl2sol.maxfeval            =      2000;                                                          
inputs.nlpsol.eSS.local.nl2sol.tolrfun             =     1e-10;                                                          
inputs.nlpsol.eSS.local.nl2sol.tolafun             =     1e-10;
inputs.nlpsol.eSS.local.nl2sol.objrtol                   =     1e-10;
inputs.nlpsol.eSS.local.nl2sol.display = 1;
% %
% inputs.exps.u_interp{1}='sustained';          % Stimuli definition for experiment 1
                                              % Initial and final time
%inputs.exps.u{1}=1;                           % Values of the inputs for exp 1
AMIGO_Prep(inputs);
AMIGO_PE(inputs);
