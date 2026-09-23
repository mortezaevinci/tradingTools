looperparams_backtest_montecarlo;



l_vs=0:.05:1;
l_dvs_close=-1:0.05:1;
l_dvs_open=-1:0.05:1;
l_dvs_total=-1:0.05:1;

rsuccess=0;
params=[0;0;0;0];

for thresh_vs=l_vs
    thresh_vs
    for thresh.dvs.close.min=l_dvs_close
        for thresh.dvs.open.min=l_dvs_open
            for l_dvs_total=thresh.dvs.total.min


 if (success>rsuccess)
     rsuccess=success;
     params=[thresh_vs;thresh.dvs.close.min;thresh.dvs.open.min;l_dvs_total];
 end
            end
        end
    end
end
rsuccess
params
