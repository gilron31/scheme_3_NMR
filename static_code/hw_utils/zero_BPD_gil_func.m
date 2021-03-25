function [logZBPD] = zero_BPD_gil( motor_apt_driver,  sc,meanv_tol )
wait_after_jog = 0.2;
maxjog = 1.0; 
minjog = 0.01;

MAXBPD = 2.9749;
MINBPD = -2.8945;
boundstol = 0.05;
ovf_mass_ratio = 0.05;
if(~exist('meanv_tol'))
meanv_tol = 1.0;
end
mean_V_2_deg_20mw = 0.9/0.02;

init_pos = motor_apt_driver.GetPosition_Position(0);

sc.setVoffset(4,0.0)
sc.setVscale(4,1.0)
sc.setChCoupling(4, 'DC')
currsctscale = sc.getTscale();
sc.setTscale(1e-4);
sc.TrigSource('LINE');
stoploop = 0;
counter = 0;
currjog = 0.01;
bigjog = 0.1;
motor_apt_driver.SetJogStepSize(0.00, currjog);

BPD_signal_too_big = 0;

%% course grained search
while(~stoploop && counter < 100)
sc.Single()
sc.readyToRead()
[t,v] = sc.Read(4);
meanv = mean(v);
Np = length(v);
Nabove = length(v(v>=MAXBPD*(1-boundstol)));
Nbelow = length(v(v<=MINBPD*(1-boundstol)));

toohigh_ovf = Nabove/Np>ovf_mass_ratio;
toolow_ovf = Nbelow/Np>ovf_mass_ratio;
curr_pos = motor_apt_driver.GetPosition_Position(0);
if((Nabove/Np ==1 || Nbelow/Np == 1))
    motor_apt_driver.SetJogStepSize(0.00, bigjog);
end

sc.Run

updir = 1;
downdir = 2;

% updir = 2;
% downdir = 1;

if(abs(meanv) > meanv_tol)
    if(meanv < -meanv_tol)
        motor_apt_driver.MoveJog(0, updir);
    else
        motor_apt_driver.MoveJog(0, downdir);
    end
    pause(wait_after_jog)
else
    stoploop = 1;
%     display(['pos is: ' num2str(curr_pos)])
%     display(['meanV is: ' num2str(meanv)])
%     display(['toohigh_ovf is: ' num2str(toohigh_ovf)])
%     display(['toolow_ovf is: ' num2str(toolow_ovf)])
end
counter = counter + 1;
end

if (toohigh_ovf && toolow_ovf)
    display('BPD signal is too large, error!');
    BPD_signal_too_big = 1;
else
    %% fine grained search

    if(toolow_ovf)
        jogdir = updir;
    else
        jogdir = downdir;
    end
    stoploop = 0;
    currjog = 0.02;
    motor_apt_driver.SetJogStepSize(0.00, currjog);
    start_toolow = toolow_ovf;
    start_toohigh = toohigh_ovf;
    while(~stoploop && counter < 100)
        if(counter >50)
                smalljog = 0.008;
            motor_apt_driver.SetJogStepSize(0.00, smalljog);
        end
        sc.Single()
        sc.readyToRead()
        [t,v] = sc.Read(4);
        meanv = mean(v);
        Np = length(v);
        Nabove = length(v(v>=MAXBPD*(1-boundstol)));
        Nbelow = length(v(v<=MINBPD*(1-boundstol)));
        toohigh_ovf = Nabove/Np>ovf_mass_ratio;
        toolow_ovf = Nbelow/Np>ovf_mass_ratio;
        curr_pos = motor_apt_driver.GetPosition_Position(0);
        sc.Run

        if(toohigh_ovf && toolow_ovf)
            stoploop = 1;
            display('BPD signal is too large, error!');
            BPD_signal_too_big = 1;

        else
            if(~toohigh_ovf && ~toolow_ovf)
                stoploop = 1;
%                 display(['pos is: ' num2str(curr_pos)])
%                 display(['meanV is: ' num2str(meanv)])
%                 display(['toohigh_ovf is: ' num2str(toohigh_ovf)])
%                 display(['toolow_ovf is: ' num2str(toolow_ovf)])
%                 display('BPD Successfully zeroed!');
            
            else if((start_toolow == toolow_ovf) & (start_toohigh == toohigh_ovf) )
                motor_apt_driver.MoveJog(0, jogdir);
                pause(wait_after_jog)
                else
                    jogdir = 3 - jogdir;
                    start_toolow = ~start_toolow;
                    start_toohigh = ~start_toohigh;

                end
            end
        end
    sc.Run
    counter = counter + 1;
    end
end

logZBPD.Fraction_ovf =  Nabove/Np;
logZBPD.Fraction_uvf =  Nbelow/Np;
logZBPD.meanV = meanv;
logZBPD.pos = curr_pos;
logZBPD.lastWFRM = v;
logZBPD.BPD_signal_too_big = BPD_signal_too_big;

sc.setTscale(currsctscale);
end

