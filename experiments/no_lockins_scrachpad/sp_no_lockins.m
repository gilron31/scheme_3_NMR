
T_MES = 1;

instr.scope2.Reset;
pause(1)
instr.scope2.HighRes;
instr.scope2.setTref('LEFT')
instr.scope2.TrigSource('LINE');
fprintf(instr.scope2.Ins,':CHAN1:DISP 0')
fprintf(instr.scope2.Ins,':CHAN2:DISP 1')
fprintf(instr.scope2.Ins,':CHAN3:DISP 1')
fprintf(instr.scope2.Ins,':CHAN4:DISP 1')
fprintf(instr.scope2.Ins, ':WAV:POIN:MODE MAX');
fprintf(instr.scope2.Ins, ':WAV:POIN 500000');
instr.scope2.setChCoupling(2, 'AC')
instr.scope2.setChCoupling(3, 'AC')
instr.scope2.setChCoupling(4, 'AC')
instr.scope2.setVscale(2, 20e-3);
instr.scope2.setVscale(3, 20e-3);
instr.scope2.setVscale(4, 200e-3);
instr.scope2.setTscale(T_MES / 10);


instr.scope2.Single()

[t, v_fast_ref] = instr.scope2.Read(2);
[t, v_slow_ref] = instr.scope2.Read(3);
[t, v_bpd] = instr.scope2.Read(4);

[t, v_fast_ref_LPF] = apply_lorentzian_filt(t, v_fast_ref, 1000);

vmult = (v_fast_ref - v_fast_ref_LPF) .* v_bpd;
[tf, vf] = apply_lorentzian_filt(t, vmult, 1000);

%%

Lorentz_func = @(p,fx) -p(1)./(1+((fx-p(2))/p(3)).^2) + p(4); 
params = fminsearch(@(p) sum(abs( ress2 - Lorentz_func(p,vs) ).^2),...
    [max(abs(ress2)),vs(ind),0.25*approx_width, ress(1)]);











