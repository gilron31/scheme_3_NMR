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
master_instr.AG2 = AG33500B('0x2307::MY50002059','USB'); fopen(master_instr.AG2.Ins);
master_instr.AG3 = AG33500B('192.168.1.15','tcpip'); fopen(master_instr.AG3.Ins);
master_instr.AG5 = AG33500B('192.168.1.18','tcpip');fopen(master_instr.AG5.Ins);
% master_instr.AG1 = AG33500B('192.168.1.15','tcpip'); fopen(master_instr.AG1.Ins);
% master_instr.AG2 = AG33500B('0x2307::MY50002059','USB'); fopen(master_instr.AG2.Ins);
% master_instr.AG3 = AG33500B('192.168.1.17','tcpip'); fopen(master_instr.AG3.Ins);
% master_instr.AG5 = AG33500B('192.168.1.18','tcpip');fopen(master_instr.AG5.Ins);

[master_instr.AG1.IDN, master_instr.AG2.IDN, master_instr.AG5.IDN, master_instr.AG3.IDN]
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


end

