function [ sig, fs, amppp, ts , sig_func] = arb_floquet_input(offset, beta_fast, f_fast, beta_slow, f_slow, adjust_slow_phase, adjust_slow_amp, freq_div_2_moddepth)
%GENERATE_ARB Summary of this function goes here
%   Detailed explanation goes here
    
    if ~exist('adjust_slow_phase')
        adjust_slow_phase = 0; %This is an input parameter meant to make sure that the start phase and the end
        %phase are not too far apart.
    end
    if ~exist('adjust_slow_amp')
        adjust_slow_amp = 0; %This is an input parameter meant to make sure that the start phase and the end
        %phase are not too far apart.
    end

    MAX_N_SAMPLE = 6e4;
    N_CYCLE = 1;
    T_cycle = N_CYCLE/f_slow;
    ts = linspace(0, T_cycle, MAX_N_SAMPLE);
    f_fast = f_fast;
    
    
%     inst_freq = f_fast * (1 + beta_slow * sin(2*pi*ts*f_slow));
    inst_phase = @(t) 2 * pi .* mod(t, T_cycle)  * f_fast - f_fast * beta_slow * 1/(f_slow) .* cos(2*pi*mod(t, T_cycle)*f_slow);
    init_phase = - f_fast * beta_slow * 1/(f_slow);
    final_phase = 2 * pi .* T_cycle * f_fast - f_fast * beta_slow * 1/(f_slow) .* cos(2*pi*T_cycle*f_slow);
    
    phase_diff = mod(final_phase - init_phase , 2 * pi)
    
    sig_func = @(t) (adjust_slow_amp + 1) * offset * (beta_slow .* sin(2*pi*mod(t, T_cycle)*f_slow + adjust_slow_phase)) + offset*beta_fast*sin(inst_phase(t)) .* (1 + beta_slow .* sin(2*pi*mod(t, T_cycle)*f_slow));
    fs = 1/(ts(2) - ts(1));
%     amppp = offset * beta_slow + offset * beta_fast * (1 + beta_slow) - offset *(-  beta_slow - beta_fast * (1 - beta_slow) );
    amppp = offset * beta_slow * 2 + offset * beta_fast * 2;
    sig = sig_func(ts);
end


