%%
% OFFSET = 0.5;
% INIT_F = 29.400e3;
% INIT_App = 1.42;
OFFSET = 0.5;
INIT_F = 34.400e3;
INIT_App = 1.0;
CH_AGF =2;
agf = instr.AG3;
fprintf(agf.Ins,':SOURce1:TRACk ON')
agf.OutputON([1,2])
%%

% moddepths = [0.0,-0.05,-0.04, -0.03,-0.02,-0.01,0.0 0.01, 0.02, 0.03, 0.04, 0.05];
moddepths = [0.0, linspace(-0.1, 0.1, 11)];
FREQ_DIV_2_MOD = 24000;
AMP_DIV_2_MOD = 0;
freq_add = @(mod) mod * FREQ_DIV_2_MOD;
amp_add = @(mod) mod * AMP_DIV_2_MOD;

%% reference measurement
agf.Sin(CH_AGF, INIT_F, INIT_App, 0.0, (1 + 0)*OFFSET); 
naive_exp_data = measure_magnetometer_vector_sens2(instr.AG5, instr.AG1, instr.scope2, 4, 2, 3, 68, instr, 75, 155);

%%
naive_exp_datas = [];
for moddepth = moddepths
    agf.Sin(CH_AGF, INIT_F, INIT_App, 0.0, (1 + moddepth)*OFFSET); 
%     naive_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 66);
    naive_exp_data = measure_magnetometer_vector_sens2(instr.AG5, instr.AG1, instr.scope2, 4, 2, 3, 66, instr);
    naive_exp_datas = [naive_exp_datas, naive_exp_data];
    axis image
end


aug_exp_datas = [];
for moddepth = moddepths
    agf.Sin(CH_AGF, INIT_F + freq_add(moddepth), INIT_A + amp_add(moddepth), 0.0, (1 + moddepth)*OFFSET); 
%     aug_exp_data = measure_magnetometer_vector_sens(instr.AG5, instr.AG1, instr.scope2, 1, 4, 2, 3, 62);
    aug_exp_data = measure_magnetometer_vector_sens2(instr.AG5, instr.AG1, instr.scope2, 4, 2, 3, 63, instr);
    aug_exp_datas = [aug_exp_datas, aug_exp_data];
    axis image

end

all_exp_data.INIT_F = INIT_F;
all_exp_data.INIT_A = INIT_App;
all_exp_data.OFFSET = OFFSET;
all_exp_data.moddepths = moddepths;
all_exp_data.naive_exp_datas = naive_exp_datas;
all_exp_data.aug_exp_datas = aug_exp_datas;
all_exp_data.FREQ_DIV_2_MOD = FREQ_DIV_2_MOD;
all_exp_data.AMP_DIV_2_MOD = AMP_DIV_2_MOD;


save_exp_data(all_exp_data, 'magnetometer_setup', optical_setup, '.')









