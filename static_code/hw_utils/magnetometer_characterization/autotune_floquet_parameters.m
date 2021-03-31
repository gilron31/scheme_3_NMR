function [ big_exp_data ] = autotune_floquet_parameters( agx, agy, agf, sc, ch_ref_x, ch_ref_y, ch_main, ch_sec, offset, init_f, init_Avpp, FOM )
    N_ITER = 4;
    F_STEP_FRAC = 30;
    A_STEP_FRAC = 30;
    F_N_STEPS = 5;
    A_N_STEPS = 5;
    CH_AGF = 1;
    big_exp_data.iter_datas = [];
    big_exp_data.N_ITER = N_ITER;
    %%
    best_A = init_Avpp;
    best_F = init_f;
    
    for n_inter = 1 : N_ITER
        %%
        f_span = init_f * F_N_STEPS / F_STEP_FRAC;
        f_range = linspace(best_F - f_span/2, best_F + f_span/2, F_N_STEPS);
        iter_data.f_range = f_range;
        f_scores = [];
        f_exp_datas = [];
        for curr_F = f_range
            agf.Sin(CH_AGF, curr_F, best_A, 0.0, offset);
            [exp_data, raw_data ]= measure_magnetometer_vector_sens(agx, agy, sc,  ch_ref_x, ch_ref_y, ch_main, ch_sec);
            f_exp_datas = [f_exp_datas, exp_data];
            current_score = FOM(exp_data.main_sens_vec, exp_data.sec_sens_vec);
            f_scores = [f_scores, current_score];
        end
        [val, ind] = max(f_scores);
        best_F = f_range(ind);
        iter_data.f_scores = f_scores;
        iter_data.f_exp_datas = f_exp_datas;
        iter_data.chosen_best_F = best_F;
        %%
        A_span = init_Avpp * A_N_STEPS / A_STEP_FRAC;
        A_range = linspace(best_A - A_span/2, best_A + A_span/2, A_N_STEPS);
        iter_data.A_range = A_range;
        A_scores = [];
        A_exp_datas = [];
        for curr_A = A_range
            agf.Sin(CH_AGF, best_F, curr_A, 0.0, offset);
            [exp_data, raw_data ]= measure_magnetometer_vector_sens(agx, agy, sc,  ch_ref_x, ch_ref_y, ch_main, ch_sec);
            A_exp_datas = [A_exp_datas, exp_data];
            current_score = FOM(exp_data.main_sens_vec, exp_data.sec_sens_vec);
            A_scores = [A_scores, current_score];
        end
        [val, ind] = max(A_scores);
        best_A = A_range(ind);
        iter_data.A_scores = A_scores;
        iter_data.A_exp_datas = A_exp_datas;
        iter_data.chosen_best_A = best_A;
        
        %%
        big_exp_data.iter_datas = [big_exp_data.iter_datas, iter_data];
        
    end
    big_exp_data.final_F = best_F;
    big_exp_data.final_A = best_A;
    agf.Sin(CH_AGF, best_F, best_A, 0.0, offset);

    
end

