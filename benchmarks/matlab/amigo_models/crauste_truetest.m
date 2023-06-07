addpath(genpath('../src'))
addpath(genpath("./"))
%======================
% PATHS RELATED DATA
%======================
inputs.pathd.results_folder='CrausteModel'; % Folder to keep results
inputs.pathd.short_name='Crauste';                 % To identify figures and reports
%======================
% MODEL RELATED DATA
%======================
clear
inputs.model.input_model_type='charmodelC';           % Model type- C
inputs.model.n_st=5;                                  % Number of states
inputs.model.n_par=13;                                 % Number of model parameters
%inputs.model.n_stimulus=0;                            % Number of inputs, stimuli or control variables
inputs.model.st_names=char('n', 'e', 's', 'm', 'p');    %x1=V, x2=R        % Names of the states
inputs.model.par_names=char('muN', 'muEE', 'muLE', 'muLL', 'muM', 'muP', 'muPE', 'muPL', 'deltaNE', 'deltaEL', 'deltaLM', 'rhoE', 'rhoP');             % Names of the parameters
%inputs.model.stimulus_names=char('light');  % Names of the stimuli
% Equations describing system dynamics.
inputs.model.eqns=char( 'dn = -1 * n * muN - n * p * deltaNE;', 'de = n * p * deltaNE - e * e * muEE - e * deltaEL + e * p * rhoE;', 'ds = s * deltaEL - s * deltaLM - s * s * muLL - e * s * muLE;', 'dm = s * deltaLM - muM * m;', 'dp = p * p * rhoP - p * muP - e * p * muPE - s * p * muPL;');
%inputs.model.par = [0.071 0.143 0.214 0.286 0.357 0.429 0.5 0.571 0.643 0.714 0.786 0.857 0.929];         % Nominal value for the parameters
inputs.model.par = 1.0*ones(1,13);
% inputs.model.AMIGOsensrhs = 1;                       % Generate the sensitivity equations for exact
%                                                      % Jacobian computation
%==================================
% EXPERIMENTAL SCHEME RELATED DATA
%==================================
% EXPERIMENT DESIGN
inputs.exps.n_exp=1;                          % Number of experiments
% EXPERIMENT 1
%inputs.exps.exp_y0{1}=[0.167 0.333 0.5 0.667 0.833];        % Initial conditions
inputs.exps.exp_y0{1}=1.0*ones(1,5);

inputs.exps.t_f{1}=1;                       % Experiments duration
inputs.exps.n_obs{1}=4;                       % Number of observables
% Names of the observables
inputs.exps.obs_names{1}=char('Y1', 'Y2', 'Y3', 'Y4');
%inputs.exps.obs{1}=char('Y1=e', 'Y2=n', 'Y3=s+m', 'Y4=p');
inputs.exps.obs{1}=char('Y1=n', 'Y2=e', 'Y3=s+m', 'Y4=p');
inputs.exps.t_con{1}=[0 1];                 % Input swithching times including:
inputs.exps.n_s{1}=20;
inputs.exps.data_type='real';

% JRB - USE DATA GENERATED BY SIMULATION WITH AMIGO2
inputs.exps.exp_data{1}=[
0.167000000000000   0.333000000000000   1.167000000000000   0.833000000000000
   0.161765268482503   0.336738623149624   1.167462198291024   0.828272235844519
   0.156719855886147   0.340215804156762   1.167619758297553   0.823484351507891
   0.151856564232855   0.343436855759607   1.167484135840088   0.818637345737587
   0.147168472624751   0.346407005064799   1.167066453965341   0.813732232272768
   0.142648926875720   0.349131399741564   1.166377511666433   0.808770040782429
   0.138291529424317   0.351615113982247   1.165427792429288   0.803751817670672
   0.134090129682252   0.353863154126374   1.164227472472583   0.798678626739132
   0.130038814672238   0.355880464030546   1.162786428801474   0.793551549727825
   0.126131899971776   0.357671930154432   1.161114247068878   0.788371686723506
   0.122363921027883   0.359242386325922   1.159220229181619   0.783140156446338
   0.118729624761195   0.360596618227278   1.157113400719820   0.777858096425203
   0.115223961464188   0.361739367585758   1.154802518169302   0.772526663057930
   0.111842077002376   0.362675336063254   1.152296075954630   0.767147031566142
   0.108579305295580   0.363409188854202   1.149602313290793   0.761720395851049
   0.105431161076251   0.363945557985921   1.146729220856433   0.756247968252541
   0.102393332913786   0.364289045328490   1.143684547294394   0.750730979220136
   0.099461676495134   0.364444225317433   1.140475805546294   0.745170676901145
   0.096632208158518   0.364415647386635   1.137110279023007   0.739568326650145
   0.093901098665892   0.364207838123177   1.133595027619755   0.733925210468030
];

