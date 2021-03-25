channel_configuration.main_BPD.sc = 2;
channel_configuration.secondary_BPD.sc = 2;
channel_configuration.main_BPD.ch = 3;
channel_configuration.secondary_BPD.ch = 4;

scope2.Reset;
pause(1)
scope2.HighRes;
scope2.setTref('LEFT')
scope2.TrigSource('LINE');
fprintf(scope2.Ins,':CHAN1:DISP 0')
fprintf(scope2.Ins,':CHAN2:DISP 0')
fprintf(scope2.Ins,':CHAN3:DISP 2')
fprintf(scope2.Ins,':CHAN4:DISP 1')
fprintf(scope2.Ins, ':WAV:POIN:MODE MAX');
fprintf(scope2.Ins, ':WAV:POIN 500000');

scope2.setTscale(50);
scope2.setVscale(3, 0.1);
scope2.setVscale(4, 0.1);

scope2.Single();
pause(500)
[t3, v3] = scope2.Read(3);
[t4, v4] = scope2.Read(4);

optical_setup.pump_on = 0;
optical_setup.prob_on = 1;
optical_setup.pump_detune = 200e-3;
optical_setup.prob_detune = -12e-3;
optical_setup.pump_ampere = 123;
optical_setup.prob_ampere = 102;
optical_setup.pump_power = 0;
optical_setup.prob_power = 5.1e-3;

exp_data.main_BPD = v3;
exp_data.secondary_BPD = v4;
exp_data.time = t3;

save('exp_resutls', 'optical_setup', 'channel_configuration',  'exp_data')


