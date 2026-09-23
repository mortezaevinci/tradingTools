    global loop_calculations_run
    loop_calculations_run=1;

% if (exist('parf_loop_calculations'))
% if (~isempty(parf_loop_calculations) || strcmp(parf_loop_calculations.State,'running'))
%     
%     cancel(parf_loop_calculations);
% end
% end
backtest_breakout_t7_workeroff;

parf_loop_calculations=parfeval(@loop_calculations, 1,mainticks,commonticks,looperEngine);
% drawtimer=[];
% if (looperEngine.graph.show>0)
% drawtimer=timer;
% drawtimer.StartDelay=1;
% drawtimer.TimerFcn=@(~,~)drawnow;
% drawtimer.Period=5;
% drawtimer.ExecutionMode ='fixedSpacing';
% 
% start(drawtimer);
% 
% end