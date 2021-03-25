automatic = 1;
clear WP
WP.automatic = automatic; 

WP.Floquet_fast_amp_Vpp = str2num(query(AG3.Ins, 'SOURce2:VOLT?'));
WP.FLoquet_fast_freq_hz = str2num(query(AG3.Ins, 'SOURce2:FREQ?'));

WP.By_DC_V = str2num(query(AG1.Ins, 'SOURce2:VOLT:OFFS?'));
WP.Bx_DC_V = str2num(query(AG5.Ins, 'SOURce2:VOLT:OFFS?'));

WP.BBcurrent = BB.ReadCurrent(1);
WP.BBVlim = BB.VLim(nan,1);

WP.pump_detune_V = str2num(query(AG2.Ins, 'SOURce1:VOLT:OFFS?'));
WP.prob_detune_V = str2num(query(AG2.Ins, 'SOURce2:VOLT:OFFS?'));

WP.LIAESR_phase = LIAESR.ShowPhase();


WP.datetime = datestr(now);

if(~automatic)
    prompt = 'what is pump power (mA in TA): ';
    WP.pump_power_mA = input(prompt, 's');
    prompt = 'what is prob power (mW before cell): ';
    WP.prob_power_mW = input(prompt, 's');
    prompt = 'what is temp read (Ohm): ';
    WP.Temp_Ohm = input(prompt, 's');
    prompt = 'type general info about the meas: ';
    WP.info = input(prompt, 's');
end
