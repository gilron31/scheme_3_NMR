%% this file should be the start of every work process.
% it has all the necessary parts and should bring you from
% opening matlab to measuring dark matter in a matter of a few F9 key
% presses. 

instr = connect_to_instruments();
constants_define;

%TODO 
check_diode_saturation;
calibrate_magnetic_coils;

%% now you can run these cute scripts:
%measure the alkali sensitivity to transevers signals
mag_setup_scratchpad3;

%measure the whole transfer function of the Xenon to transverse signal!
advanced_tf_scratchpad;

