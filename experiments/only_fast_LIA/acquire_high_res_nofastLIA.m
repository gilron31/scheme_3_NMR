function [ res ] = acquire_high_res_nofastLIA( sc, T_mes)

CH_MAIN = 2;
CH_SEC = 3;
CH_CALIB_REF = 4;
CH_FAST_REF = 1;
VSCALE_DEFAULT_V = 5e-3;

sc.Reset;
pause(1)
sc.HighRes;
sc.setTref('LEFT')
sc.TrigSource('LINE');
fprintf(sc.Ins,':CHAN1:DISP 1')
fprintf(sc.Ins,':CHAN2:DISP 1')
fprintf(sc.Ins,':CHAN3:DISP 1')
fprintf(sc.Ins,':CHAN4:DISP 1')
fprintf(sc.Ins, ':WAV:POIN:MODE MAX');
fprintf(sc.Ins, ':WAV:POIN 500000');
sc.setChCoupling(CH_FAST_REF, 'AC')
sc.setChCoupling(CH_MAIN, 'DC')
sc.setChCoupling(CH_SEC, 'DC')
sc.setChCoupling(CH_CALIB_REF, 'DC')
sc.setVscale(CH_FAST_REF, VSCALE_DEFAULT_V);
sc.setVscale(CH_MAIN, VSCALE_DEFAULT_V);
sc.setVscale(CH_SEC, VSCALE_DEFAULT_V);
sc.setVscale(CH_CALIB_REF, VSCALE_DEFAULT_V);
sc.setTscale(T_mes / 10);


sc.Single()
sc.readyToRead(3*T_mes + 1);
[res.t, res.v_main] = sc.Read(CH_MAIN);
[res.ts, res.v_sec] = sc.Read(CH_SEC);
[res.tf, res.v_fast_ref] = sc.Read(CH_FAST_REF);
[res.tc, res.v_calib_ref] = sc.Read(CH_CALIB_REF);

% display([length(res.t), length(res.ts), length(res.tf), length(res.tc)])
% display([length(res.v_main), length(res.v_sec), length(res.v_fast_ref), length(res.v_calib_ref)])

len_diff = length(res.t) - length(res.v_main);
if (abs(len_diff)>0)
    display('Acquire high res nofastLIA returned nonmatching t,v')
end



end

