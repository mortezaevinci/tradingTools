function layout=graphStrategy_t10_init(panel,looperEngine,params,result)
layout=struct();
layout.extended=0;
try

if (isvalid(panel))

tlt=tiledlayout(panel,10,10);
tlt.Padding = "none";
tlt.TileSpacing = "none";

%% lower indicators

layout.ax{1}=nexttile(tlt,[10,10]);
layout.bar_profile=barh(0,0,'k');
DCM_ON;
hold on;
layout.plot_profile=plot(0,0,'r*');
DCM_ON;
hold off;

else
    disp('panel invalid');
end
catch exception
dumpReport('error.log', exception)
end
end