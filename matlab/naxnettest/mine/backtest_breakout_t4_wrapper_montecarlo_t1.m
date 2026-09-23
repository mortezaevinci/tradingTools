%for now, this would only work for the last day of data, because of the way
%last day and last month are found.

%************this will probably not work at the first day of the month...
%need to find the last month, last day better.. maybe won't even work at
%the beginnign of thre day

%can possibly update tm data in real-time here, and show

close all

 global SYMBOLDONETODAY;
clearvars -except SYMBOLDONETODAY;
basedate='20_05_22'; %set to last saturday, where data are gathered

useparfor=0; %0 do not use, Inf use

%looperparams_realtime;
run('config\looperparams_backtest_montecarlo.m');

looperParams.symbols={'WMT'};

run('config\mainparams_backtest_montecarlo.m');

l_avs=0:.1:0.5;
l_thresh.dcs.fight.min=.5:0.1:1;
l_thresh.dsma5.min=0:0.05:.2;
l_minNextLvlByPercent=0:.025:.2;

na1=numel(l_avs);
na2=numel(l_thresh.dcs.fight.min);
na3=numel(l_thresh.dsma5.min);
na4=numel(l_minNextLvlByPercent);

opt_params=tempsymbol.params;
rsuccess=-200;

progress=0;
for a1=l_avs
    for a2=l_thresh.dcs.fight.min
        for a3=l_thresh.dsma5.min
            for a4=l_minNextLvlByPercent
            
                tempsymbol.params.thresh.avs.min=a1;
                tempsymbol.params.thresh.dcs.fight.min=a2;
                tempsymbol.params.thresh.dsma5.min=a3;
                tempsymbol.params.thresh.minNextLvlByPercent=a4;
                
                backtest_breakout_t4;
                
                if (result{1}.success>rsuccess)
                    rsuccess=result{1}.success
                    opt_params=tempsymbol.params
                    progress=100*a1*a2*a3*a4/na1/na2/na3/na4
                end
            end
        end
    end
end
rsuccess
opt_params