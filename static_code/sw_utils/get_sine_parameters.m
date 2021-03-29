function [ complex_amplitude ] = get_sine_parameters( t, v, freq )
%GET_SINE_PARAMETERS Summary of this function goes here
%   DOESNT MEASURE DC!!!!!!!!!!!!!!!
complex_amplitude = trapz( (t(2)-t(1)) *2*1i*exp(-1i*2*pi*freq* t ).*( v - mean( v )))/diff(minmax( t ));


end

