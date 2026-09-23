t1_setup;

t1_donet_init;

datestrings={'2020-05-28','2020-05-29','2020-06-01'};
for i=1:2
for dsi=1:numel(datestrings)
datestring=datestrings{dsi};
t1_prepare;

t1_donet;
t1_plots;
end
end

save([quotelocation  'net test' datestring '.mat'],'net');



datestring='2020-05-27';
t1_prepare_test;

t1_plots;