t1_setup;

%t1_donet_init;
t1_donet_feedback_init;

datestrings={'2020-11-09'};
for dsi=1:numel(datestrings)
datestring=datestrings{dsi};
t1_prepare; %will cut last day for testing

%t1_donet;
t1_donet_feedback;
end

save([quotelocation  'net test' datestring '.mat'],'net','nets');

%t1_plots;
t1_plots_feedback_daily;

datestring='2020-11-09';
t1_prepare_test;

%t1_plots;
t1_plots_feedback_daily;