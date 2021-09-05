function [logAXT2] = fit_two_decaying_exp(t,v,f_estim,G2estim,bigger_to_smaller_f_ratio,filter ,nfig)
    
    
    Ng = 8;
    ftdecaying_exp = fittype('a*exp(-x*b)*sin(2*pi*x*c + d) + e*exp(-x*f)*sin(2*pi*x*g + h)');
    
    [f,sf] = getFFT(t,v,0);
    relevant_fs_po = f<f_estim + Ng*G2estim &  f>f_estim - Ng*G2estim;
    f1 = f(relevant_fs_po);
    sf1 = sf(relevant_fs_po);
%     figure(134); plot(f, abs(sf),f(relevant_fs_po), abs(sf(relevant_fs_po)));
    [~ , maxind] = max(abs(sf1));
    fmax = abs(f1(maxind));
    
    if(filter)
        [~, iv] = apply_lorentzian_filt(t, v, Ng*G2estim, fmax, 2);
        iv = real(iv);
    else
        npoin = length(v);
        iv = v - mean(v(end - floor(npoin/2):end));
    end
    
    f_smaller = 1/bigger_to_smaller_f_ratio*fmax;
    start_guess = [max(iv), G2estim, fmax, 0,0.5*max(iv), G2estim, f_smaller, 0  ];
    lower = [0.8*max(iv), 0.2*G2estim, 0.90*fmax, -pi ,0.5*0.5*max(iv), 0.2*G2estim, 0.90*f_smaller, -pi ];
    upper = [1.2*max(iv), 5*G2estim, 1.11*fmax, pi ,0.5*1.51*max(iv), 5*G2estim, 1.11*f_smaller, pi ];
    ff = fit(t',iv',ftdecaying_exp, 'Startpoint',start_guess,'Lower',lower , 'Upper',upper);
    A = ff.a;
    G2Xe = ff.b;
    f = ff.c;
    if (nfig)
        figure(nfig); plot(ff, t,iv);title(['A=' num2str(A) ' G2=' num2str(G2Xe) ' f=' num2str(f)]);
    end
    
    logAXT2.Ng = Ng;
    logAXT2.f_estim = f_estim;
    logAXT2.G2estim = G2estim;
    logAXT2.fmax = fmax;
    logAXT2.A_Stronger = ff.a;
    logAXT2.G2_Stronger = ff.b;
    logAXT2.f_Stronger = ff.c;
    logAXT2.A_weaker = ff.e;
    logAXT2.G2_weaker = ff.f;
    logAXT2.f_weaker = ff.g;
    logAXT2.ff = ff;
end

