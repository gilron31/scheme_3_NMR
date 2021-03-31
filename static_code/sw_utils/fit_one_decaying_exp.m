function [ f, G2Xe,  A,logAXT2] = fit_one_decaying_exp(t,v,f_estim,G2estim,filter ,nfig)
    
    
    Ng = 8;
    ftdecaying_exp = fittype('a*exp(-x*b)*sin(2*pi*x*c + d)');
    
    [f,sf] = getFFT(t,v,0);
    relevant_fs_po = f<f_estim + Ng*G2estim &  f>f_estim - Ng*G2estim;
    f1 = f(relevant_fs_po);
    sf1 = sf(relevant_fs_po);
%     figure(134); plot(f, abs(sf),f(relevant_fs_po), abs(sf(relevant_fs_po)));
    [~ , maxind] = max(abs(sf1));
    fmax = f1(maxind);
    
    if(filter)
    [~, iv] = apply_lorentzian_filt(t, v, Ng*G2estim, fmax, 2);
    iv = real(iv);
    else
    iv = v - mean(v);
    end
    
    start_guess = [max(iv), G2estim, fmax, 0 ];
    lower = [0.9*max(iv), 0.2*G2estim, 0.99*fmax, -pi ];
    upper = [1.1*max(iv), 5*G2estim, 1.01*fmax, pi ];
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
    logAXT2.A = ff.a;
    logAXT2.G2Xe = ff.b;
    logAXT2.f = ff.c;
    logAXT2.ff = ff;
end

