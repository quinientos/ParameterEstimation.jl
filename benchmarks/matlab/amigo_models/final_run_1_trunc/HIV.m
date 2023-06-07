 addpath(genpath('../../src'))
 addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='HIVModel'; % Folder to keep results
inputs.pathd.short_name='HIV';                 % To identify figures and reports
             

inputs.pathd.runident='r8';                           % [] Identifier required in order not to overwrite previous results
                                                       %    This may be modified from command line. 'run1'(default)
                                                     
%======================
% MODEL RELATED DATA
%======================

inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=5;                                  % Number of states
inputs.model.n_par=10;                                 % Number of model parameters
%inputs.model.n_stimulus=0;                            % Number of inputs, stimuli or control variables
inputs.model.st_names=char('x','yy','vv','w','z');           % Names of the states
inputs.model.par_names=char('lm', 'd', 'beta', 'a', 'k', 'uu', 'c', 'q', 'b', 'h');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char('dx = lm - d * x - beta * x * vv;','dyy = beta * x * vv - a * yy;','dvv = k * yy - uu * vv;','dw = c * x * yy * w - c * q * yy * w - b * w;','dz = c * q * yy * w - h * z;');                                 % Equations describing system dynamics.
                            %Time derivatives are regarded 'd'st_name''
inputs.model.par = [0.091, 0.181, 0.273, 0.364, 0.455, 0.545, 0.636, 0.727, 0.818, 0.909];         % Nominal value for the parameters
% inputs.model.AMIGOsensrhs = 1;                       % Generate the sensitivity equations for exact
%                                                      % Jacobian computation
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.167, 0.333, 0.5, 0.667, 0.833];        % Initial conditions
inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
inputs.exps.obs_names{1}=char('Y1', 'Y2', 'Y3', 'Y4'); % Names of the observables
inputs.exps.obs{1}=char('Y1=w', 'Y2=z', 'Y3=x', 'Y4=yy+vv');
inputs.exps.t_con{1}=[0 1];                 % Input swithching times including:
inputs.exps.n_s{1}=20;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.667 0.833 0.167 0.833
0.6349552202961081 0.7991950399207364 0.16898984195272782 0.8215307523669777
0.6045205061239881 0.766649301998696 0.17096207813623504 0.8102168536254242
0.5756102396397682 0.7353247570361866 0.1729172066990056 0.799056718554976
0.5481436790611169 0.7051837429029252 0.174855706729452 0.7880487508212214
0.5220446582856935 0.6761890475072501 0.17677803892654817 0.7771913445986528
0.49724130671603584 0.6483039803721521 0.17868464624940802 0.7664828861118742
0.4736657877079448 0.6214924340131521 0.18057595454660058 0.7559217550988611
0.4512540543070286 0.5957189360843648 0.18245237316553237 0.7455063261998145
0.42994562104240186 0.5709486932353244 0.18431429554236836 0.7352349702745788
0.4096833506620227 0.5471476275193559 0.18616209977287648 0.7251060556514526
0.3904132547008492 0.5242824061228971 0.18799614916478538 0.7151179493106368
0.37208430691859024 0.5023204651084934 0.1898167927720999 0.7052690180050313
0.35464826870767574 0.4812300278030994 0.19162436591184262 0.695557629321036
0.33805952563739416 0.4609801184058861 0.19341919066369814 0.6859821526819245
0.32227493436272875 0.4415405713367961 0.195201576353035 0.676540960296249
0.3072536791844925 0.42288203679882946 0.1969718200177759 0.667232428053639
0.29295713760074676 0.40497598298305426 0.1987302068595819 0.6580549363702537
0.27934875423850763 0.3877946953052991 0.20047701067980953 0.6490068709860536
0.2663939225964619 0.37131127303023614 0.2022124943007228 0.6400866237159748
];

inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12;

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=1.0*ones(1,10);
inputs.PEsol.global_theta_min=0.0*ones(1,10);

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
 inputs.nlpsol.eSS.log_var =1:10+5;                    % Index of parameters to be considered in log scale
 inputs.nlpsol.eSS.maxeval =100000;                  % Maximum number of cost function evaluations
 inputs.nlpsol.eSS.maxtime = 600;                    % Maximum time spent for optimization
 inputs.nlpsol.eSS.local.solver = 'nl2sol';
 inputs.nlpsol.eSS.local.finish = 'nl2sol';
 
 inputs.nlpsol.eSS.local.nl2sol.display             =        1;
%  inputs.nlpsol.eSS.local.nl2sol.maxiter = 150;       % Parameters for local solver
%  inputs.nlpsol.eSS.local.nl2sol.maxfeval = 200;
  inputs.nlpsol.eSS.local.nl2sol.display = 1;
%  inputs.nlpsol.eSS.local.nl2sol.objrtol = 1e-6;
%  inputs.nlpsol.eSS.local.nl2sol.tolrfun = 1e-5;
% %
% inputs.exps.u_interp{1}='sustained';          % Stimuli definition for experiment 1
                                              % Initial and final time
%inputs.exps.u{1}=1;                           % Values of the inputs for exp 1
%AMIGO_Prep(inputs);
AMIGO_PE(inputs);


