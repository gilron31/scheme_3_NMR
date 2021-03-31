%%
OFFSET = 0.5;
INIT_F = 29.400e3;
INIT_A = 1.42;
CH_AGF = 1;
agf = instr.AG3;
%%
agf.Sin(CH_AGF, INIT_F, INIT_A, 0.0, OFFSET); 
base_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 32);

FOM = @(m, s) -(sum((m - base_exp_data.main_sens_vec).^2) + sum((s - base_exp_data.sec_sens_vec).^2));

moddepths = [0.0, 0.01, 0.02, 0.03, 0.04, 0.05];
opts = [];
exp_datas = [];
curr_init_f = INIT_F;
curr_init_A = INIT_A;
counter = 1;
for moddepth = moddepths
    exp_data = autotune_floquet_parameters(instr.AG5, instr.AG1, instr.AG3, instr.scope2, 1,4,2,3, (1 + moddepth)*OFFSET, curr_init_f, curr_init_A, FOM, 100);
    agf.Sin(CH_AGF, exp_data.final_F, exp_data.final_A, 0.0, (1 + moddepth)*OFFSET); 
    opt_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 32);
    curr_init_f = exp_data.final_F;
    curr_init_A = exp_data.final_A;
    
    analyze_autotune(exp_data, counter);
    
    
    exp_datas = [exp_datas, exp_data];
    opts = [opts, opt_exp_data];
    counter = counter + 4;
end
%%

amps = [exp_datas.final_A];
freqs = [exp_datas.final_F];

figure(1234);
subplot(2,1,1);
plot(moddepths, amps);
subplot(2,1,2);
plot(moddepths, freqs);


naive_exp_datas = [];
for moddepth = moddepths
    agf.Sin(CH_AGF, INIT_F, INIT_A, 0.0, (1 + moddepth)*OFFSET); 
    naive_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 33);
    naive_exp_datas = [naive_exp_datas, naive_exp_data];
end

AMFM_exp_datas = [];
for moddepth = moddepths
    agf.Sin(CH_AGF, (1 + moddepth)*INIT_F, (1 + moddepth)*INIT_A, 0.0, (1 + moddepth)*OFFSET); 
    AMFM_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 34);
    AMFM_exp_datas = [AMFM_exp_datas, AMFM_exp_data];

end

FM_exp_datas = [];
for moddepth = moddepths
    agf.Sin(CH_AGF, (1 + moddepth)*INIT_F, INIT_A, 0.0, (1 + moddepth)*OFFSET); 
    FM_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 35);
    FM_exp_datas = [FM_exp_datas, FM_exp_data];
end

all_exp_data.INIT_F = INIT_F;
all_exp_data.INIT_A = INIT_A;
all_exp_data.OFFSET = OFFSET;
all_exp_data.moddepths = moddepths;
all_exp_data.FM_exp_datas = FM_exp_datas;
all_exp_data.AMFM_exp_datas = AMFM_exp_datas;
all_exp_data.naive_exp_datas = naive_exp_datas;
all_exp_data.opts = opts;
all_exp_data.exp_datas = exp_datas;


save_exp_data(all_exp_data, 'magnetometer_setup', optical_setup, '.')









