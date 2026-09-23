function output=HandledFundamentalDataFcn(src,event)
output=[];

msgs=src.FundamentalMessages;
if (msgs.Count==0) 
    
    return;
end

assignin('base','fundamentalmsg',msgs.Item(0).Data.char); 
end