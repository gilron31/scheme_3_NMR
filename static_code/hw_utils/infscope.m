sc = instr.scope1;
ch = 1;

figure();
while(1)
    sc.Single()
%     sc.readyToRead()
%     'ready'
    pause(0.1)
    [t,v] = sc.Read(ch);
    plot(t,v)
    a = minmax(v);
    [f, s]  = getFFT(t,v,0);
    r = f>2/diff(minmax(t));
    [~, ind] = max(abs(s(r)));
    f = f(r);
    freq = f(ind);
    title(['min: ' num2str(a(1)) ' max: ' num2str(a(2)) ' freq: ' num2str(freq)])
    if(max(v)-min(v)==0)
        sc.setVscale(ch,1)
    else
        sc.setVscale(ch,(max(v)-min(v))/2)
    end
    sc.setVoffset(ch, (max(v)+min(v))/2)
end