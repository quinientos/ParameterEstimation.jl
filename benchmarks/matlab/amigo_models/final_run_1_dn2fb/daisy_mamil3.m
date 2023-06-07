addpath(genpath('../../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='CRNModel'; % Folder to keep results
inputs.pathd.short_name='CRN';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=3;                                  % Number of states
inputs.model.n_par=5;                                 % Number of model parameters
%inputs.model.n_stimulus=0;                            % Number of inputs, stimuli or control variables
inputs.model.st_names=char('x1','x2','x3');    %x1=V, x2=R        % Names of the states
inputs.model.par_names=char('a12', 'a13', 'a21', 'a31', 'a01');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char('dx1 = -(a21 + a31 + a01) * x1 + a12 * x2 + a13 * x3;', 'dx2 = a21 * x1 - a12 * x2;', 'dx3 = a31 * x1 - a13 * x3;');                                 % Equations describing system dynamics.
inputs.model.par = [0.167, 0.333, 0.5, 0.667, 0.833];         % Nominal value for the parameters
% inputs.model.AMIGOsensrhs = 1;                       % Generate the sensitivity equations for exact
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.25, 0.5, 0.75];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('y1','y2'); % Names of the observables
inputs.exps.obs{1}=char('y1=x1','y2=x2');
inputs.exps.t_con{1}=[0 1];                 % Input swithching times including:
inputs.exps.n_s{1}=20;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.25 0.5
0.24164112111954192 0.5020631869286435
0.23405739965453667 0.5038996720910395
0.22716652264917694 0.5055306485113934
0.2208950227384578 0.506975085362278
0.2151773264209839 0.5082499664619374
0.209954904735863 0.5093705031202208
0.2051755153507044 0.5103503240866537
0.2007925262364608 0.5112016450614154
0.1967643120051907 0.5119354200045073
0.19305371536522833 0.5125614761330655
0.18962756639207762 0.5130886344357856
0.18645625362106194 0.5135248172058021
0.18351334120796453 0.5138771440332476
0.18077522741324484 0.5141520174458422
0.17822083964404717 0.5143551993913263
0.17583136252066175 0.5144918794466611
0.1735899950728742 0.5145667357296222
0.17148173405298042 0.514583989267508
0.16949318066779653 0.5145474524986335
];

inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=1.0*ones(1,5);
inputs.PEsol.global_theta_min=0.0*ones(1,5);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=1.0*ones(1,3);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,3);
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
%  inputs.nlpsol.eSS.log_var = 1:3;                    % Index of parameters to be considered in log scale
 inputs.nlpsol.eSS.local.solver = 'nl2sol';
 inputs.nlpsol.eSS.local.finish = 'nl2sol';
 inputs.nlpsol.eSS.maxeval = 100000;                  % Maximum number of cost function evaluations
 inputs.nlpsol.eSS.maxtime = 600;                    % Maximum time spent for optimization
  inputs.nlpsol.eSS.local.nl2sol.maxiter             =      1000;
 inputs.nlpsol.eSS.local.nl2sol.maxfeval            =      2000;
 inputs.nlpsol.eSS.local.nl2sol.tolrfun             =     1e-10;
 inputs.nlpsol.eSS.local.nl2sol.tolafun             =     1e-10;
  inputs.nlpsol.eSS.local.nl2sol.objrtol			 =     1e-10;

inputs.nlpsol.eSS.log_var =1:8; 
% inputs.exps.u_interp{1}='sustained';          % Stimuli definition for experiment 1
                                              % Initial and final time
%inputs.exps.u{1}=1;                           % Values of the inputs for exp 1
AMIGO_Prep(inputs);
AMIGO_PE(inputs);

