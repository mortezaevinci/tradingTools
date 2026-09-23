getdata_IB_generic_init;
checkhs=0;

shutdown=0;
nc=numel(contracts);
if (isconnected)
    
    %ibClient.ClientSocket.reqMarketDataType(3); %1 for realtime 2 frozen, 5 delayd frozen, 3 delayed
    %pause(1);
    
    for date_=dateslist
        if (isbusday(date_))
            getdata_IB_generic_date;
            for si=1:nc
                try
                    contract= contracts{si};
                    getdata_IB_generic_contract;
                    
                    
                catch exception
                    dumpReport('error.log', exception)
                end
                
                if (FS.Stop())
                    shutdown=1;
                    break;
                end
                ddt=datetime()-datetime('today');
                if (hours(ddt)>shutdownddt0 && hours(ddt)<shutdownddt1)
                    shutdown=1;
                    break;
                end
            end
        end
        
        save(fn_skipper,'skipperProfile');
        
        if (shutdown)
            break;
        end
    end
    
    %% disconnect
    disp('disconnecting ib...');
    ibWrapper.Disconnect();
else
    disp('did not connect');
end

getdata_IB_generic_close;


