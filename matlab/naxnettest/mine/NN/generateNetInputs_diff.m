function [X,T,t]=generateNetInputs_diff(params,calculations,commonticks)
inputsl1=[];
inputsu1=[];

if (~isempty(params.net.lower_indicators.inputs))
inputsl1=table2array(calculations.indicators{1}.lower(:,params.net.lower_indicators.inputs));
end


if (~isempty(params.net.upper_indicators.inputs))
inputsu1=table2array(calculations.indicators{1}.upper(:,params.net.upper_indicators.inputs));
end


targets1=table2array(calculations.indicators{1}.lower(:,params.net.lower_indicators.targets));

quotes=table2array(params.TimeTables.Minute);
%inputs2=normalizeQuote(quotes);

inputs2=quotes-shift(quotes,1);

ncticks=numel(commonticks);

inputs3=[];
for i=1:ncticks
	
    
   % inputs_=table2array(commonticks{i}.calculations.indicators{1}.lower(:,commonticks{i}.params.net.lower_indicators.inputs));
    
    inputsl1_=[];
if (~isempty(params.net.lower_indicators.inputs))
inputsl1_=table2array(commonticks{i}.calculations.indicators{1}.lower(:,commonticks{i}.params.net.lower_indicators.inputs));
end

inputsu1_=[];
if (~isempty(params.net.upper_indicators.inputs))
inputsu1_=table2array(commonticks{i}.calculations.indicators{1}.upper(:,commonticks{i}.params.net.upper_indicators.inputs));
end

    %commonquotes=normalizeQuote(commonticks{i}.params.TimeTables.Minute.Open);
    commonquotes=commonticks{i}.params.TimeTables.Minute.Open;
    inputs4=commonquotes-shift(commonquotes,1);
    
    inputs3=[inputs3, inputs4, inputsl1_, inputsu1_];
end



X=[inputs2,inputs3,inputsl1,inputsu1,inputs3]';
t=[targets1]';
T=convertCondensedToTarget(t);

end