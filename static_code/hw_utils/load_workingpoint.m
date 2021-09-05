if(~exist('WP'))
    display('No working point available')
else
    display('Loading Working point')
    display(['datetime=               ' WP.datetime])
    display(['Bx_DC_V=                ' num2str(WP.Bx_DC_V)])
    display(['By_DC_V=                ' num2str(WP.By_DC_V)])
    display(['BBcurrent=              ' num2str(WP.BBcurrent)])
    display(['BBVlim=                 ' num2str(WP.BBVlim)])
    display(['By_DC_V=                ' num2str(WP.By_DC_V)])
    display(['Floquet_fast_amp_V=     ' num2str(WP.Floquet_fast_amp_Vpp)])
    display(['FLoquet_fast_freq_hz=   ' num2str(WP.FLoquet_fast_freq_hz)])
    display(['prob_detune_V=          ' num2str(WP.prob_detune_V)])
    display(['pump_detune_V=          ' num2str(WP.pump_detune_V)])   
    display(['LIAESR_phase=           ' num2str(WP.LIAESR_phase)])   

    if(~WP.automatic)
        display(['prob_power_mW=          ' WP.prob_power_mW])
        display(['pump_power_mA=          ' WP.pump_power_mA])
        display(['Temp_Ohm=               ' WP.Temp_Ohm])
        display(['info=                   ' WP.info])
    end
    
end
%% Loading WP
AG3.Sin(2,WP.FLoquet_fast_freq_hz, WP.Floquet_fast_amp_Vpp,0,0);
AG1.DC(2,WP.By_DC_V);
AG5.DC(2,WP.Bx_DC_V);

BB.Current(1, WP.BBcurrent);
BB.VLim(WP.BBVlim, 1);

AG2.DC(1, WP.pump_detune_V);
AG2.DC(2, WP.prob_detune_V);

LIAESR.Change_Phase(WP.LIAESR_phase);
%% general scheme 2 setup

AG3.OutputON(2);
AG1.OutputON(2);
AG5.OutputON(2);
AG2.OutputON(1);
AG2.OutputON(2);
BB.OutputON(1);

AG1.DC(1, 5); AG1.OutputON(1); % Bz relay
