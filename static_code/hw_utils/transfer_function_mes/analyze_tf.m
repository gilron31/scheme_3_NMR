function [ output_args ] = analyze_tf( exp_data )
%ANALYZE_TG Summary of this function goes here
%   Detailed explanation goes here

    fspan = exp_data.exp_data_x.fspan;

    ref_param_x = [exp_data.exp_data_x.iterations.ref_param];
    ref_param_y = [exp_data.exp_data_y.iterations.ref_param];

    rel_fast_param_x = [exp_data.exp_data_x.iterations.fast_param]./ref_param_x;
    rel_fast_param_y = [exp_data.exp_data_y.iterations.fast_param]./ref_param_y;
    rel_slow_x_param_x = [exp_data.exp_data_x.iterations.slow_x_param]./ref_param_x;
    rel_slow_x_param_y = [exp_data.exp_data_y.iterations.slow_x_param]./ref_param_y;
    rel_slow_y_param_x = [exp_data.exp_data_x.iterations.slow_y_param]./ref_param_x;
    rel_slow_y_param_y = [exp_data.exp_data_y.iterations.slow_y_param]./ref_param_y;

%     figure; plot(fspan, real(rel_slow_x_param_x), fspan, imag(rel_slow_x_param_x), fspan, abs(rel_slow_x_param_x));
%    hold on; plot(fspan, real(rel_slow_y_param_x), fspan, imag(rel_slow_y_param_x), fspan, abs(rel_slow_y_param_x));
    figure; plot(fspan, abs(rel_slow_x_param_x));
   hold on; plot(fspan, abs(rel_slow_y_param_x));
   hold on; plot(fspan, abs(rel_fast_param_x));
   figure; plot(fspan, abs(rel_slow_x_param_y));
   hold on; plot(fspan, abs(rel_slow_y_param_y));
   hold on; plot(fspan, abs(rel_fast_param_y));


end

