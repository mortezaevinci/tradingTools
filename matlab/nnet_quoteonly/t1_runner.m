t1_setup;

%t1_donet_init;
t1_donet_feedback_init;

datestrings={'2020-05-28','2020-05-29','2020-06-01'};
for dsi=1:numel(datestrings)
datestring=datestrings{dsi};
t1_prepare;

%t1_donet;
t1_donet_feedback;
end

save([quotelocation  'net test' datestring '.mat'],'net','nets');

%t1_plots;
t1_plots_feedback;

%datestring='2020-06-02';
datestring='2020-05-22';
t1_prepare_test;

%t1_plots;
t1_plots_feedback;