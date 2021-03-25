instrreset; % close all
%% initialization
address = 'E:\Roy\V3\';
% addpath('C:\Users\user\Dropbox\lab instruments\');
addpath('E:\Dropbox\lab instruments\');

% addpath('E:\Roy\V3\utils\');
[unt,P,c] = units_consts;

%% connecting to the instruments
% LIA1 = SR830(1); fopen(LIA1.Ins);
LIA2 = SR844(5,0); fopen(LIA2.Ins);
LIAESR = SR844(6,0); fopen(LIAESR.Ins);
% LIAESR.IDN
% 
[LIA2.IDN,LIAESR.IDN]
% [LIA1.IDN,LIA2.IDN]

% AG1 = AG33500B('0x2C07::MY58000839','USB'); fopen(AG1.Ins);
% AG5 = AG33500B('0x2C07::MY57802471','USB'); fopen(AG5.Ins);
% AG4 = AG33500B('0x2307::MY50002080','USB'); fopen(AG4.Ins);
% AG2 = AG33500B('0x2307::MY50002059','USB'); fopen(AG2.Ins);

AG1 = AG33500B('192.168.1.15','tcpip'); fopen(AG1.Ins);
AG2 = AG33500B('0x2307::MY50002059','USB'); fopen(AG2.Ins);
AG3 = AG33500B('192.168.1.17','tcpip'); fopen(AG3.Ins);
AG4 = AG33500B('192.168.1.18','tcpip');AG5=AG4; fopen(AG4.Ins);
AGESR = AG3;
[AG1.IDN, AG2.IDN, AG5.IDN, AG3.IDN]
% AG6 = AG33500B('0x2C07::MY58000848','USB'); fopen(AG6.Ins);
% [AG6.IDN]
try
Tabor1 = WW1071('192.168.1.110'); pause(1); fopen(Tabor1.Ins); %Tabor1.setSingleTrigOut;
catch E
Tabor1 = WW1071('192.168.1.110'); pause(1); fopen(Tabor1.Ins); %Tabor1.setSingleTrigOut;
display('2nd tabor1 attempt');
end
Tabor1.IDN


% try 
% Tabor2 = WW1072('192.168.1.56'); pause(1); fopen(Tabor2.Ins); %Tabor1.setSingleTrigOut;
% Tabor2.IDN
% catch E
% % Tabor2 = WW1072('192.168.1.56'); pause(1); fopen(Tabor2.Ins); %Tabor1.setSingleTrigOut;
% display('2nd tabor2 attempt');
% end


BB = B2962A('192.168.1.121');
% if(Tabor1.OutputState());
%     display('Tabor was on')
% else
%     display('Tabor was off')
% end

% [BB.IDN, Tabor2.IDN]
[BB.IDN]

scope1 = DSOX3000('0x0957::0x17A6::MY52492279'); fopen(scope1.Ins);
% scope2 = DSOX3000('0x0957::0x17A6::MY53160409'); fopen(scope2.Ins);
scope2 = DSOX3000('0x2A8D::0x1764::MY58262742'); fopen(scope2.Ins);

scope3 = DSOX3000('0x0957::0x17A6::MY52492273'); fopen(scope3.Ins);
[scope1.IDN, scope2.IDN, scope3.IDN]
% scope1.Reset();
% pause(2)
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
h_xPr = actxcontrol(progID,[20 20 600 400],ProbeFigure);
h_xPr.StartCtrl;
set(h_xPr,'HWSerialNum',SNPr);
h_xPr.Identify;

h_xPr.SetJogStepSize(0.00, 0.02);

%% default configurations to Tzabads
% display('Are all the scope impedance mathching and AD/DC coupling correct?')
% display('Are all the Agilents channels off?')
% display('are the LIA parameters (gain, TC and slope) known?')
% display('is the trigger operating?')
% 
% %% more physical sanity checks
% display('Is the oven operating and in the right temperature?')
% display('can you see atoms? can you see absorbtion lines?')
% display('Is the ESR amplifier working?')
% display('is the BPD zeroed?')

%% channels configurations
%AG1
% ch_129_NMR = 1; ch_By_DC = 2;
% %AG5
% ch_131_NMR = 1; ch_Bx_DC = 2;
% %AG2
% ch_pump = 1; ch_prob = 2;
% % %AG6
% ch_131_Bz_mod = 1; ch_129_Bz_mod = 2;
% % AGESR
% ch_esr = 2; ch_trig = 1;
% %BB
% ch_bz = 1;
%%
master_instr.scope1 = scope1;
master_instr.scope2 = scope2;
master_instr.scope3 = scope3;
master_instr.AG1 = AG1;
master_instr.AG2 = AG2;
master_instr.AG3 = AG3;
master_instr.AG5 = AG5;
master_instr.BB = BB;
master_instr.Tabor1 = Tabor1;
master_instr.h_xPr = h_xPr;
master_instr.LIA2 = LIA2;
master_instr.LIAESR = LIAESR;





% fprintf(scope1.Ins, [':WAV:POIN ' num2str(16000)])
