function [  ] = analyze_autotune( exp_data , nfig)
%ANALYZE_AUTOTUNE Summary of this function goes here
%   Detailed explanation goes here

    
%%    
    N_iter = length(exp_data.iter_datas);
    
    scores = [];
    main_x = [];
    main_y = [];
    sec_x = [];
    sec_y = [];
    best_F = [];
    best_A = [];
    for i = 1:length(exp_data.iter_datas)
        [val, ind] = max(exp_data.iter_datas(i).f_scores);
        chosen_f_exp_data = exp_data.iter_datas(i).f_exp_datas(ind);
        
        scores = [scores, val];
        main_x = [main_x, chosen_f_exp_data.main_sens_vec(1)];
        main_y = [main_y, chosen_f_exp_data.main_sens_vec(2)];
        sec_x = [sec_x, chosen_f_exp_data.sec_sens_vec(1)];
        sec_y = [sec_y, chosen_f_exp_data.sec_sens_vec(2)];
        [val, ind] = max(exp_data.iter_datas(i).A_scores);
        chosen_A_exp_data = exp_data.iter_datas(i).A_exp_datas(ind);
        
        scores = [scores, val];
        main_x = [main_x, chosen_A_exp_data.main_sens_vec(1)];
        main_y = [main_y, chosen_A_exp_data.main_sens_vec(2)];
        sec_x = [sec_x, chosen_A_exp_data.sec_sens_vec(1)];
        sec_y = [sec_y, chosen_A_exp_data.sec_sens_vec(2)];
    end
    %%
    Ns = 1:2*N_iter;
    figure(nfig);
    subplot(3,1,1)
    plot(Ns, scores);
    subplot(3,1,2)
    plot(Ns, main_x, Ns, main_y)
    subplot(3,1,3)
    plot(Ns, sec_x, Ns, sec_y)
    figure(nfig + 1)
    subplot(2,1,1)
    plot(1:N_iter, [exp_data.iter_datas.chosen_best_A]);
    subplot(2,1,2)
    plot(1:N_iter, [exp_data.iter_datas.chosen_best_F]);
end

