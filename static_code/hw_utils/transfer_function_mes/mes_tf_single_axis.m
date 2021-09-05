function [ exp_data ] = mes_tf_single_axis(ag, sc, ch_slow_x, ch_slow_y, ch_fast, ch_ref, fspan, amppp)
%MES_SINGLE_TF Summary of this function goes here
%   Detailed explanation goes here

    CH_AG_SIG = 2;
    BUILD_TIME_S = 1;
    [stt, wfrm] = ag.Output(CH_AG_SIG, 1, true); 
    ag_dc = wfrm{1}.p(3);

    exp_data.iterations = [];
    exp_data.fspan = fspan;
    exp_data.amppp = amppp;
    
    for f = fspan
        
        t_mes = 10/f;
        sc.setTscale(t_mes / 10);
        ag.Sin(CH_AG_SIG, f, amppp, 0.0, ag_dc);
        pause(BUILD_TIME_S);
        sc.Single();
        sc.readyToRead(2*t_mes + 1);
        [t, v_slow_x] = sc.Read(ch_slow_x);
        [t, v_slow_y] = sc.Read(ch_slow_y);
        [t, v_fast] = sc.Read(ch_fast);
        [t, v_ref] = sc.Read(ch_ref);
        
        iter_data.f = f;
        iter_data.t = t;
        iter_data.v_slow_x = v_slow_x;
        iter_data.v_slow_y = v_slow_y;
        iter_data.v_fast = v_fast;
        iter_data.v_ref = v_ref;
        
        iter_data.slow_x_param = get_sine_parameters(t, v_slow_x, f);
        iter_data.slow_y_param = get_sine_parameters(t, v_slow_y, f);
        iter_data.fast_param = get_sine_parameters(t, v_fast, f);
        iter_data.ref_param = get_sine_parameters(t, v_ref, f);
        
        exp_data.iterations = [exp_data.iterations, iter_data];
   
    end


end