% inputs.exps.exp_data{1}=[
% 0.167 0.333 1.167 0.833
% 0.1617652684725357 0.3367386231549916 1.1674621983039186 0.8282722358448441
% 0.15671985587826617 0.3402158041606118 1.1676197583088512 0.823484351507934
% 0.15185656422947322 0.34343685576076316 1.1674841358476329 0.8186373457373028
% 0.1471684726303022 0.3464070050607226 1.16706645396537 0.8137322322718711
% 0.14264892688000871 0.3491313997383474 1.166377511667357 0.8087700407817987
% 0.1382915294326209 0.35161511397694056 1.165427792426062 0.8037518176700943
% 0.13409012969776235 0.35386315411866553 1.1642274724617812 0.7986786267400974
% 0.13003881468527476 0.3558804640267109 1.1627864287926535 0.7935515497314423
% 0.12613189997436505 0.35767193015805676 1.1611142470688927 0.7883716867290157
% 0.1223639210290147 0.35924238633161204 1.159220229180258 0.7831401564528276
% 0.1187296247626636 0.360596618235306 1.15711340071811 0.7778580964337027
% 0.11522396145506492 0.36173936760155184 1.1548025181779469 0.7725266630682667
% 0.11184207699184334 0.3626753360808677 1.1522960759609644 0.7671470315768323
% 0.1085793052870843 0.3634091888740307 1.1496023132962594 0.761720395863957
% 0.1054311610545026 0.3639455580136445 1.146729220874444 0.7562479682661302
% 0.10239333289574486 0.36428904535594275 1.1436845473048232 0.7507309792339975
% 0.09946167647450446 0.364444225349907 1.1404758055624975 0.745170676917446
% 0.09663220813348108 0.364415647421014 1.1371102790390062 0.7395683266653845
% 0.09390109863971338 0.36420783816020147 1.1335950276355486 0.7339252104839125
% ];

inputs.ivpsol.rtol=1.0e-12;                            % [] IVP solver integration tolerances
inputs.ivpsol.atol=1.0e-12; 

inputs.PEsol.id_global_theta_y0='all';               % [] 'all'|User selected| 'none' (default)
inputs.PEsol.global_theta_y0_max=1. * ones(1,5);                % Maximum allowed values for the initial conditions
inputs.PEsol.global_theta_y0_min=0.* ones(1,5);
%inputs.PEsol.global_theta_y0_guess=[1.0 1.0 1.0 1.0 1.0];% nominal as initial guess to check consistency of data

inputs.PEsol.id_global_theta='all';
inputs.PEsol.global_theta_max=1.*ones(1,13);
inputs.PEsol.global_theta_min=0.*ones(1,13);


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
 inputs.nlpsol.eSS.maxeval = 60000;                  % Maximum number of cost function evaluations
 inputs.nlpsol.eSS.maxtime = 600;                    % Maximum time spent for optimization
 inputs.nlpsol.eSS.local.solver = 'dn2fb';
 inputs.nlpsol.eSS.local.finish = 'dn2fb';
 %inputs.nlpsol.eSS.local.solver = 'nl2sol';
 %inputs.nlpsol.eSS.local.finish = 'nl2sol';
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

%% JRB print estimated params and ic and compute errors wrt true values
%load('D:\AMIGO2\AMIGO2_R2019b\Results\Problem\PE_problem_eSS_run1\strreport_problem_run1.mat')
%p_estimated=results.fit.global_theta_estimated;
%ic_estimated=results.fit.global_theta_y0_estimated;
%
%p_true= [0.071 0.143 0.214 0.286 0.357 0.429 0.5 0.571 0.643 0.714 0.786 0.857 0.929];
%ic_true= [0.167 0.333 0.5 0.667 0.833];
%
%p_rel_error= abs(p_estimated-p_true)./p_true
%ic_rel_error= abs(ic_estimated-ic_true)./ic_true
%
%max_p_rel_error=max(p_rel_error)
%max_ic_rel_error=max(ic_rel_error)
%
