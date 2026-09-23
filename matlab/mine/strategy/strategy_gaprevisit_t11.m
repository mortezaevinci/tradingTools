function [maintick,debug]=strategy_gaprevisit_t11(looperEngine,maintick,commonticks)
debug=struct();
try
    
    global showbackdateonce;
    
    if (looperEngine.process.type==0)
        timetablePrimary=maintick.params.TimeTables.Minute;
        timetableSecondary=maintick.params.TimeTables.Day;
        timetableAuxilary=maintick.params.TimeTables.Month;
        preps.alpha=.60;
        preps.alphalong=0.60;
    end
    if (looperEngine.process.type==1)
        timetablePrimary=maintick.params.TimeTables.Day(end-90:end,:);
        timetableSecondary=maintick.params.TimeTables.Month;
        timetableAuxilary=maintick.params.TimeTables.Month;
        preps.alpha=0.25;
        preps.alphalong=0.60;
    end
    
    if (isempty(timetablePrimary))
        return;
    end
    
    maintick.calculations.started=1;
    
    %% process limit
    try
        % Set process limit after ORB
        if (looperEngine.process.limit>0)
            proclimit_=min(looperEngine.process.limit,numel(timetablePrimary.Date)-1);
            timetablePrimary=timetablePrimary(end-proclimit_:end,:);
            
        end
        tms=size(timetablePrimary,1);
    catch exception
        dumpReport('error.log', exception)
    end
    %%;ticsprep=toc
    
    %%;tic;
    %% pivots
    [levels(3),mc,mo]=indicators_levels_mlh(timetableAuxilary,datestr(timetablePrimary.Date(end)),preps);
    levels(1)=indicators_levels_ma(maintick.params.TimeTables.Day,preps);
    levels(2)=indicators_levels_dlh(maintick.params.TimeTables.Day,timetablePrimary.Date(end),maintick.params.lenPreviousDayPivots,preps);
    %% special level that is invalid to use in studies. commented out, as it makes studies invalid for now
    %levels_orb=indicators_levels_orb(timetablePrimary,preps);
    %% pre-market levels
    levels(4)=indicators_levels_adh(maintick.params.TimeTables.MinuteFull,preps);
    %sve
    levels(5) = indicators_levels_pp(@SVEPivots,mc,levels(3).values(2),levels(3).values(1),'-',2,0x03,'MS',preps.alphalong);
    levels(6) = indicators_levels_pp(@SVEPivots,maintick.calculations.previousClose,levels(2).values(2),levels(2).values(1),'-',1,0x04,'DS',preps.alpha);
    % %woodies
    % levels(7) = indicators_levels_pp(@WoodiesPivots,mc,levels(3).values(2),levels(3).values(1),'--',2,0x05,'MW',preps.alphalong);
    % levels(8) = indicators_levels_pp(@WoodiesPivots,maintick.calculations.previousClose,levels(2).values(2),levels(2).values(1),'--',1,0x06,'DW',preps.alpha);
    %fibonacci
    levels(9) = indicators_levels_pp(@FibonacciPivots,mc,levels(3).values(2),levels(3).values(1),'-',2,0x0D,'MF',preps.alphalong);
    levels(10) = indicators_levels_pp(@FibonacciPivots,maintick.calculations.previousClose,levels(2).values(2),levels(2).values(1),'-',1,0x0E,'DF',preps.alpha);
    
    %round numbers
    % levels(11)=indicators_levels_rnd(timetablePrimary,preps);
    %%;ticlevels=toc
    
    minmin=min(timetablePrimary.Low)*0.85;
    maxmax=max(timetablePrimary.High)*1.15;
    viewingScale=[minmin,maxmax];
    maintick.calculations.levels = indicators_levels_all(levels,viewingScale);
    %%;tic
    
    %find the first good level above
    rval=roundRangeLogic(timetablePrimary.Open(1));
    
    %find levels above open
    lvlsi=find(maintick.calculations.levels.values>timetablePrimary.Open(1));
    lvls=maintick.calculations.levels.values(lvlsi);
    
    dlevels=diff(lvls);
    dli=find(dlevels>rval(1));
    
    if (isempty(dli))
        return;
    end
    
    closestdlevelindex=dli(1);
    closestlevel=lvls(closestdlevelindex);
    closestgap=dlevels(closestdlevelindex);
    
    %then find crossings for that level
    [lx,~]=crossPivot2(timetablePrimary,closestlevel);
    
    if (sum(lx>0)>0)
        
        xind=find(lx>0);
        firstx=xind(1);
        
        cond0=lx>0;
        %one condition is that, next crossing is at cumsum>=2 at least (At lease
        %the pivot was crossed 1 time before. Considering that we want it back and
        %forth, it will be at least 2 anyway)
        countinglx=cumsum(lx>0);
        cond1=countinglx>1;
        %second condition, after the first crossing, the price action should not
        %have moved less than half of the closestgap (gauranteeing a Reward/Risk of
        %2, where minimum signal after first crossing becomes stop loss).
        %so price after first corssing not less than closestlevel-gap/2
        cond2=movmin(shiftpad(timetablePrimary.Low,-firstx),[size(timetablePrimary,1),0])>closestlevel-closestgap/2;
        
        %condition3: before breakout crossing (The one we buy), price action should
        %not have gone more than 1/4 of the gap up, so price never over
        %closestlevel+gap/4
        cond3=movmax(timetablePrimary.High,[size(timetablePrimary,1),0])<closestlevel+closestgap/4;
        
        condgr=cond0&cond1&cond2&cond3;
        
        cgri=find(condgr>0);
        if (~isempty(cgri))
            timetablePrimary.Date(cgri)
            
            
        end
    end
    
    maintick.calculations.finished=1;
    %try for all
catch exception
    dumpReport('error.log', exception)
    
end


end

