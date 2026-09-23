function [X,T,t,indices,viewx]=generateNetInputs(looperEngine,params,calculations,commonticks)
inputsl1=[];
inputsu1=[];
inputse1=[];
X=[];
T=[];
indices=[];
t=[];
viewx=[];
try


%% try giving daily data to it

dailyt=((params.TimeTables.Day((end-90):end,:).Close))';
%dailyr=[0%%tick2ret(dailyt)];

%% lower indicator of main
if (~isempty(params.net.lower_indicators.inputs)) 
inputsl1=table2array(calculations.indicators{1}.lower(:,params.net.lower_indicators.inputs));
% supposed to normalize indicators... needs verification
% ii=genindicatorindextable(calculations.indicators{1}.lower); 
% indices=table2array(ii(1,params.net.lower_indicators.inputs));
% mm=params.Strategies.TotalIndicators.Conditions.Entry{1}.mean(indices);
% rr=params.Strategies.TotalIndicators.Conditions.Entry{1}.range(indices);
% mmp=repmat(mm,size(inputsl1,1),1);
% rrp=repmat(rr,size(inputsl1,1),1);
% inputsl1=(inputsl1-mmp).*rrp;
end

if (~isempty(params.net.upper_indicators.inputs))
inputsu1=table2array(calculations.indicators{1}.upper(:,params.net.upper_indicators.inputs));

end

if (~isempty(params.net.eval_indicators.inputs))
inputse1=table2array(calculations.indicators{1}.eval(:,params.net.eval_indicators.inputs));

end

targets_l1=table2array(calculations.indicators{1}.lower(:,params.net.lower_indicators.targets));
targets_e1=table2array(calculations.indicators{1}.eval(:,params.net.eval_indicators.targets));
targets_u1=table2array(calculations.indicators{1}.upper(:,params.net.upper_indicators.targets));
targets1=[targets_l1,targets_e1,targets_u1];

ncticks=numel(commonticks);

inputs_commonticks_=cell(1,ncticks);
for i=1:ncticks
	
inputsl1_=[];
if (~isempty(params.net.lower_indicators.inputs))
inputsl1_=table2array(commonticks{i}.calculations.indicators{1}.lower(:,commonticks{i}.params.net.lower_indicators.inputs));
% supposed to normalize indicators... needs verification
% ii=genindicatorindextable(commonticks{i}.calculations.indicators{1}.lower); 
% indices=table2array(ii(1,commonticks{i}.params.net.lower_indicators.inputs));
% mm=commonticks{i}.params.Strategies.TotalIndicators.Conditions.Entry{1}.mean(indices);
% rr=commonticks{i}.params.Strategies.TotalIndicators.Conditions.Entry{1}.range(indices);
% mmp=repmat(mm,size(inputsl1,1),1);
% rrp=repmat(rr,size(inputsl1,1),1);
% inputsl1_=(inputsl1_-mmp).*rrp;
end

inputsu1_=[];
if (~isempty(params.net.upper_indicators.inputs))
inputsu1_=table2array(commonticks{i}.calculations.indicators{1}.upper(:,commonticks{i}.params.net.upper_indicators.inputs));

end

inputse1_=[];
if (~isempty(params.net.eval_indicators.inputs))
inputse1_=table2array(commonticks{i}.calculations.indicators{1}.eval(:,commonticks{i}.params.net.eval_indicators.inputs));

end


    inputs_commonticks_{i}=[inputsl1_, inputsu1_, inputse1_];%,in4];
end

nmininput3=1000000;
for i=1:ncticks
	ns=size(inputs_commonticks_{i},1);
    if (ns<nmininput3) 
        nmininput3=ns;
    end
end
inputs_commonticks=[];
for i=1:ncticks
    it=inputs_commonticks_{i};
  inputs_commonticks=[inputs_commonticks it(1:nmininput3,:)];
end

endpoint=min(size(inputsl1,1),nmininput3);

try
inputs_commonticks=inputs_commonticks(1:endpoint,:);
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

inputsd1=repmat(dailyt,endpoint,1);
%X=[inputsrq,inputsl1,inputsu1,inputse1,inputsd1,inputs_commonticks];

X=[inputsrq,inputsl1,inputsu1,inputse1,inputs_commonticks];
%X=[inputs2,inputs_commonticks,inputsl1,inputsu1,inputs_commonticks]';
t=[targets1];
%

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