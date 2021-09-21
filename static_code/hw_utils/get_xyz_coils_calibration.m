function [ calibration_params ] = get_xyz_coils_calibration( instr, constants )
%GET_XYZ_COILS_CALIBRATION Summary of this function goes here
%   Detailed explanation goes here

    %% TODO - do actual measurements instead of this artificial data. 
    %%
    %BZ calibration using fx with ampp 50mvpp 
    V_z_dc = [0.1, 0.4, 0.5, 1.0, 3.0];
    f_x_res_KHz = [2.300, 19.3, 23.3,48.3,150.3];
    amp_pp_rs_to_50mvpp_ch2 = [4.14, 2.07, 1.93, 1.56, 1.27];
    %by and bx showd discrepency of ~13/9 in power in favor of by
    B_z_inferred_G = f_x_res_KHz * 1000 *(2*pi) / constants.gRb85;
    fit_params = polyfit(V_z_dc, B_z_inferred_G, 1);
    G_2_V_z = fit_params(1);

    %Bx calubration using xenon FID
    V_x_dc = [1.0, 2.0, 3.0, 4.0];
    f_129 = [9.1, 18.3, 27.3, 36.3];
    f_131 = [2.7, 5.4, 8.1, 10.8];
    B_x_inffered_G = f_129 * 2 * pi / abs(constants.g129);
    fit_params = polyfit(V_x_dc, B_x_inffered_G, 1);
    G_2_V_x = fit_params(1);

    %By calubration using xenon FID
    V_y_dc = [1.0, 2.0, 3.0, 4.0];
    f_129 = [9.5, 19.1, 28.6, 38.0];
    f_131 = [2.9,5.7, 8.6, 11.3];
    B_y_inffered_G = f_129 * 2 * pi / abs(constants.g129);
    fit_params = polyfit(V_y_dc, B_y_inffered_G, 1);
    G_2_V_y = fit_params(1);
    
    calibration_params.G_2_V_x = G_2_V_x;
    calibration_params.G_2_V_y = G_2_V_y;
    calibration_params.G_2_V_z = G_2_V_z;
    calibration_params
end

