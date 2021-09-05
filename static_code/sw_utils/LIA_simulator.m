function [ v_sin, v_cos ] = LIA_simulator( t, vsig, freq, phase, TC )
%LIA_SIMULATOR Summary of this function goes here
%   Detailed explanation goes here

    sin_ref = sin(2*pi*freq*t + phase);
    cos_ref = cos(2*pi*freq*t + phase);
    
    [~, v_sin] = apply_lorentzian_filt(t, vsig.*sin_ref, 1/TC);
    [~, v_cos] = apply_lorentzian_filt(t, vsig.*cos_ref, 1/TC);

    
end

