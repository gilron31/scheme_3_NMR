%%
% OFFSET = 0.5;
% INIT_F = 29.400e3;
% INIT_A = 1.42;
% CH_AGF = 2;
OFFSET = 1;
INIT_F = 48.400e3;
INIT_App = 1;
CH_AGF =2;
agf = instr.AG3;
%%

% moddepths = [0.0,-0.05,-0.04, -0.03,-0.02,-0.01,0.0 0.01, 0.02, 0.03, 0.04, 0.05];
FREQ_DIV_2_MOD = 62000;
AMP_DIV_2_MOD = 0;
moddepth = 0.1;
slow_mod_freq = 30.4028;

agf.Sin(CH_AGF, INIT_F, INIT_A, 0.0, OFFSET); 
% natural_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 66);
natural_exp_data = measure_magnetometer_vector_sens2(instr.AG5, instr.AG1, instr.scope2, 4, 2, 3, 66, instr);

[sig, fs, amppp, ts, sig_funcs] = arb_floquet_input2(OFFSET*moddepth, slow_mod_freq, INIT_A/2, INIT_F, moddepth*FREQ_DIV_2_MOD/INIT_F,moddepth * AMP_DIV_2_MOD /(INIT_A/2) );
agf.LoadARB(CH_AGF, fs, sig, amppp, 'sine_1');
oscilating_exp_data = measure_magnetometer_vector_sens2(instr.AG5, instr.AG1, instr.scope2, 4, 2, 3, 66, instr);


[sig, fs, amppp, ts, sig_funcs] = arb_floquet_input2(OFFSET*moddepth, slow_mod_freq, INIT_A/2, INIT_F, moddepth*FREQ_DIV_2_MOD/INIT_F,moddepth * AMP_DIV_2_MOD /(INIT_A/2) );
agf.LoadARB(CH_AGF, fs, sig, amppp, 'sine_1');
oscilating_res_exp_data = measure_magnetometer_vector_sens2(instr.AG5, instr.AG1, instr.scope2, 4, 2, 3, 66, instr, slow_mod_freq, slow_mod_freq);


%%
% NOW with xenons
FREQ_DIV_2_MOD = 62000;
AMP_DIV_2_MOD = 0;
moddepth = 0.1;
slow_mod_freq = 65.21508;
[sig, fs, amppp, ts, sig_funcs] = arb_floquet_input2(OFFSET*moddepth, slow_mod_freq, INIT_A/2, INIT_F, moddepth*FREQ_DIV_2_MOD/INIT_F,moddepth * AMP_DIV_2_MOD /(INIT_A/2) );

agf.Sin(CH_AGF, INIT_F, INIT_A, 0.0, OFFSET); 
natural_exp_data = measure_magnetometer_vector_sens2(instr.AG5, instr.AG1, instr.scope2, 4, 2, 3, 66, instr);

agf.LoadARB(CH_AGF, fs, sig, amppp, 'sine_1');
oscilating_exp_data = measure_magnetometer_vector_sens2(instr.AG5, instr.AG1, instr.scope2, 4, 2, 3, 66, instr);


[sig, fs, amppp, ts, sig_funcs] = arb_floquet_input2(OFFSET*moddepth, slow_mod_freq, INIT_A/2, INIT_F, moddepth*FREQ_DIV_2_MOD/INIT_F,moddepth * AMP_DIV_2_MOD /(INIT_A/2) );
agf.LoadARB(CH_AGF, fs, sig, amppp, 'sine_1');
oscilating_res_exp_data = measure_magnetometer_vector_sens2(instr.AG5, instr.AG1, instr.scope2, 4, 2, 3, 66, instr, slow_mod_freq, slow_mod_freq);


% all_exp_data.INIT_F = INIT_F;
% all_exp_data.INIT_A = INIT_A;
% all_exp_data.OFFSET = OFFSET;
% all_exp_data.moddepths = moddepths;
% all_exp_data.naive_exp_datas = naive_exp_datas;
% all_exp_data.aug_exp_datas = aug_exp_datas;
% all_exp_data.FREQ_DIV_2_MOD = FREQ_DIV_2_MOD;
% all_exp_data.AMP_DIV_2_MOD = AMP_DIV_2_MOD;
% 
% 
% save_exp_data(all_exp_data, 'magnetometer_setup', optical_setup, '.')
% 
% 
% 
% 
% 




