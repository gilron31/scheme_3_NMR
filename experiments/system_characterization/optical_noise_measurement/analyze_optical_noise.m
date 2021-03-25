load('exp_resutls_25-Mar-2021_104953.mat')
load('exp_resutls_25-Mar-2021_103735.mat')

t = exp_data.time;
v_main = exp_data.main_BPD;
v_sec = exp_data.secondary_BPD;
[Sf_main,f] =pwelch(v_main - mean(v_main) ,[],[],[],1/(t(2)-t(1)));
[Sf_sec,f] =pwelch(v_sec - mean(v_sec),[],[],[],1/(t(2)-t(1)));

figure;
loglog(f, sqrt(Sf_main), 'x');
hold on 
loglog(f, sqrt(Sf_sec), 'x');
