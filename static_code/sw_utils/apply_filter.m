function [ t_filt, v_filt ] = apply_filter( t, v, filt )
%GET_BPF Summary of this function goes here
%   Detailed explanation goes here


% MAKE SURE FILTER IS HERMITIAN f(-w) = f*(w)
    [f, sf] = getFFT(t, v);
    sf_filt = sf .* filt(f);
    
    [t_filt, v_filt] = getIFFT(f, sf_filt);
    v_filt = real(v_filt);
    t_filt = t_filt + diff(minmax(t))/2;
end

