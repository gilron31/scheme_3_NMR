function [ t_filt, v_filt ] = apply_BPF( t, v, fmin, fmax )
%GET_BPF Summary of this function goes here
%   Detailed explanation goes here

    filt = @(f) abs(f) >= fmin & abs(f) <= fmax;
   [t_filt, v_filt] = apply_filter(t, v, filt);
end

