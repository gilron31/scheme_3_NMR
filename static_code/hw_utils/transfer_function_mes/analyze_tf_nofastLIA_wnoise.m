function [  ] = analyze_tf_nofastLIA_wnoise( exp_data_dir )
%ANALYZE_TG Summary of this function goes here
%   Detailed explanation goes here
    BW = exp_data_dir.WN_BW_Hz;

    t = exp_data_dir.t;
    calib_ref = exp_data_dir.v_calib_ref;
    v_sin_main = exp_data_dir.v_sin_main;
    v_cos_main = exp_data_dir.v_cos_main;
    v_sin_sec = exp_data_dir.v_sin_sec;
    v_cos_sec = exp_data_dir.v_cos_sec;
    
    DC_CALC = 1;
    [f, sf_calib] = getFFT(t, calib_ref - DC_CALC * mean(calib_ref));
    [f, sf_sin_main] = getFFT(t, v_sin_main - DC_CALC * mean(v_sin_main));
    [f, sf_cos_main] = getFFT(t, v_cos_main - DC_CALC * mean(v_cos_main));
    [f, sf_sin_sec] = getFFT(t, v_sin_sec - DC_CALC * mean(v_sin_sec));
    [f, sf_cos_sec] = getFFT(t, v_cos_sec - DC_CALC * mean(v_cos_sec));
    
    BW = 4;
    FILT_PARAM = 10;
    figure; plot(f, medfilt1(abs(sf_calib), FILT_PARAM)); xlim([-2 * BW, 2*BW])
    figure; plot(f, smooth(real(sf_sin_main./sf_calib), FILT_PARAM), f, smooth(imag(sf_sin_main./sf_calib), FILT_PARAM)); xlim([-2 * BW, 2*BW])
    figure; plot(f, smooth(real(sf_sin_sec./sf_calib), FILT_PARAM), f, smooth(imag(sf_sin_sec./sf_calib), FILT_PARAM)); xlim([-2 * BW, 2*BW])

    f_avg_min = 7;
    f_avg_max = 8;
    main_sin_rel = sf_sin_main./sf_calib;
    offset_main_sin = mean(main_sin_rel(f < f_avg_max & f > f_avg_min));
    main_cos_rel = sf_cos_main./sf_calib;
    offset_main_cos = mean(main_cos_rel(f < f_avg_max & f > f_avg_min));
    
    main_sin_sub = main_sin_rel - offset_main_sin;
    main_cos_sub = main_cos_rel - offset_main_cos;
    
    figure; plot(f, smooth(abs(main_cos_sub), FILT_PARAM), f, smooth(abs(main_sin_sub), FILT_PARAM));xlim([-2 * BW, 2*BW])
    %     figure; plot(f, smooth(real(sf_cos_main./sf_calib), FILT_PARAM)); xlim([-2 * BW, 2*BW])
%     figure; plot(f, smooth(real(sf_sin_sec./sf_calib), FILT_PARAM)); xlim([-2 * BW, 2*BW])
%     figure; plot(f, smooth(real(sf_cos_sec./sf_calib), FILT_PARAM)); xlim([-2 * BW, 2*BW]);
%     figure; plot(f, smooth(abs(sf_sin_main), 1)); xlim([-2 * BW, 2*BW])
%     figure; plot(f, smooth(abs(sf_cos_main), 1)); xlim([-2 * BW, 2*BW])
%     figure; plot(f, smooth(abs(sf_sin_sec), 1)); xlim([-2 * BW, 2*BW])
%     figure; plot(f, smooth(abs(sf_cos_sec), 1)); xlim([-2 * BW, 2*BW])
    
end

