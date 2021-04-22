function [ output_args ] = save_exp_data( exp_data, name, metadata, folder_path)
%SAVE_EXP_DATA Summary of this function goes here
%   Detailed explanation goes here
if ~exist('folder_path')
    folder_path = '';
end

date_str = get_escaped_datetime();
clk = clock;
save([folder_path,name,'_',date_str, '.mat'], 'metadata',  'exp_data','clk')
end

