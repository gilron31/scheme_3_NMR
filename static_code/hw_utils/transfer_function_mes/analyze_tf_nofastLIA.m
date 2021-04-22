function [  ] = analyze_tf_nofastLIA( exp_data )
%ANALYZE_TG Summary of this function goes here
%   Detailed explanation goes here

    fspan = exp_data.fspan;

    ref_param = [exp_data.iterations.ref_param];

    rel_main_dc = [exp_data.iterations.main_dc_param]./ref_param;
    rel_main_sin = [exp_data.iterations.main_sin_param]./ref_param;
    rel_main_cos = [exp_data.iterations.main_cos_param]./ref_param;
    rel_sec_dc = [exp_data.iterations.sec_dc_param]./ref_param;
    rel_sec_sin = [exp_data.iterations.sec_sin_param]./ref_param;
    rel_sec_cos = [exp_data.iterations.sec_cos_param]./ref_param;

    
    rel_main_dc_sub = rel_main_dc - rel_main_dc(end);
    rel_main_sin_sub = rel_main_sin - rel_main_sin(end);
    rel_main_cos_sub = rel_main_cos - rel_main_cos(end);
    rel_sec_dc_sub = rel_sec_dc - rel_sec_dc(end);
    rel_sec_sin_sub = rel_sec_sin - rel_sec_sin(end);
    rel_sec_cos_sub = rel_sec_cos - rel_sec_cos(end);
   
   figure; plot(fspan, abs(rel_main_cos_sub), '-o');
   hold on; plot(fspan, abs(rel_main_sin_sub), '-o');
%    hold on; plot(fspan, abs(rel_main_dc_sub));
%        figure; plot(fspan, abs(rel_sec_cos_sub));
%    hold on; plot(fspan, abs(rel_sec_sin_sub));
%    hold on; plot(fspan, abs(rel_sec_dc_sub));
% % 
   figure; plot(fspan, real(rel_main_cos), '-o', fspan, imag(rel_main_cos), '-o');
   hold on;plot(fspan, real(rel_main_sin), '-o', fspan, imag(rel_main_sin), '-o');
%    hold on; plot(fspan, real(rel_main_dc), fspan, imag(rel_main_dc));

%       figure; plot(fspan, abs(rel_sec_cos));
%    hold on; plot(fspan, abs(rel_sec_sin));
%    hold on; plot(fspan, abs(rel_sec_dc));
end

