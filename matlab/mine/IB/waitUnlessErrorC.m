
function skippedbyerror=waitUnlessErrorC(ibWrapper,ibDataHandler,timeout)
skippedbyerror=0; % or by requestended
if (nargin<2)
    timeout=10;
end
if (ibWrapper.RequestEnded == false)
fprintf('ibWrapper...');   
end
dt0=datetime();
while (ibWrapper.RequestEnded == false)
                       
             if (ibDataHandler.IbErrorSummary.Major>0)
                 skippedbyerror=1;
                 break;
             end
             

              dt1=datetime();
              if (seconds(dt1-dt0)>timeout)
                  skippedbyerror=0;
                  break;
              else
               if (~ibWrapper.ibClient.ClientSocket.IsConnected())
                   'not connected';
                   break;
               end
              end
            

              pause(.05);
                        
  end
   fprintf('>');    
end