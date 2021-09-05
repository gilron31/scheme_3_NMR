

CH_MAIN = 2;
CH_SEC = 3;
CH_FAST_REF = 1;
CH_DRIVE_REF = 4;
T_MES = 100;
F_REF = 145;
coil_G_2_V = 0.008;
Vref_2_Vcoil = 1.2;
ref_V_2_G = Vref_2_Vcoil / coil_G_2_V;
% ref_amp_V = 2e-3;
ref_amp_V = 1;
ref_amp_G = ref_amp_V / ref_V_2_G;
exp_data_noise_acq = acquire_just_noise(instr.scope2 ,CH_MAIN,CH_SEC,CH_FAST_REF,CH_DRIVE_REF, T_MES, F_REF);

peak_response_V = 0.5;
signal_sensitivity_G_2_V = (ref_amp_G) / peak_response_V;

% res = acquire_high_res_nofastLIA(instr.scope2, T_MES);
%% main sin
sig_Vsig = exp_data_noise_acq.v_main_sin;
t = exp_data_noise_acq.t;
b = (sig_Vsig - mean(sig_Vsig))*signal_sensitivity_G_2_V;
[Sf,f] =pwelch(b,[],[],[],1/(t(2)-t(1)));

figure; loglog(f, sqrt(abs(Sf)), 'x');grid on;
%% main cos
sig_Vsig = exp_data_noise_acq.v_main_cos;
t = exp_data_noise_acq.t;
b = (sig_Vsig - mean(sig_Vsig))*signal_sensitivity_G_2_V;
[Sf,f] =pwelch(b,[],[],[],1/(t(2)-t(1)));

figure; loglog(f, sqrt(abs(Sf)), 'x');grid on;
%% main dc
sig_Vsig = exp_data_noise_acq.v_main_dc;
t = exp_data_noise_acq.t;
b = (sig_Vsig - mean(sig_Vsig))*signal_sensitivity_G_2_V;
[Sf,f] =pwelch(b,[],[],[],1/(t(2)-t(1)));

figure; loglog(f, sqrt(abs(Sf)), 'x');grid on;
%% sec sin
sig_Vsig = exp_data_noise_acq.v_sec_sin;
t = exp_data_noise_acq.t;
b = (sig_Vsig - mean(sig_Vsig))*signal_sensitivity_G_2_V;
[Sf,f] =pwelch(b,[],[],[],1/(t(2)-t(1)));

figure; loglog(f, sqrt(abs(Sf)), 'x');grid on;
%% sec cos
sig_Vsig = exp_data_noise_acq.v_sec_cos;
t = exp_data_noise_acq.t;
b = (sig_Vsig - mean(sig_Vsig))*signal_sensitivity_G_2_V;
[Sf,f] =pwelch(b,[],[],[],1/(t(2)-t(1)));

figure; loglog(f, sqrt(abs(Sf)), 'x');grid on;
%% sec dc
sig_Vsig = exp_data_noise_acq.v_sec_dc;
t = exp_data_noise_acq.t;
b = (sig_Vsig - mean(sig_Vsig))*signal_sensitivity_G_2_V;
[Sf,f] =pwelch(b,[],[],[],1/(t(2)-t(1)));

figure; loglog(f, sqrt(abs(Sf)), 'x');grid on;