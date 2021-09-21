function [ master_instr ] = connect_to_instruments()
instrreset; % close all
%% initialization

addpath('E:\NMRGGil\scheme_3_home\static_code\hw_utils\instruments');

% [unt,P,c] = units_consts;

%% connecting to the instruments
%%
% master_instr.LIA2 = SR844(5,0); fopen(master_instr.LIA2.Ins);
% master_instr.LIAESR = SR844(6,0); fopen(master_instr.LIAESR.Ins);
% [master_instr.LIA2.IDN,master_instr.LIAESR.IDN]
%%
master_instr.AG1 = AG33500B('192.168.1.17','tcpip'); fopen(master_instr.AG1.Ins);
% master_instr.AG2 = AG33500B('0x2307::MY50002059','USB'); fopen(master_instr.AG2.Ins);
master_instr.AG3 = AG33500B('192.168.1.15','tcpip'); fopen(master_instr.AG3.Ins);
master_instr.AG5 = AG33500B('192.168.1.18','tcpip');fopen(master_instr.AG5.Ins);
% master_instr.AG1 = AG33500B('192.168.1.15','tcpip'); fopen(master_instr.AG1.Ins);
% master_instr.AG2 = AG33500B('0x2307::MY50002059','USB'); fopen(master_instr.AG2.Ins);
% master_instr.AG3 = AG33500B('192.168.1.17','tcpip'); fopen(master_instr.AG3.Ins);
% master_instr.AG5 = AG33500B('192.168.1.18','tcpip');fopen(master_instr.AG5.Ins);

% [master_instr.AG1.IDN, master_instr.AG2.IDN, master_instr.AG5.IDN, master_instr.AG3.IDN]
%%
try
master_instr.Tabor1 = WW1071('192.168.1.110'); pause(1); fopen(master_instr.Tabor1.Ins); %Tabor1.setSingleTrigOut;
catch E
master_instr.Tabor1 = WW1071('192.168.1.110'); pause(1); fopen(master_instr.Tabor1.Ins); %Tabor1.setSingleTrigOut;
display('2nd tabor1 attempt');
end
master_instr.Tabor1.IDN

%%
master_instr.BB = B2962A('192.168.1.121');
[master_instr.BB.IDN]
%%
master_instr.scope1 = DSOX3000('0x0957::0x17A6::MY52492279'); fopen(master_instr.scope1.Ins);
master_instr.scope2 = DSOX3000('0x2A8D::0x1764::MY58262742'); fopen(master_instr.scope2.Ins);
master_instr.scope3 = DSOX3000('0x0957::0x17A6::MY52492273'); fopen(master_instr.scope3.Ins);
[master_instr.scope1.IDN, master_instr.scope2.IDN, master_instr.scope3.IDN]

%% BPD interface
progID = 'MGMOTOR.MGMotorCtrl.1';
SNPr = 83858614;
ProbeFigure=figure(SNPr);
FigPos=get(0,'DefaultFigurePosition');
FigPos(3)=650;
FigPos(4)=450;
set(ProbeFigure,'Name','APT GUI Probe')
set(ProbeFigure,'Menu','None')
set(ProbeFigure,'Position',FigPos);
master_instr.h_xPr = actxcontrol(progID,[20 20 600 400],ProbeFigure);
master_instr.h_xPr.StartCtrl;
set(master_instr.h_xPr,'HWSerialNum',SNPr);
master_instr.h_xPr.Identify;

master_instr.h_xPr.SetJogStepSize(0.00, 0.02);

%% doing channel based wiring
%xyz coils
master_instr.Bx.device = master_instr.AG5;
master_instr.Bx.ch = 2;
master_instr.By.device = master_instr.AG1;
master_instr.By.ch = 2;
master_instr.Bz.device = master_instr.AG3;
master_instr.Bz.ch = 2;

master_instr.switch_ref.device = master_instr.AG1;
master_instr.switch_ref.ch = 1;
master_instr.sync_scopes.device = master_instr.AG5;
master_instr.sync_scopes.ch = 1;

%commented because AG2 has a bug, UNCOMMENT when AG2 is back to normal
% master_instr.pump_detuning.device = master_instr.AG2;
% master_instr.pump_detuming.ch = 1;
% master_instr.probe_detuning.device = master_instr.AG2;
% master_instr.probe_detuming.ch = 2;

master_instr.slow_mod_ref.device = master_instr.scope2;
master_instr.slow_mod_ref.ch = 1;
master_instr.main_LIA.device = master_instr.scope2;
master_instr.main_LIA.ch = 2;
master_instr.secondary_LIA.device = master_instr.scope2;
master_instr.secondary_LIA.ch = 3;
master_instr.transverse_magnetic_ref.device = master_instr.scope2;
master_instr.transverse_magnetic_ref.ch = 4;

master_instr.bpd_210A_rf.device = master_instr.scope1;
master_instr.bpd_210A_rf.ch = 1;
master_instr.bpd_440_minus.device = master_instr.scope1;
master_instr.bpd_440_minus.ch = 2;
master_instr.bpd_440_rf.device = master_instr.scope1;
master_instr.bpd_440_rf.ch = 3;
master_instr.pump_power_indicator.device = master_instr.scope1;
master_instr.pump_power_indicator.ch = 4;


end

