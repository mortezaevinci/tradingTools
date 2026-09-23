
%% Convert data to the table format
function procData = yahooOptionsFromJson(jdata)
try
    
    jdor=jsondecode(jdata).optionChain.result;
   % jdorq=jdor.quote; %to get current price for selection
    
   % mark=(jdorq.bid+jdorq.ask)/2;
   % gmtoffsethours=jdor.gmtOffSetMilliseconds/3600000;
    
   % calls=jdor.options.calls;
    %puts=jdor.options.puts;
    
 
    if (isstruct(jdor.options.calls))
     
       temp= jdor.options.calls;
       
       jdor.options.calls={};
        
       for i=1:numel(temp)
           jdor.options.calls{i}=temp(i);
       end
    end
    
     if (isstruct(jdor.options.puts))
       temp= jdor.options.puts;

       jdor.options.puts={};
        
       for i=1:numel(temp)
           jdor.options.puts{i}=temp(i);
       end
    end
    
    procData=jdor;
    
catch exception
    disp('Could not parse Yahoo chart data.');
    procData=[];
end
end