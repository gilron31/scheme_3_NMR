function [] = switch_ref_measurement( agswitch , coil)
%SWITCH_REF_MEASUREMENT Summary of this function goes here
%   Detailed explanation goes here

    CH_SWITCH = 1;
    V_DC_x = 0;
    V_DC_y = 5;
    if (coil =='x')
        agswitch.DC(CH_SWITCH, V_DC_x);
        agswitch.OutputON(CH_SWITCH);
    else if (coil =='y')
        agswitch.DC(CH_SWITCH, V_DC_y);
        agswitch.OutputON(CH_SWITCH);
    else
        display('switch_ref_measurement usage: coil = ''x'' or coil = ''y''')
    end

end

