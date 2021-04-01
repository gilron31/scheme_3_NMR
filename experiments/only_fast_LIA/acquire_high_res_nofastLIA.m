function [ res ] = acquire_high_res_nofastLIA( sc, T_mes)

CH_MAIN = 2;
CH_SEC = 3;
CH_CALIB_REF = 4;
CH_FAST_REF = 1;

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
sc.setVscale(CH_FAST_REF, 20e-3);
sc.setVscale(CH_MAIN, 20e-3);
sc.setVscale(CH_SEC, 20e-3);
sc.setVscale(CH_CALIB_REF, 20e-3);
sc.setTscale(T_mes / 10);


sc.Single()
sc.readyToRead(3*T_mes + 1);
[res.t, res.v_main] = sc.Read(CH_MAIN);
[res.t, res.v_sec] = sc.Read(CH_SEC);
[res.t, res.v_fast_ref] = sc.Read(CH_FAST_REF);
[res.t, res.v_calib_ref] = sc.Read(CH_CALIB_REF);




end

