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
inputs.exps.obs{1}=char('y1 = xC', 'y2 = eA .* xA + eB .* xB + eC .* xC', 'y3 = eA', 'y4 = eC');
inputs.exps.t_con{1}=[-0.5, 0.5];                 % Input swithching times including:
inputs.exps.n_s{1}=20;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.5 0.776806 0.666 0.833
0.5086772229003079 0.7777084814004999 0.666 0.833
0.5171850626289066 0.7785945213887786 0.666 0.833
0.5255271877894304 0.7794644556102273 0.666 0.833
0.5337071800585298 0.7803186120808694 0.666 0.833
0.5417285371739051 0.7811573114461872 0.666 0.833
0.549594675474967 0.7819808671997903 0.666 0.833
0.5573089324238776 0.7827895859011597 0.666 0.833
0.5648745677862622 0.7835837672742043 0.666 0.833
0.5722947653723495 0.7843637043557865 0.666 0.833
0.5795726346582916 0.7851296836337973 0.666 0.833
0.5867112134519633 0.7858819852786851 0.666 0.833
0.593713469666056 0.7866208832956296 0.666 0.833
0.600582302454197 0.7873466456200682 0.666 0.833
0.6073205438322224 0.7880595342566595 0.666 0.833
0.6139309605651073 0.7887598054421503 0.666 0.833
0.6204162557284147 0.7894477097795067 0.666 0.833
0.6267790703992203 0.7901234923835174 0.666 0.833
0.6330219850086088 0.7907873929966835 0.666 0.833
0.6391475208615558 0.7914396461199886 0.666 0.833
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

