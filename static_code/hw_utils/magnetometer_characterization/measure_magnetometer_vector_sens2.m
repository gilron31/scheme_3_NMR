function [ exp_data , raw_data] = measure_magnetometer_vector_sens2( agx, agy, sc, ch_ref, ch_main, ch_sec, nfig,instr, F_SIM_X, F_SIM_Y )
%MEASURE_MAGNETOMETER_VECTOR_SENS Summary of this function goes here
%   Detailed explanation goes here
   %% Software stuff
    DRIVE_AMP_Vpp = 2e-3; 
    if ~exist('F_SIM_X')
        F_SIM_X = 231;
    end
    if ~exist('F_SIM_Y')
        F_SIM_Y = 341;
    end
    T_MES = 1.0;
    CH_AG_SIG = 2;
    
    if ~exist('nfig')
       nfig = 0; 
    end
    
    %% input signals setup
    [stt, wfrm] = agx.Output(CH_AG_SIG, 1, true); 
    agx_dc = wfrm{1}.p(3);
    [stt, wfrm] = agy.Output(CH_AG_SIG, 1, true); 
    agy_dc = wfrm{1}.p(3);
    agx.DC(CH_AG_SIG, agx_dc);
    agy.DC(CH_AG_SIG, agy_dc);    

    %% Acquire
    fprintf(sc.Ins,':CHAN1:DISP 1')
    fprintf(sc.Ins,':CHAN2:DISP 1')
    fprintf(sc.Ins,':CHAN3:DISP 1')
    fprintf(sc.Ins,':CHAN4:DISP 1')
    sc.setChCoupling(1, 'AC')
    sc.setChCoupling(2, 'AC')
    sc.setChCoupling(3, 'AC')
    sc.setChCoupling(4, 'AC')
    sc.setVscale(1, 10e-3);
    sc.setVscale(2, 10e-3);
    sc.setVscale(3, 10e-3);
    sc.setVscale(4, 10e-3);
    sc.setTscale(T_MES / 10);

    %% Acquire x
    switch_ref_measurement(instr.AG1, 'x')
    agx.Sin(CH_AG_SIG, F_SIM_X, DRIVE_AMP_Vpp, 0.0, agx_dc);
    sc.Single();
    sc.readyToRead(2*T_MES + 1);
    [t, v_ref_x] = sc.Read(ch_ref);
    [t, v_main_x] = sc.Read(ch_main);
    [t, v_sec_x] = sc.Read(ch_sec);
    agx.DC(CH_AG_SIG, agx_dc);
    
    %% Acquire y
    switch_ref_measurement(instr.AG1, 'y')
    agy.Sin(CH_AG_SIG, F_SIM_Y, DRIVE_AMP_Vpp, 0.0, agy_dc);
    sc.Single();
    sc.readyToRead(2*T_MES + 1);
    [t, v_ref_y] = sc.Read(ch_ref);
    [t, v_main_y] = sc.Read(ch_main);
    [t, v_sec_y] = sc.Read(ch_sec);
    agy.DC(CH_AG_SIG, agy_dc);
    %% Analyze acquisitions
    ref_x_temp = get_sine_parameters(t, v_ref_x, F_SIM_X);
    ref_x_phase = ref_x_temp / abs(ref_x_temp);
    main_res_to_x_raw = get_sine_parameters(t, v_main_x, F_SIM_X) / ref_x_phase;
    sec_res_to_x_raw = get_sine_parameters(t, v_sec_x, F_SIM_X) / ref_x_phase;
    
    ref_y_temp = get_sine_parameters(t, v_ref_y, F_SIM_Y);
    ref_y_phase = ref_y_temp / abs(ref_y_temp);
    main_res_to_y_raw = get_sine_parameters(t, v_main_y, F_SIM_Y) / ref_y_phase;
    sec_res_to_y_raw = get_sine_parameters(t, v_sec_y, F_SIM_Y) / ref_y_phase;
    %%%should add assertion if imaginary part is too big.
    
    tan(angle([main_res_to_x_raw, sec_res_to_x_raw, main_res_to_y_raw, sec_res_to_y_raw]))
    main_sens_vec = [real(main_res_to_x_raw), real(main_res_to_y_raw)] ;
    sec_sens_vec = [real(sec_res_to_x_raw), real(sec_res_to_y_raw)] ;
    
    %%
    if (nfig)
        figure(nfig); plot([0,main_sens_vec(1)], [0,main_sens_vec(2)], '-x');
        hold on;
        plot([0,sec_sens_vec(1)], [0,sec_sens_vec(2)], '-x');
        legend('main', 'sec')
        grid on;
        axis image
    end
    %% Finishing sequence HW
    agx.DC(CH_AG_SIG, agx_dc);
    agy.DC(CH_AG_SIG, agy_dc);
    
    %% Finishing sequence SW
    exp_data.DRIVE_AMP_Vpp = DRIVE_AMP_Vpp; 
    exp_data.F_SIM_X = F_SIM_X; 
    exp_data.F_SIM_Y = F_SIM_Y; 
    exp_data.T_MES = T_MES; 
    raw_data.t = t;
    raw_data.v_ref_x = v_ref_x;
    raw_data.v_ref_y = v_ref_y;
    raw_data.v_main = v_main_x;
    raw_data.v_sec = v_sec_x;
    raw_data.v_main = v_main_y;
    raw_data.v_sec = v_sec_y;
    
%     exp_data.raw_data = raw_data;
    exp_data.main_sens_vec = main_sens_vec; 
    exp_data.sec_sens_vec = sec_sens_vec; 

end

