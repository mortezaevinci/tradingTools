function output=HandledTickPriceFcn(src,event)
try
  while (src.TickPriceAvailable())
           
                etp = src.TickPriceDQ();
                if (~isempty(etp))
           
                row=etp.tickPriceMessage.RequestId-src.TICK_ID_BASE;
                col=1+etp.tickPriceMessage.Field;
                
                               
               % disp(['TICK ' etp.dateTime.ToString().char ':' IBApi.TickType.getField(etp.tickPriceMessage.Field).char ' = ' num2str(etp.tickPriceMessage.Price) ' reqid=' num2str(etp.tickPriceMessage.RequestId)]);

                evalin('base',['ibticks(' num2str(row) ',' num2str(col) ')=' num2str(etp.tickPriceMessage.Price) ';']);
                
                end
  end
  
catch exception
    
    exception
    
end

end