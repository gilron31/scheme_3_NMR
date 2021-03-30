%%

optical_setup.pump_on = 1;
optical_setup.prob_on = 1;
optical_setup.pump_detune = 44e-3;
optical_setup.prob_detune = -12e-3;
optical_setup.pump_ma = 173;
optical_setup.prob_ma = 102;
optical_setup.pump_power = 'max';
optical_setup.prob_power = 5.1e-3;

%%

LIA_setup.fast_bw = 10e3;
LIA_setup.slow_bw = 1e3;
LIA_setup.fast_gain = 0e3;
LIA_setup.slow_gain = 30;

LIA_setup.note1 = 'slow gain is 10db in input + 20db in output';

LIA_setup.SR830_tc = 100e-3;
LIA_setup.SR830_slope = 24;
LIA_setup.SR830_phase = 130;
LIA_setup.SR830_sens = 10e-3;

%% 
floquet_note = '[sig, fs, amppp] = arb_floquet_input(1.0,1.2 ,51.8e3, 0.1, 131.5);';
fspan = [0.2,0.3,0.4, 0.5, 0.8, 1.0,1.2, 1.5,1.7, 2.0,2.2,2.5, 3.0, 4.0, 5.0];
exp_data = get_complete_tf(instr, fspan, 2e-3, optical_setup, LIA_setup, '.', floquet_note);