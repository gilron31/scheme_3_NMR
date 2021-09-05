function [ exp_data ] = single_tf_no_fastLIA(ag, sc, ch_main, ch_sec, ch_fast_ref, ch_calib_ref,T_MES, amppp, approx_fast_ref)
%MES_SINGLE_TF Summary of this function goes here
%   Detailed explanation goes here

    CH_AG_SIG = 2;
    BUILD_TIME_S = 1;
    [stt, wfrm] = ag.Output(CH_AG_SIG, 1, true); 
    SLOW_LIA_TC = 5e-2;
    ag_dc = wfrm{1}.p(3);
    WN_BW_Hz = 20;

    exp_data.iterations = [];
    exp_data.WN_BW_Hz = WN_BW_Hz;
    exp_data.amppp = amppp;
    
    
    display(sprintf('Acquiring tf with white noise'))
    sc.setTscale(T_MES / 10);
    
    % apply white noise with AG
    ag.WhiteNoise(CH_AG_SIG, WN_BW_Hz, amppp, ag_dc);
    res = acquire_high_res_nofastLIA(sc, T_MES);
    exp_data.t = res.t;
    exp_data.v_main = res.v_main;
    exp_data.v_sec = res.v_sec;
    exp_data.v_fast_ref = res.v_fast_ref;
    exp_data.v_calib_ref = res.v_calib_ref;
    t = res.t;


    %%
    DRIVE_FREQ = 1.0;
    DRIVE_AMP_V = 2e-3/2;
    BX_COIL_G_2_V = 0.008;
     


    approx = get_sine_parameters(t, res.v_fast_ref, approx_fast_ref);
    sine_const = @(p,t) p(1)*sin(2*pi*p(2).*t + p(3)) + p(4); 
    p0 =  [abs(approx),approx_fast_ref,angle(approx), 0];
    params = fminsearch(@(p) sum(abs( res.v_fast_ref - sine_const(p,t) ).^2),p0);
    f_ref = params(2);
    phi_ref = params(3);

    [v_sin_main, v_cos_main] = LIA_simulator(t, res.v_main, f_ref, phi_ref, SLOW_LIA_TC);
    [v_sin_sec, v_cos_sec] = LIA_simulator(t, res.v_sec, f_ref, phi_ref, SLOW_LIA_TC);

    
    exp_data.v_sin_main = v_sin_main;
    exp_data.v_cos_main = v_cos_main;
    exp_data.v_sin_sec = v_sin_sec;
    exp_data.v_cos_sec = v_cos_sec;
          
end

