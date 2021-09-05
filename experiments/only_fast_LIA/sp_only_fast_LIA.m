
T_MES = 10;
CH_REF = 1;
CH_LIA_CT2 =  2;
CH_LIA_TRACKING = 3;
CH_LIA_BPD = 4;
APPROX_FREQ = 131.8;


instr.scope2.Reset;
pause(1)
instr.scope2.HighRes;
instr.scope2.setTref('LEFT')
instr.scope2.TrigSource('LINE');
fprintf(instr.scope2.Ins,':CHAN1:DISP 1')
fprintf(instr.scope2.Ins,':CHAN2:DISP 1')
fprintf(instr.scope2.Ins,':CHAN3:DISP 1')
fprintf(instr.scope2.Ins,':CHAN4:DISP 1')
fprintf(instr.scope2.Ins, ':WAV:POIN:MODE MAX');
fprintf(instr.scope2.Ins, ':WAV:POIN 500000');
instr.scope2.setChCoupling(1, 'AC')
instr.scope2.setChCoupling(2, 'DC')
instr.scope2.setChCoupling(3, 'DC')
instr.scope2.setChCoupling(4, 'DC')
instr.scope2.setVscale(1, 20e-3);
instr.scope2.setVscale(2, 20e-3);
instr.scope2.setVscale(3, 20e-3);
% instr.scope2.setVscale(4, 200e-3);
instr.scope2.setTscale(T_MES / 10);


instr.scope2.Single()

[t, v_ref] = instr.scope2.Read(CH_REF);
[t, v_ct2] = instr.scope2.Read(CH_LIA_CT2);
[t, v_LIA_tracking] = instr.scope2.Read(CH_LIA_TRACKING);


% ref_sine = get_sine_para

% 
% 
% [t, v_fast_ref_LPF] = apply_lorentzian_filt(t, v_fast_ref, 1000);
% 
% vmult = (v_fast_ref - v_fast_ref_LPF) .* v_bpd;
% [tf, vf] = apply_lorentzian_filt(t, vmult, 1000);

%%
DRIVE_FREQ = 1.0;
DRIVE_AMP_V = 2e-3/2;
BX_COIL_G_2_V = 0.008;

approx = get_sine_parameters(t, v_ref, APPROX_FREQ);
sine_const = @(p,t) p(1)*sin(2*pi*p(2).*t + p(3)) + p(4); 
p0 =  [abs(approx),APPROX_FREQ,angle(approx), 0];
params = fminsearch(@(p) sum(abs( v_ref - sine_const(p,t) ).^2),p0);
f_ref = params(2);
phi_ref = params(3);

[v_sin_ct2, v_cos_ct2] = LIA_simulator(t, v_ct2, f_ref, phi_ref, 1e-1);
[v_sin_tracking, v_cos_tracking] = LIA_simulator(t, v_LIA_tracking, f_ref, phi_ref, 1e-1);


res_ct2_sin_v = get_sine_parameters(t, v_sin_ct2, DRIVE_FREQ);
drive_amp_G = DRIVE_AMP_V * BX_COIL_G_2_V;
HZ_1_V_2_G = abs(res_ct2_sin_v) / drive_amp_G;

[Sf_main,f] =pwelch((v_sin_ct2 - mean(v_sin_ct2))/HZ_1_V_2_G ,[],[],[],1/(t(2)-t(1)));
figure;
loglog(f, sqrt(Sf_main), 'x');

% 
% figure; plot(t, v_ref, t, sine_const(params, t))
% 







