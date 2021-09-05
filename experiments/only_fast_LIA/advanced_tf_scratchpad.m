%%
% OFFSET = 1;
% INIT_F = 60.0e3;
% INIT_A_pp = 5;
% CH_AGF = 1;
% agf = instr.AG3;
% CH_MAIN = 2;
% CH_SEC = 3;
% CH_FAST_REF = 1;
% CH_DRIVE_REF = 4;
% CH_AG_SIG = 2;
% 
% FREQ_DIV_2_MOD = 62000;
% AMP_DIV_2_MOD = 0;
% moddepth = 0.1;
% slow_mod_freq = 145.0;
% slow_mod_freq = 66.5147;
% slow_mod_freq = 60.49281;
% slow_mod_freq = 66.06631;
%%

OFFSET = 0.5;
INIT_F = 34.400e3;
INIT_App = 1.0;

CH_AGF = 1;
agf = instr.AG3;
CH_MAIN = 2;
CH_SEC = 3;
CH_FAST_REF = 1;
CH_DRIVE_REF = 4;
CH_AG_SIG = 2;

FREQ_DIV_2_MOD = 24000;
AMP_DIV_2_MOD = 0;
moddepth = 0.1;
slow_mod_freq = 65.0;

N_CYCLE = 1;
[sig, fs, amppp, ts, sig_funcs] = arb_floquet_input2(OFFSET*moddepth, slow_mod_freq, INIT_A/2, INIT_F, moddepth*FREQ_DIV_2_MOD/INIT_F,moddepth * AMP_DIV_2_MOD /(INIT_A/2) , N_CYCLE);

agf.LoadARB(CH_AGF, fs, sig, amppp, 'sine_1');
% oscilating_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 66);

    [stt, wfrm] = instr.AG5.Output(CH_AG_SIG, 1, true); 
    ag_x_dc = wfrm{1}.p(3);
    instr.AG5.DC(CH_AG_SIG, ag_x_dc);
    
    [stt, wfrm] = instr.AG1.Output(CH_AG_SIG, 1, true); 
    ag_y_dc = wfrm{1}.p(3);
    instr.AG1.DC(CH_AG_SIG, ag_y_dc);
% fspan = [0.05, 0.07, 0.1, 0.12, 0.15, 0.2, 0.25];
fspan = [0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.7, 1.0, 2.0, 3.0] + 0.9;
% fspan = [0.1,0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.7, 1.0, 2.0, 3.0];
% fspan = [2 + linspace(-1, 1, 10), [0.1,0.15, 0.2, 0.25, 0.3, 0.35]];
% fspan = [0.5, 0.7, 1.0, 2.0, 3.0];
% fspan = [linspace(0.02, 1, 20) , linspace(1.1, 5, 10)];
DRIVE_AMPPP = 2e-3;
TMES_WN = 100;
%%
switch_ref_measurement(instr.AG1, 'x')
exp_data_x = single_tf_no_fastLIA(instr.AG5, instr.scope2, CH_MAIN,CH_SEC,CH_FAST_REF,CH_DRIVE_REF, fspan, DRIVE_AMPPP, slow_mod_freq);
% exp_data_x = single_tf_no_fastLIA_wnoise(instr.AG5, instr.scope2, CH_MAIN,CH_SEC,CH_FAST_REF,CH_DRIVE_REF, TMES_WN, DRIVE_AMPPP, slow_mod_freq);

switch_ref_measurement(instr.AG1, 'y')
instr.AG5.DC(CH_AG_SIG, ag_x_dc);
exp_data_y = single_tf_no_fastLIA(instr.AG1, instr.scope2, CH_MAIN,CH_SEC,CH_FAST_REF,CH_DRIVE_REF, fspan, DRIVE_AMPPP, slow_mod_freq);
% exp_data_y = single_tf_no_fastLIA_wnoise(instr.AG1, instr.scope2, CH_MAIN,CH_SEC,CH_FAST_REF,CH_DRIVE_REF, TMES_WN, DRIVE_AMPPP, slow_mod_freq);
%%
exp_params.OFFSET = OFFSET;
exp_params.INIT_F = INIT_F;
exp_params.INIT_A = INIT_A;
exp_params.FREQ_DIV_2_MOD = FREQ_DIV_2_MOD;
exp_params.AMP_DIV_2_MOD = AMP_DIV_2_MOD;
exp_params.moddepth = moddepth;
exp_params.slow_mod_freq = slow_mod_freq;
exp_params.N_CYCLE = N_CYCLE;
%%
instr.AG1.DC(CH_AG_SIG, ag_y_dc);

exp_data.exp_params = exp_params;
exp_data.exp_data_x = exp_data_x;
exp_data.exp_data_y = exp_data_y;
if ~exist('optical_setup')
    display('WARNING! no optical setup specified!');
    optical_setup = '';
end
save_exp_data(exp_data, 'tf_without_slow_LIA_wnoise', optical_setup, '.')