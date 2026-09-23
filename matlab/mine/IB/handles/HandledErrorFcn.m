function output= HandledErrorFcn(src,object)
IbErrorSummary=evalin('base','IbErrorSummary');
while(1)
    m=src.ErrorDQ();
    if (isempty(m))
        break;
    end
    disp([num2str(m.ErrorCode) ':' m.Message.char]);
    
    if (m.ErrorCode==430 || m.ErrorCode==162 || m.ErrorCode==165 ...
            ||  m.ErrorCode==200||   m.ErrorCode==100 ...
            || m.ErrorCode==2105 || m.ErrorCode==1100 || m.ErrorCode==2105)
        IbErrorSummary.Major=1;
        IbErrorSummary.MajorErrorsList=[IbErrorSummary.MajorErrorsList m.ErrorCode];
    end
    
    if (m.ErrorCode==100 || m.ErrorCode==2105 ...
            || m.ErrorCode==527 ...
            || m.ErrorCode>500 || m.ErrorCode==1100 || m.ErrorCode==2105)
        IbErrorSummary.TWS=1;
        % src.Disconnect();
        % src.Connect();
    end
    
    if (m.ErrorCode == 101 || m.ErrorCode == 102)
        h.IbErrorSummary.MarketData=1;
    end
    
    if (m.ErrorCode >= 103 && m.ErrorCode <=122 ...
            || m.ErrorCode >= 125 && m.ErrorCode <=161 )
        h.IbErrorSummary.Order=1;
    end
    
    if (m.ErrorCode==430 || m.ErrorCode==165 ...
            ||  m.ErrorCode==200 )
        IbErrorSummary.Symbol=1;
        
    end
    % 162 is a special case, it's text actually changes
    % need to only filter if it says, no subscription permission
    % "No market data permissions"
    if (m.ErrorCode==162 && contains(m.Message.char,'No market data permissions'))
        IbErrorSummary.Symbol=1;
    end
    
    assignin('base','IbErrorSummary',IbErrorSummary);
    
end

end