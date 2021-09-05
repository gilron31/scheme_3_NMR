classdef WW1072
% Updates:
% 05/11/19 - Roy: Copied WW1071 updates from 04/11/19 and before
% 18/05/20 - Avraham Berrebi: Add SinglePulseDelay

   properties(Transient)
   Ins
   end
   methods
    function obj = WW1072(address,connection_type)
           if ~exist('address','var'); address = '192.168.1.31'; end;
           if exist('connection_type','var') && strcmpi(connection_type,'GPIB')
               obj.Ins = gpib('NI', 0, address,'Timeout', 1.0);
           else
           obj.Ins = instrfind('Type', 'tcpip', 'RemoteHost',address, 'RemotePort', 23, 'Tag', '');
           if isempty(obj.Ins)
               obj.Ins = tcpip(address, 23, 'Timeout', 2);
               set(obj.Ins, 'Name', ['TaborWW1072-' address]);
               else
               fclose(obj.Ins);
               obj.Ins = obj.Ins(1);
           end
           end
    end
    
    function data = IDN(obj) %IDN
        fprintf(obj.Ins,'*IDN?');
        data = fscanf(obj.Ins);
    end
    
    function Reset(obj)
        fprintf(obj.Ins,'*RST');
    end
    
    function Sin(obj,ch,freq,amp,offs)
        fprintf(obj.Ins,sprintf('INST%d',ch));
        data=[num2str(freq),',',num2str(amp),',',num2str(offs)];
        fprintf(obj.Ins,['APPL:SIN ',data]);
    end
    
    function Triangle(obj,ch,freq,amp,offs)
        fprintf(obj.Ins,sprintf('INST%d',ch));
        data=[num2str(freq),',',num2str(amp),',',num2str(offs)];
        fprintf(obj.Ins,['APPL:TRI ',data]);
    end
    
    function Ramp(obj,ch,freq,amp,offs,delay,rise,fall)
        fprintf(obj.Ins,sprintf('INST%d',ch));
        data=[num2str(freq),',',num2str(amp),',',num2str(offs),',',num2str(delay),',',num2str(rise),',',num2str(fall)];
        fprintf(obj.Ins,['APPL:RAMP ',data]);
    end
    
    function Pulse(obj,ch,freq,amp,offs,delay,dt,rise,fall)
        fprintf(obj.Ins,sprintf('INST%d',ch));
        data=[num2str(freq),',',num2str(amp),',',num2str(offs),',',num2str(delay),',',...
            num2str(dt),',',num2str(rise),',',num2str(fall)];
        fprintf(obj.Ins,['APPL:PULSe ',data]);
    end
    
    function Square(obj,ch,freq,amp,offs,duty_cycle)
      if ~exist('duty_cycle','var'); duty_cycle = 50; end;
      fprintf(obj.Ins,sprintf('INST%d',ch));
      data=[num2str(freq),',',num2str(amp),',',num2str(offs),',',num2str(duty_cycle)];
      fprintf(obj.Ins,['APPL:SQU ',data]);
      end

    function DC(obj,ch,amp)
        fprintf(obj.Ins,sprintf('INST%d',ch));
        data = num2str(abs(amp));
        sgn = num2str(sign(amp)*100);
        fprintf(obj.Ins,['VOLT ',data]);
        fprintf(obj.Ins,['APPL:DC ',sgn]);
    end
    
    function [stt,wvfm] = Output(obj,ch,sw,wvfm_flag)
        for c = ch
        fprintf(obj.Ins,sprintf('INST%d',c));
        if ~exist('sw','var') || isnan(sw) || isempty(sw)
            stt(c==ch) = str2double(query(obj.Ins,'OUTP?'));
            if exist('wvfm_flag','var') && wvfm_flag
                temp = textscan(query(obj.Ins,'APPL?'),'%f,%f,%f');
                wvfm{c==ch}.name = query(obj.Ins,':FUNCTion:SHAPe?');
                while strcmp(wvfm{c==ch}.name(end),char(13)) || strcmp(wvfm{c==ch}.name(end),char(10))
                    wvfm.name(end) = [];
                end
                for J = 1:length(temp); wvfm{c==ch}.p(J)= temp{J}(1); end;
            end
        else
            if length(ch)==2 && length(sw)==1; sw = sw*ones(size(ch)); end;
            fprintf(obj.Ins,sprintf('OUTP %d',sw(c==ch))); stt(c==ch) = sw(c==ch); wvfm = [];
        end
        end
    end
    function [errCode,errString] = readError(obj,disp_flag)
        err = textscan(query(obj.Ins, ':SYSTem:ERRor?'),'%d%q','Delimiter',',');
        errCode = err{1}; errString = err{2}{1};
        if isempty(errString); errCode = false; errString = [];
        elseif exist('disp_flag','var') && disp_flag; disp(errString);
        end
    end
    
    function OutputON(obj,ch)
        fprintf(obj.Ins,sprintf('INST%d',ch)); fprintf(obj.Ins,'OUTP 1');
    end
    function OutputOFF(obj,ch)
        fprintf(obj.Ins,sprintf('INST%d',ch)); fprintf(obj.Ins,'OUTP 0');
    end
    function stt = OutputState(obj,ch)
        fprintf(obj.Ins,sprintf('INST%d',ch));
        stt = strcmpi(query(obj.Ins,'OUTP?'),sprintf('1\r\n'));
    end
    
    function Sync(obj,sw)
        fprintf(obj.Ins,sprintf('OUTPut:SYNC %d',sw));
    end
    
    function SinglePulse(obj,ch,dt,amp,trig_now,offs)
        fprintf(obj.Ins,'INIT:CONT OFF');
        fprintf(obj.Ins,'TRIGger:BURSt ON');
        fprintf(obj.Ins,'TRIGger:COUNt 1');
        fprintf(obj.Ins,'TRIGger:SOURce:ADVance EXTernal');
        if ~exist('ch','var'); ch = 1; end;
        if ~exist('amp','var'); amp = 4; end;
        if ~exist('dt','var'); dt = 0.1e-3; end;
        freq = 1/(2*dt); delay = 0; rise = 0; fall = 0;
        if ~exist('offs','var'); offs = amp/2; else offs = amp/2+offs; end;
        obj.Pulse(ch,freq,amp,offs,delay,0.5/freq,rise,fall);
      if exist('trig_now','var') && trig_now; obj.Trig; end;
    end
    
    function Burst(obj,sw,count)
      TrigTab.Continuous(0); % fprintf(obj.Ins,':TRIGger:MODE TRIGgered');
      fprintf(obj.Ins,sprintf(':TRIGger:BURSt %d',sw));
      fprintf(obj.Ins,':TRIGger:SOURce:ADVance EXTernal');
      if exist('count','var')
          fprintf(obj.Ins,[':TRIGger:BURSt:COUNt ' num2str(count)]);
      end
    end
      
    function Continuous(obj,sw)
      if ~exist('sw','var'); sw=1; end;
      fprintf(obj.Ins,['INIT:CONT ' num2str(sw)]);
    end
      
    function Trig(obj); fprintf(obj.Ins,'*TRG'); end;
    
    function TrigOut(obj,ch,trig_now)
      if ~exist('trig_now','var'); trig_now = false; end;
      TrigTab.Continuous(0);
      obj.OutputON;
      obj.SinglePulse(ch,1e-6,5,trig_now);
    end
    
    function setSingleTrigOut(obj,trig_now)
      if ~exist('trig_now','var'); trig_now = false; end;
      Continuous(obj,0);
      obj.OutputON;
      obj.SinglePulse(10e-6,5,trig_now);
    end
    
    function ContinuousTrigOut(obj,ch,freq)
      if ~exist('freq','var'); freq = 1; end;
      Continuous(obj,1);
      Pulse(obj,ch,freq,5,2.5,0,max(1e-3,0.2e-2/freq),0,0);
      OutputON(obj,ch);
    end
    
    function SinglePulseDelay(obj,ch,freq,width,amp,delay,trig_now)
    % Avraham
    % NOTICE, All the other pulse functions didn't work for me...
    fprintf(obj.Ins,sprintf('INST%d',ch));    
    fprintf(obj.Ins,'TRIGger:MODE:TRIG');
    fprintf(obj.Ins,'TRIGger:BURSt ON');
    fprintf(obj.Ins,'TRIGger:COUNt 1');
    fprintf(obj.Ins,'INIT:CONT ON');
    fprintf(obj.Ins,'INIT:CONT OFF');
    fprintf(obj.Ins,'TRIGger:SOURce:ADVance EXTernal');
    if ~exist('amp','var'); amp = 5; end;
    if ~exist('delay','var'); delay = 0; end;
    width = width * freq * 100; % width = %up (1-99.99)
    delay = delay * freq * 100;
    offs = amp/2; rise = 0; fall = 0; 
    data=[num2str(freq),',',num2str(amp),',',num2str(offs),',',num2str(delay),',',num2str(width),',',num2str(rise),',',num2str(fall)];

    fprintf(obj.Ins,['APPL:PULSe ',data]);
    end
   end
end