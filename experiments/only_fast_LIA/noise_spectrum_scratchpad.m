
exp_data_noise_spectrum;

coil_G_2_V = 0.008;
Vref_2_Vcoil = 1;;
ref_V_2_G = Vref_2_Vcoil / coil_G_2_V;
% ref_amp_V;
peak_response_relative = 0.03;

signal_sensitivity_V_2_G = peak_response_relative / (ref_V_2_G);
T_MES = 100;

res = acquire_high_res_nofastLIA(instr.scope2, T_MES);

sig_Vsig = res.v_sec;
b = (sig_Vsig - mean(sig_Vsig))/signal_sensitivity_V_2_G;
[Sf,f] =pwelch(b,[],[],[],1/(t(2)-t(1)));

figure; loglog(f, sqrt(abs(Sf)));