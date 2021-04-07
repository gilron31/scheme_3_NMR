function [ sig, fs, amppp, ts ,sig_funcs] = arb_floquet_input2(slow_amp, slow_freq, fast_amp, fast_freq, FM_depth, AM_depth, N_CYCLE)
%GENERATE_ARB Summary of this function goes here
%   Detailed explanation goes here
    MAX_N_SAMPLE = 6e4;
    if ~exist('N_CYCLE')
        N_CYCLE = 1;
    end
    T_cycle = N_CYCLE/slow_freq;
    ts = linspace(0, T_cycle, MAX_N_SAMPLE);
    sig_funcs.slow_sig = @(t) slow_amp * sin(2*pi*slow_freq*t);
    sig_funcs.inst_freq = @(t) fast_freq * (1 + FM_depth * sin(2*pi*ts*slow_freq));
    sig_funcs.inst_phase = @(t) 2 * pi .* mod(t, T_cycle)  * fast_freq - fast_freq * FM_depth * 1/(slow_freq) .* cos(2*pi*mod(t, T_cycle)*slow_freq);
    sig_funcs.phase_diff = mod(sig_funcs.inst_phase(ts(end -1)) - sig_funcs.inst_phase(0), 2 * pi)
    sig_funcs.fast_sig = @(t) fast_amp *(1 + AM_depth * sin(2*pi*slow_freq*t)).* sin(sig_funcs.inst_phase(t));
    sig_funcs.sig_func = @(t) sig_funcs.slow_sig(t) + sig_funcs.fast_sig(t);
    fs = 1/(ts(2) - ts(1));
    amppp = 2 * slow_amp + 2 * fast_amp;
    sig = sig_funcs.sig_func(ts);
    
end


