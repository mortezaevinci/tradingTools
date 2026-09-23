function [X,C,T,t,indices,viewx,indicators]=generateNetInputs_t10(looperEngine,params,calculations,commonticks)
inputsl1=[];
inputsu1=[];
inputse1=[];
X=[];
T=[];
indices=[];
t=[];
viewx=[];
try
    
    %grab relative quote of last 10 samples as well
    % inputsrq_=table2array(calculations.indicators{1}.lower(:,'relativeQuote'));
    % inputsrq=[];
    % for i=1:20
    % inputsrq=[inputsrq shiftpad(inputsrq_,i)];
    % end
    inputsrq=[];
    %inputsrq_labels={};
    
    
    %% try giving daily data to it
    
    dailyt=((params.TimeTables.Day((end-90):end,:).Close));
    
    %instead of repmat, maybe this could be compared to close of last minute
    %data and generate the full table (note in this case, repmat dcannot be
    %used data are not constant anymore)
    dailyfromnow=(params.TimeTables.Minute(1,:).Open-dailyt')/calculations.atr(end);
    dailyr=[0 ; tick2ret(dailyt)]'/calculations.atr(end);
    
    %dailypast=[dailyfromnow,dailyr];
    dailypast=[dailyr];
    indicators.X.daily.tick2ret = dailypast;
    indicators.X.daily.trends = calculations.dailytrends;
    C = [indicators.X.daily.tick2ret  indicators.X.daily.trends];
    %% lower indicator of main
    if (~isempty(params.net.lower_indicators.inputs))
        %inputsl1_labels = calculations.indicators{1}.lower.Properties.VariableNames(params.net.lower_indicators.inputs);
        indicators.X.lower = timetable2table(calculations.indicators{1}.lower(:,params.net.lower_indicators.inputs));
        inputsl1=table2array(calculations.indicators{1}.lower(:,params.net.lower_indicators.inputs));
        
        % %supposed to normalize indicators... needs verification
        % ii=genindicatorindextable(calculations.indicators{1}.lower);
        % indices=table2array(ii(1,params.net.lower_indicators.inputs));
        % mm=params.Strategies.TotalIndicators.Conditions.Entry{1}.mean(indices);
        % rr=params.Strategies.TotalIndicators.Conditions.Entry{1}.range(indices);
        % mmp=repmat(mm,size(inputsl1,1),1);
        % rrp=repmat(rr,size(inputsl1,1),1);
        % inputsl1=(inputsl1-mmp).*rrp;
    end
    
    if (~isempty(params.net.upper_indicators.inputs))
        %inputsu1_labels = calculations.indicators{1}.upper.Properties.VariableNames(params.net.upper_indicators.inputs);
        indicators.X.upper =timetable2table(calculations.indicators{1}.upper(:,params.net.upper_indicators.inputs));
        inputsu1=table2array(calculations.indicators{1}.upper(:,params.net.upper_indicators.inputs));
        
    end
    
    if (~isempty(params.net.eval_indicators.inputs))
        %inputse1_labels = calculations.indicators{1}.eval.Properties.VariableNames(params.net.eval_indicators.inputs);
        indicators.X.eval = timetable2table(calculations.indicators{1}.eval(:,params.net.eval_indicators.inputs));
        inputse1=table2array(calculations.indicators{1}.eval(:,params.net.eval_indicators.inputs));
        
    end
    
    indicators.T.lower = timetable2table(calculations.indicators{1}.lower(:,params.net.lower_indicators.targets));
    indicators.T.eval =timetable2table(calculations.indicators{1}.eval(:,params.net.eval_indicators.targets));
    indicators.T.upper =timetable2table(calculations.indicators{1}.upper(:,params.net.upper_indicators.targets));
    targets_l1=table2array(calculations.indicators{1}.lower(:,params.net.lower_indicators.targets));
    targets_e1=table2array(calculations.indicators{1}.eval(:,params.net.eval_indicators.targets));
    targets_u1=table2array(calculations.indicators{1}.upper(:,params.net.upper_indicators.targets));
    targets1=[targets_l1,targets_e1,targets_u1];
    
    %targets_l1_labels=(calculations.indicators{1}.lower.Properties.VariableNames(params.net.lower_indicators.targets));
    %targets_e1_labels=(calculations.indicators{1}.eval.Properties.VariableNames(params.net.eval_indicators.targets));
    %targets_u1_labels=(calculations.indicators{1}.upper.Properties.VariableNames(params.net.upper_indicators.targets));
    %targets1_labels=[targets_l1_labels,targets_e1_labels,targets_u1_labels];
    
    ncticks=numel(commonticks);
    
    inputsci=cell(1,ncticks);
    for i=1:ncticks
        
        
        dailyt=((commonticks{i}.params.TimeTables.Day((end-90):end,:).Close));
        
        %instead of repmat, maybe this could be compared to close of last minute
        %data and generate the full table (note in this case, repmat dcannot be
        %used data are not constant anymore)
        dailyfromnow=(commonticks{i}.params.TimeTables.Minute(1,:).Open-dailyt')/commonticks{i}.calculations.atr(end);
        dailyr=[0 ; tick2ret(dailyt)]'/commonticks{i}.calculations.atr(end);
        
        %dailypast=[dailyfromnow,dailyr];
        dailypast=[dailyr];
        indicators.C{i}.daily.tick2ret = dailypast;
        indicators.C{i}.daily.trends = calculations.dailytrends;
        C = [C indicators.X.daily.tick2ret  indicators.X.daily.trends];
        
        inputsl1c=[];
        if (~isempty(params.net.lower_indicators.inputs))
            %inputsl1c_labels = commonticks{i}.calculations.indicators{1}.lower.Properties.VariableNames(commonticks{i}.params.net.lower_indicators.inputs);
            indicators.C{i}.lower = timetable2table(commonticks{i}.calculations.indicators{1}.lower(:,commonticks{i}.params.net.lower_indicators.inputs));
            inputsl1c=table2array(commonticks{i}.calculations.indicators{1}.lower(:,commonticks{i}.params.net.lower_indicators.inputs));
            
            % %supposed to normalize indicators... needs verification
            % ii=genindicatorindextable(commonticks{i}.calculations.indicators{1}.lower);
            % indices=table2array(ii(1,commonticks{i}.params.net.lower_indicators.inputs));
            % mm=commonticks{i}.params.Strategies.TotalIndicators.Conditions.Entry{1}.mean(indices);
            % rr=commonticks{i}.params.Strategies.TotalIndicators.Conditions.Entry{1}.range(indices);
            % mmp=repmat(mm,size(inputsl1,1),1);
            % rrp=repmat(rr,size(inputsl1,1),1);
            % inputsl1_=(inputsl1_-mmp).*rrp;
        end
        
        inputsu1c=[];
        if (~isempty(params.net.upper_indicators.inputs))
            %inputsu1c_labels = commonticks{i}.calculations.indicators{1}.upper.Properties.VariableNames(commonticks{i}.params.net.upper_indicators.inputs);
            indicators.C{i}.upper = timetable2table(commonticks{i}.calculations.indicators{1}.upper(:,commonticks{i}.params.net.upper_indicators.inputs));
            inputsu1c=table2array(commonticks{i}.calculations.indicators{1}.upper(:,commonticks{i}.params.net.upper_indicators.inputs));
            
        end
        
        inputse1c=[];
        if (~isempty(params.net.eval_indicators.inputs))
            %inputse1c_labels = commonticks{i}.calculations.indicators{1}.eval.Properties.VariableNames(commonticks{i}.params.net.eval_indicators.inputs);
            indicators.C{i}.eval = timetable2table(commonticks{i}.calculations.indicators{1}.eval(:,commonticks{i}.params.net.eval_indicators.inputs));
            inputse1c=table2array(commonticks{i}.calculations.indicators{1}.eval(:,commonticks{i}.params.net.eval_indicators.inputs));
        end
        
        inputsci{i}=[inputsl1c, inputsu1c, inputse1c];%,in4];
        %inputsci_labels{i} = {inputsl1c_labels{:}, inputsu1c_labels{:}, inputse1c_labels{:}};
    end
    
    nmininput3=1000000;
    for i=1:ncticks
        ns=size(inputsci{i},1);
        if (ns<nmininput3)
            nmininput3=ns;
        end
    end
    inputsc=[];
    %inputsc_labels=cell(0);
    %inputsc_labels_cnt=1;
    for i=1:ncticks
        it=inputsci{i};
        inputsc=[inputsc it(1:nmininput3,:)];
        %inputsc_labels = {inputsc_labels{:},inputsci_labels{i}{:}};
    end
    
    endpoint=min(size(inputsl1,1),nmininput3);
    
    try
        inputsc=inputsc(1:endpoint,:);
    catch
    end
    try
        inputsl1=inputsl1(1:endpoint,:);
    catch
    end
    try
        inputsu1=inputsu1(1:endpoint,:);
    catch
    end
    try
        inputse1=inputse1(1:endpoint,:);
    catch
    end
    
    try
        targets1=targets1(1:endpoint,:);
    catch
    end
    
    try
        indicators.X.lower = indicators.X.lower(1:endpoint,:);
        indicators.X.upper = indicators.X.upper(1:endpoint,:);
        indicators.X.eval = indicators.X.eval(1:endpoint,:);
        
        indicators.T.lower = indicators.T.lower(1:endpoint,:);
        indicators.T.upper = indicators.T.upper(1:endpoint,:);
        indicators.T.eval = indicators.T.eval(1:endpoint,:);
        
        for i=1:ncticks
            indicators.c{i}.lower = indicators.T.lower(1:endpoint,:);
            indicators.C{i}.upper = indicators.T.upper(1:endpoint,:);
            indicators.C{i}.eval = indicators.T.eval(1:endpoint,:);
        end
        
    catch
    end
    
    
    inputC=repmat(C,endpoint,1);
    X=[inputsrq,inputsl1,inputsu1,inputse1,inputsc,inputC];
    
    %     labels.X={inputsrq_labels{:}, ...
    %               inputsl1_labels{:},inputsu1_labels{:},inputse1_labels{:}, ...
    %               dailypast_labels{:},inputsc_labels{:}};
    
    t=[targets1];
    
    indices=(1:size(t,1))';
    
    viewx=params.TimeTables.Minute.Open(looperEngine.skipTrainingFromStart:end);
    
    X=X(looperEngine.skipTrainingFromStart:end,:);
    t=t(looperEngine.skipTrainingFromStart:end,:);
    
    indices=indices(looperEngine.skipTrainingFromStart:end,:);
    
    r=NanRows(X);
    X=X(~r,:)';
    t=t(~r,:)';
    indices=indices(~r,:);
    viewx=viewx(~r,:)';
    
    T=convertCondensedToTarget(t);
catch exception
    dumpReport('error.log', exception)
end
end