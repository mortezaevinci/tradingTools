function traderPreorder(base_trader,ports,date0,tradedate,placeorders,section,method,base_template)


base='Z:\My files\Project trading\traderdata\data_other\IB\';
conidmapfn=[base 'conids.mat'];

datef=['d' date0(1:4) date0(6:7) date0(9:10)];

ibtradedate=datestr(datetime(tradedate),'yyyymmdd');
firstorder=0;
sections={'pre','reg'}; % pre hereby refers to extended really
methods{1}={'pre-comprehensive','pre-explosivevol','pre-aggresivevol','pre-xaggresivevol'};
methods{2}={'reg-comprehensive','reg-explosivevol','reg-aggresivevol','reg-xaggresivevol'};
methods{3}={'livetraders-swing'};
base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\';
ctfn=[base_profiling 'contractTriggers' ' ' methods{section}{method} ' ' date0 '.mat'];
load(conidmapfn);



IBCDTemplatefn=[base_trader base_template '.xml'];
IBCDexportfn=[base_trader base_template ' export ' methods{section}{method} ' ' tradedate '.xml'];
IBCDexport_backup_fn=[base_trader 'backup\' base_template ' export ' methods{section}{method} ' ' tradedate '.xml'];

base_log='Z:\My files\Project trading\traderdata\algotrading\autoswing\log\';
logfn=[base_log 'tradelog ' tradedate '.log'];
ibDataHandler=IbDataHandler;

ib_libraries;
ib_ibWrapperSetup;
events.eventhandlerError= addlistener(ibWrapper,'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerError= addlistener(ibWrapper,'ResolvedContractsReady',@ibDataHandler.ResolvedContractsReadyFcn);

if (placeorders)
    ibClient.ClientId=2000;
else
    ibClient.ClientId=floor(rand()*10)+1500;
end

isconnected=ibConnect(ibWrapper,ports);

cnth=0;
d0=datetime();
while(ibDataHandler.ApiOk==0 && seconds(datetime()-d0)<10)
    disp('Api not connected...');
    pause(0.5);
    cnth=cnth+1;
    if (cnth==5)
        cnth=0;
        %% reconnect
        disp('disconnecting ib...');
        ibWrapper.Disconnect();
        isconnected=ibConnect(ibWrapper,ports);
        
    end
end


if (isconnected)
    ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
    IBCDTemplate=MHA.IBControlDefinition;
    IBCDTemplate.loadXML(IBCDTemplatefn);
    
    IBCDOrders=MHA.IBControlDefinition;
    IBCDOrders.loadXML(IBCDTemplatefn);
    IBCDOrders.orderWatchlists.Clear(); % keep everything else from template
    
    load(ctfn);
    contractTriggers=contractTriggers.(datef);
    nc=size(contractTriggers,1);
    ci=1;
    
    FID_log = fopen(logfn,'a+');
    fprintf(FID_log,[datestr(datetime(),'yyyy-mm-dd hh:MM:ss') '\n']);
    fprintf(FID_log,[methods{section}{method} '\n']);
    for ci=1:nc
        if (contractTriggers.Marked(ci)>0)
            IBCDTemplate.loadXML(IBCDTemplatefn); % needed so that ow is copied by value
            symbol_=cell2mat(contractTriggers.Symbol(ci));
            %% get contract info
            ow=IBCDTemplate.orderWatchlists.Item(0);
            cd=ow.contractDefinitions.Item(0);
            cd.contract.Symbol=string(symbol_);
            cd.marked=true;
            
            cd.contract.Symbol=string(symbol_);
            
            
            setConId(ibWrapper,cd,ibDataHandler,conIdMap);
            %             if (cd.contract.ConId==0)
            %                 %% setting ConId's
            %
            %                 if (isKey(conIdMap,symbol_))
            %                     cd.contract.ConId=conIdMap(symbol_);
            %                 else
            %
            %
            %                     ibDataHandler.ResetInterrupt('conid');
            %                     ibWrapper.getConId(cd);
            %                     timeout=5;
            %                     d0=datetime();
            %                     while (ibDataHandler.Interrupt('conid')==0 && seconds(datetime()-d0)<timeout)
            %                         pause(0.1);
            %                     end
            %                     if (ibWrapper.resolvedContracts.Count==1)
            %                         rc=ibWrapper.resolvedContracts.Item(0);
            %                         cd.contract.ConId=rc.ConId;
            %                     end
            %                 end
            %             end
            %
            
            if (cd.contract.ConId>0)
                %                 disp([cd.contract.Symbol.char ' ' ...
                %                     num2str(contractTriggers.ThEntryStp(ci)) ' ' ...
                %                     num2str(round(contractTriggers.ThVol(ci)))]);
                
                initialStop=round(contractTriggers.ThEntryStp(ci)-contractTriggers.ThTrailAmt(ci),2);
                fprintf(FID_log,"%s:\tStp=%g\tEntry Stp-Lmt=%g-%g\tTarget=%g\t@Vol=%d\t@VolRate(1-2min)=%d\n",...
                    cd.contract.Symbol.char,...
                    initialStop,...
                    round(contractTriggers.ThEntryStp(ci),2),...
                    round(contractTriggers.ThEntryLmt(ci),2),...
                    round(contractTriggers.ThTarget(ci),2),...
                    round(contractTriggers.ThVol(ci),0),...
                    round(contractTriggers.ThVolRate(ci),0)...
                    );
                
                fprintf("%s:\tStp=%g\tEntry Stp-Lmt=%g-%g\tTarget=%g\t@Vol=%d\t@VolRate(1-2min)=%d\n",...
                    cd.contract.Symbol.char,...
                    initialStop,...
                    round(contractTriggers.ThEntryStp(ci),2),...
                    round(contractTriggers.ThEntryLmt(ci),2),...
                    round(contractTriggers.ThTarget(ci),2),...
                    round(contractTriggers.ThVol(ci),0),...
                    round(contractTriggers.ThVolRate(ci),0)...
                    );
                
                IBCDTemplate.auxAccountInfo.qty=floor(IBCDTemplate.auxAccountInfo.accountRisk/contractTriggers.ThEntryStp(ci));
                
                %% fixing parent order
                
                od=ow.orderDefinitions.Item(0);
                
                tempd=od.MarketStartDatetime.ToString("yyyy-MM-dd HH:mm:ss").char;
                tempd(1:numel(tradedate))=tradedate;
                od.MarketStartDatetime=System.DateTime.Parse(string(tempd));
                
                tempd=od.MarketStartDatetime.ToString("yyyy-MM-dd HH:mm:ss").char;
                tempd(1:numel(tradedate))=tradedate;
                od.MarketEndDatetime=System.DateTime.Parse(string(tempd));
                
                
                %parent order is to be LMT (STP LMT with conditions not
                %possible)
                if (contains(od.order.OrderType.char,"STP"))
                od.order.AuxPrice=round(contractTriggers.ThEntryStp(ci),2);
                end
                if (contains(od.order.OrderType.char,"LMT"))
                od.order.LmtPrice=round(contractTriggers.ThEntryLmt(ci),2); %bidasksprd=about 0.1%, but the market may move fast for tracking this
                end
                if (od.order.TotalQuantity==0)
                    od.order.TotalQuantity=IBCDTemplate.auxAccountInfo.qty;
                end
                % fixing conditions
                for i=0:od.order.Conditions.Count-1
                    if (strcmp(od.order.Conditions.Item(i).Type,"Price"))
                        
                        %fix PriceCondition
                        od.order.Conditions.Item(i).ConId=cd.contract.ConId;
                        %enter the stp lmt order only if it at some point started
                        %with a price lower (xxxmor, not sure if this gives expected
                        %behaviour)
                        od.order.Conditions.Item(i).Price=round(contractTriggers.ThEntryStp(ci),2);
                        disp(['Price condition ' num2str(od.order.Conditions.Item(i).ConId) '@' num2str(od.order.Conditions.Item(i).Price)]);
                        
                    end
                    if (strcmp(od.order.Conditions.Item(i).Type,"Volume"))
                        
                        od.order.Conditions.Item(i).ConId=cd.contract.ConId;
                        od.order.Conditions.Item(i).Volume=round(contractTriggers.ThVol(ci));
                        disp(['Vol condition ' num2str(od.order.Conditions.Item(i).ConId) '@' num2str(od.order.Conditions.Item(i).Volume)]);
                        
                    end
                    if (strcmp(od.order.Conditions.Item(i).Type,"Time"))
                        
                        tempd=od.order.Conditions.Item(i).Time.char;
                        tempd(1:numel(ibtradedate))=ibtradedate;
                        od.order.Conditions.Item(i).Time=string(tempd);
                        disp(['time condition ' od.order.Conditions.Item(i).Time.char]);
                    end
                end
                
                %% fix external conditions
                
                fixExternalConditions(ibWrapper,ibDataHandler,od,cd,contractTriggers,ci,conIdMap,tradedate);
                
                %place
                if (placeorders)
                    ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, od.order);
                    disp(['This order id:' num2str(ibClient.NextOrderId)]);
                    od.order.OrderId=ibClient.NextOrderId;
                    ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                    pause(0.2); %this is important. Would get into race condition otherwise
                end
                %% fixing child orders
                cods=od.childOrderDefinitions;
                for codi=0:cods.Count-1
                    cod=cods.Item(codi);
                    cod.order.ParentId=od.order.OrderId;
                    if (strcmp(cod.name,"target-bracket") || cod.name=="target-bracket")
                        % target order
                        if (cod.order.TotalQuantity==0)
                            cod.order.TotalQuantity=IBCDTemplate.auxAccountInfo.qty;
                        end
                        cod.order.LmtPrice=round(contractTriggers.ThTarget(ci),2);
                        
                        fixExternalConditions(ibWrapper,ibDataHandler,cod,contractTriggers,ci,conIdMap,tradedate);
                        
                        %place
                        if (placeorders)
                            ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, cod.order);
                            disp(['This order id:' num2str(ibClient.NextOrderId)]);
                            cod.order.OrderId=ibClient.NextOrderId;
                            ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                        end
                    end
                    if (strcmp(cod.name.char,"trail-bracket") || cod.name=="trail-bracket")
                        % stop trail order
                        initialStop=contractTriggers.ThEntryStp(ci)-contractTriggers.ThTrailAmt(ci);
                        if (strcmp(cod.order.Action.char,"SELL"))
                            initiallmt=initialStop*0.9;
                        else
                            initiallmt=initialStop*1.1; 
                        end
                        if (cod.order.TotalQuantity==0)
                            cod.order.TotalQuantity=IBCDTemplate.auxAccountInfo.qty;
                        end
                        cod.order.LmtPrice=0; %once parent is triggered, it is expected that this triggers also at entry trigger. Otherwise, will need to manually set this.
                        cod.order.AuxPrice=round(contractTriggers.ThTrailAmt(ci),2);
                        
                        lmtprice=round(initiallmt,2); %ignoring the limit but need to have it for the sake of GTC+RTH
                        
                        cod.order.LmtPriceOffset=round(-(lmtprice-initialStop),2);
                        cod.order.TrailStopPrice=round(initialStop,2);
                        
                        fixExternalConditions(ibWrapper,ibDataHandler,cod,contractTriggers,ci,conIdMap,tradedate);
                        
                        if (placeorders)
                            ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, cod.order);
                            disp(['This order id:' num2str(ibClient.NextOrderId)]);
                            cod.order.OrderId=ibClient.NextOrderId;
                            ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                        end
                    end
                    if (strcmp(cod.name.char,"stop-bracket") || cod.name=="stop-bracket")
                        % stop order
                        initialStop=contractTriggers.ThEntryStp(ci)-contractTriggers.ThTrailAmt(ci);
                        if (strcmp(cod.order.Action.char,"SELL"))
                            initiallmt=initialStop*0.9;
                        else
                            initiallmt=initialStop*1.1; 
                        end
                            
                            
                        if (cod.order.TotalQuantity==0)
                        cod.order.TotalQuantity=IBCDTemplate.auxAccountInfo.qty;
                        end
                        cod.order.AuxPrice=round(initialStop,2);
                        
                        cod.order.LmtPrice=round(initiallmt,2); %ignoring the limit but need to have it for the sake of GTC+RTH

                        fixExternalConditions(ibWrapper,ibDataHandler,cod,contractTriggers,ci,conIdMap,tradedate);
                        
                        if (placeorders)
                            ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, cod.order);
                            disp(['This order id:' num2str(ibClient.NextOrderId)]);
                            cod.order.OrderId=ibClient.NextOrderId;
                            ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                        end
                    end
                end
                
                %exportxml=[IBCDTemplateLog cell2mat(contractTriggers.Symbol(ci)) ' ' date0 '.xml'];
                %IBCDTemplate.saveXML(string(exportxml));
                IBCDOrders.orderWatchlists.Add(ow);
                pause(.1);
            else
                disp('Con id not found...');
            end
        end
        
    end
    fclose(FID_log);
    IBCDOrders.saveXML(IBCDexportfn);
    IBCDOrders.saveXML(IBCDexport_backup_fn);
else
    disp('ib did not connect');
end
disp('disconnecting...');
ibWrapper.Disconnect();

end