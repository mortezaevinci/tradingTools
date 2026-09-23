getdata_IB_generic_bypossibletriggers_config;

load('Z:\My files\Project trading\traderdata\possibletriggers 2020-12-24.mat');

getdata_IB_generic_init;

if (isconnected)
    
    %ibClient.ClientSocket.reqMarketDataType(3); %1 for realtime 2 frozen, 5 delayd frozen, 3 delayed
    %pause(1);
    
    for ptcnt=1:numel(possibletriggers)
        date_=possibletriggers{ptcnt}.EntryDate;
        
        getdata_IB_generic_date;
        try
            contract = genContract([],possibletriggers{ptcnt}.Symbol);
            getdata_IB_generic_contract;
            
        catch exception
            dumpReport('error.log', exception)
        end
        
        if (FS.Stop())
            break;
        end
        
        
        save(fn_skipper,'skipperProfile');
        
        if (FS.Stop())
            break;
        end
        
    end
    
    %% disconnect
    
    ibWrapper.Disconnect();
else
    disp('did not connect');
end

getdata_IB_generic_close;

