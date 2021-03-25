
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

scope2.Single();
[t3, v3] = scope2.Read(3);
[t4, v4] = scope2.Read(4);
