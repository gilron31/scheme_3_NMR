function [ t_filt, v_filt ] = apply_lorentzian_filt( t, v, Gamma_hz, f_cent, dc_gain)
%GET_BPF Summary of this function goes here
%   Detailed explanation goes here

    if ~exist('f_cent')
        f_cent = 0;
    end

    if ~exist('dc_gain')
        dc_gain = 1;
    end

    filt = @(f) dc_gain * ( 0.5 ./ (1 + ((f - f_cent)/Gamma_hz).^2) + 0.5) ./ (1 + ((f + f_cent)/Gamma_hz).^2);
   [t_filt, v_filt] = apply_filter(t, v, filt);
end

