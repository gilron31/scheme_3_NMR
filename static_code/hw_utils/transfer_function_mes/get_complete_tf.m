function [ exp_data ] = get_complete_tf(instr,  fspan, amppp, optical_data, LIA_data, fold_path, notes)
% Summary of this function goes here
%   Detailed explanation goes here
    
    CH_SLOW_X = 1;
    CH_SLOW_Y = 2;
    CH_FAST = 3;
    CH_REF = 4;
    CH_AG_SIG = 2;
    PROMPT = 'Change_ref_from_x_to_y';
    %% init_sequence
    
    [stt, wfrm] = instr.AG5.Output(CH_AG_SIG, 1, true); 
    ag_x_dc = wfrm{1}.p(3);
    instr.AG5.DC(CH_AG_SIG, ag_x_dc);
    
    [stt, wfrm] = instr.AG1.Output(CH_AG_SIG, 1, true); 
    ag_y_dc = wfrm{1}.p(3);
    instr.AG1.DC(CH_AG_SIG, ag_y_dc);
    
    %%
   
    
    exp_data.exp_data_x = mes_tf_single_axis(instr.AG5, instr.scope2, CH_SLOW_X, CH_SLOW_Y, CH_FAST, CH_REF, fspan, amppp); 
    instr.AG5.DC(CH_AG_SIG, ag_x_dc);
    
    input(PROMPT);
    
    exp_data.exp_data_y = mes_tf_single_axis(instr.AG1, instr.scope2, CH_SLOW_X, CH_SLOW_Y, CH_FAST, CH_REF, fspan, amppp); 
    instr.AG1.DC(CH_AG_SIG, ag_y_dc);

    %%
    
    metadata.optical_data = optical_data;
    metadata.LIA_data = LIA_data;
    metadata.notes = notes;
    save_exp_data([exp_data, '.mat'], 'sch3TF', metadata, fold_path);
end

