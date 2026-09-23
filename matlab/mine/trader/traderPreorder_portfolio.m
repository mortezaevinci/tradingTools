function traderPreorder(ports,date0,tradedate,placeorders,section,method,base_template)


base='Z:\My files\Project trading\traderdata\data_other\IB\';
conidmapfn=[base 'conids.mat'];
load(conidmapfn);
base_trader='Z:\My files\Project trading\traderdata\algotrading\autoswing\trader\';
IBCDTemplatefn=[base_trader base_template '.xml'];
IBCDexportfn=[base_trader base_template ' export ' 'portfolio' '.xml'];
IBCDexport_backup_fn=[base_trader base_template ' export ' 'portfolio' ' backup ' date0 '.xml'];

IBCDLog='Z:\My files\Project trading\repo\csharp\files\log\';

ibDataHandler=IbDataHandler;

ib_libraries;
ib_ibWrapperSetup;
events.eventhandlerError= addlistener(ibWrapper,'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerError= addlistener(ibWrapper,'ResolvedContractsReady',@ibDataHandler.ResolvedContractsReadyFcn);

if (placeorders)
ibClient.ClientId=0;
else
ibClient.ClientId=floor(rand()*10)+1500;
end

isconnected=ibConnect(ibWrapper,ports);

cnth=0;
d0=datetime();
while(ibDataHandler.ApiOk==0 && seconds(datetime()-d0)<5)
    disp('Api not connected...');
    pause(0.5);
    cnth=cnth+1;
    if (cnth==50)
        cnth=0;
        %% reconnect
        disp('disconnecting ib...');
        ibWrapper.Disconnect();
        isconnected=ibConnect(ibWrapper,port);
        
    end
end


if (isconnected)
    ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
    IBCDTemplate=MHA.IBControlDefinition;
    IBCDTemplate.loadXML(IBCDTemplatefn);
    
    IBCDOrders=MHA.IBControlDefinition;
    IBCDOrders.loadXML(IBCDTemplatefn);
    IBCDOrders.orderWatchlists.Clear(); % keep everything else from template
    
    contracts_ib_major;
    ci=1;
    nc=numel(contracts);
    for ci=1:nc
        if (true)
            IBCDTemplate.loadXML(IBCDTemplatefn); % needed so that ow is copied by value
            symbol_=(contracts{ci}.Symbol)
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

                
                IBCDTemplate.auxAccountInfo.qty=1;
                
                %% fixing parent order
                
                od=ow.orderDefinitions.Item(0);

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
                           end
                    if (strcmp(od.order.Conditions.Item(i).Type,"Volume"))
                        
                        od.order.Conditions.Item(i).ConId=cd.contract.ConId;
                          
                    end
                    if (strcmp(od.order.Conditions.Item(i).Type,"Time"))
                        
                        tempd=od.order.Conditions.Item(i).Time.char;
                        tempd(1:numel(ibtradedate))=ibtradedate;
                        od.order.Conditions.Item(i).Time=string(tempd);
                        disp(['time condition ' od.order.Conditions.Item(i).Time.char]);
                    end
                end
                
                %% fix external conditions
                
             
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
                        if (cod.order.TotalQuantity)
                        cod.order.TotalQuantity=IBCDTemplate.auxAccountInfo.qty;
                        end
                       
                        
                        %place
                        if (placeorders)
                            ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, cod.order);
                            disp(['This order id:' num2str(ibClient.NextOrderId)]);
                            cod.order.OrderId=ibClient.NextOrderId;
                            ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                        end
                    end
                    if (strcmp(cod.name,"trail-bracket") || cod.name=="trail-bracket")
                        % stop trail order
                        initialStop=0;
                        if (cod.order.TotalQuantity==0)
                        cod.order.TotalQuantity=IBCDTemplate.auxAccountInfo.qty;
                        end
                        cod.order.LmtPrice=0; %once parent is triggered, it is expected that this triggers also at entry trigger. Otherwise, will need to manually set this.
                        cod.order.AuxPrice=round(contractTriggers.ThTrailAmt(ci),2);
                        
                        lmtprice=round(initialStop*0.9,2); %ignoring the limit but need to have it for the sake of GTC+RTH
                        
                        cod.order.LmtPriceOffset=round(-(lmtprice-initialStop),2);
                        cod.order.TrailStopPrice=round(initialStop,2);
                       
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
    IBCDOrders.saveXML(IBCDexportfn);
    IBCDOrders.saveXML(IBCDexport_backup_fn);
else
    disp('ib did not connect');
end
disp('disconnecting...');
ibWrapper.Disconnect();

end