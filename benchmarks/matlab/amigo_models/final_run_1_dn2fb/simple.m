addpath(genpath('../../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='SimpleModel'; % Folder to keep results
inputs.pathd.short_name='Simple';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=2;                                  % Number of states
inputs.model.n_par=2;                                 % Number of model parameters
%inputs.model.n_stimulus=0;                            % Number of inputs, stimuli or control variables
inputs.model.st_names=char('x1','x2');    %x1=V, x2=R        % Names of the states
inputs.model.par_names=char('a','b');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
inputs.model.eqns=char('dx1 = -a * x2;','dx2 = 1 / b * (x1);');                                 % Equations describing system dynamics.
inputs.model.par = [0.333, 0.667];         % Nominal value for the parameters
% inputs.model.AMIGOsensrhs = 1;                       % Generate the sensitivity equations for exact
%                                                      % Jacobian computation
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
inputs.exps.exp_y0{1}=[0.333, 0.667];        % Initial conditions
inputs.exps.t_f{1}=1
inputs.exps.n_obs{1}=2;                       % Number of observables
inputs.exps.obs_names{1}=char('Y1', 'Y2'); % Names of the observable
inputs.exps.obs{1}=char('Y1=x1', 'Y2=x2');
inputs.exps.t_con{1}=[0 1];                 % Input swithching times including:
inputs.exps.n_s{1}=20;
inputs.exps.data_type='real';
inputs.exps.exp_data{1}=[
0.333 0.667
0.3210824045299947 0.6928091137083452
0.3087208144961867 0.717660207058798
0.29593232357567356 0.7415189158181557
0.28273461576546205 0.7643522480296363
0.2691459409299496 0.7861286296337465
0.25518508956539326 0.8068179481268767
0.24087136681699894 0.8263915942006628
0.22622456578155828 0.8448225013066107
0.21126494013837938 0.8620851830822327
0.19601317614255798 0.8781557685935256
0.18049036401969393 0.8930120353441123
0.16471796880160408 0.9066334400051187
0.1487178006443515 0.9190011468222988
0.1325119846723777 0.9300980536597044
0.11612293037841306 0.9399088156525458
0.09957330063829525 0.948419866423786
0.08288598037368437 0.955619436843565
0.0660840449066534 0.9614975713042377
0.049190728057923426 0.9660461414842879
];
inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=1.0*ones(1,2);
inputs.PEsol.global_theta_min=0.0.*ones(1,2);
inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=1.0*ones(1,2);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.0*ones(1,2);
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
inputs.nlpsol.eSS.log_var = 1:4;                    % Index of parameters to be considered in log scale
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
