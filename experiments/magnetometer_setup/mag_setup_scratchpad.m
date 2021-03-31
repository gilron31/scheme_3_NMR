%%
OFFSET = 0.5;
INIT_F = 29.400e3;
INIT_A = 1.42;
CH_AGF = 1;
agf = instr.AG3;
%%


modulation_param = -0.25;

%% Base
agf.Sin(CH_AGF, INIT_F, INIT_A, 0.0, OFFSET); 
base_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 32);
%% Detune without correction
agf.Sin(CH_AGF, INIT_F, INIT_A, 0.0, (1 + modulation_param)*OFFSET); 
naive_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 33);
%% Only FM
agf.Sin(CH_AGF, (1 + modulation_param)*INIT_F, INIT_A, 0.0, (1 + modulation_param)*OFFSET); 
FM_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 34);

%% Only AM
agf.Sin(CH_AGF, INIT_F, (1 + modulation_param)*INIT_A, 0.0, (1 + modulation_param)*OFFSET); 
AM_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 35);

%% AM & FM
agf.Sin(CH_AGF, (1 + modulation_param)*INIT_F, (1 + modulation_param)*INIT_A, 0.0, (1 + modulation_param)*OFFSET); 
AMFM_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 36);



%%
FOM = @(m, s) -(sum((m - base_exp_data.main_sens_vec).^2) + sum((s - base_exp_data.sec_sens_vec).^2));
FOM = @(m, s) -(sum((s - base_exp_data.sec_sens_vec).^2));

%%

exp_data = autotune_floquet_parameters(instr.AG5, instr.AG1, instr.AG3, instr.scope2, 1,4,2,3, (1 + modulation_param)*OFFSET, (1 + modulation_param)*INIT_F, (1 + modulation_param)*INIT_A, FOM)

exp_data = autotune_floquet_parameters(instr.AG5, instr.AG1, instr.AG3, instr.scope2, 1,4,2,3, (1 + modulation_param)*OFFSET, exp_data.final_F, exp_data.final_A, FOM)