function [ exp_data ] = single_tf_no_fastLIA(ag, sc, ch_main, ch_sec, ch_fast_ref, ch_calib_ref, fspan, amppp, approx_fast_ref)
%MES_SINGLE_TF Summary of this function goes here
%   Detailed explanation goes here

    CH_AG_SIG = 2;
    BUILD_TIME_S = 1;
    [stt, wfrm] = ag.Output(CH_AG_SIG, 1, true); 
    SLOW_LIA_TC = 5e-2;
    ag_dc = wfrm{1}.p(3);
    

    exp_data.iterations = [];
    exp_data.fspan = fspan;
    exp_data.amppp = amppp;
    
    for f = fspan
        display(sprintf('Acquiring tf at frequency: %d', f))
        t_mes = 10/f;
        sc.setTscale(t_mes / 10);
        ag.Sin(CH_AG_SIG, f, amppp, 0.0, ag_dc);
        pause(BUILD_TIME_S);
%         sc.Single();
%         sc.readyToRead(2*t_mes + 1);
%         [t, v_main] = sc.Read(ch_main);
%         [t, v_sec] = sc.Read(ch_sec);
%         [t, v_fast_ref] = sc.Read(ch_fast_ref);
%         [t, v_calib_ref] = sc.Read(ch_calib_ref);
%         
        res = acquire_high_res_nofastLIA(sc, t_mes);
        iter_data.f = f;
        iter_data.t = res.t;
        iter_data.v_main = res.v_main;
        iter_data.v_sec = res.v_sec;
        iter_data.v_fast_ref = res.v_fast_ref;
        iter_data.v_calib_ref = res.v_calib_ref;
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

        
        %%
        
        
        
        
        iter_data.main_sin_param = get_sine_parameters(t, v_sin_main, f);
        iter_data.main_cos_param = get_sine_parameters(t, v_cos_main, f);
        iter_data.sec_sin_param = get_sine_parameters(t, v_sin_sec, f);
        iter_data.sec_cos_param = get_sine_parameters(t, v_cos_sec, f);
        iter_data.main_dc_param = get_sine_parameters(t, res.v_main, f);
        iter_data.sec_dc_param = get_sine_parameters(t, res.v_sec, f);
        iter_data.ref_param = get_sine_parameters(t, res.v_calib_ref, f);
        
        exp_data.iterations = [exp_data.iterations, iter_data];
   
    end


end

