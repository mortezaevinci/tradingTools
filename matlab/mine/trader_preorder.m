% pre-orders approach
% we have contract triggers
% We have an IBCD template (load it and fill it basically)
% for each contractTrigger
% Read template
% Set quantities of ALL orders to int(accountRisk/entrylevel)
base='Z:\My files\Project trading\traderdata\data_other\IB\';
conidmapfn=[base 'conids.mat'];
date0='2020-12-29';
datef=['d' date0(1:4) date0(6:7) date0(9:10)];
tradedate='2020-12-30';
ibtradedate=datestr(datetime(tradedate),'yyyymmdd');
firstorder=0;
base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\';
ctfn=[base_profiling 'contractTriggers' ' ' 'premarket1' ' ' date0 '.mat'];
load(conidmapfn);

IBCDTemplate='C:\temp\_results\tradingtools\files\auto swing order lmt template2.xml';
IBCDLog='C:\temp\_results\tradingtools\files\log\';
ibDataHandler=IbDataHandler;

ib_libraries;
ib_ibWrapperSetup;
events.eventhandlerError= addlistener(ibWrapper,'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerError= addlistener(ibWrapper,'ResolvedContractsReady',@ibDataHandler.ResolvedContractsReadyFcn);

ports=[4004];
ibClient.ClientId=100;%floor(rand()*10)+2000;

expectedorders=0;

isconnected=ibConnect(ibWrapper,ports);
pause(1);
cnth=0;
while(ibDataHandler.ApiOk==0)
    disp('Api not connected...');
    pause(1);
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
    IBCD=MHA.IBControlDefinition;
    
    load(ctfn);
    contractTriggers=contractTriggers.(datef);
    nc=size(contractTriggers,1);
    ci=1;
    for ci=1:nc
        if (contractTriggers.Marked(ci)==1)
            IBCD.loadXML(IBCDTemplate);
            symbol_=cell2mat(contractTriggers.Symbol(ci));
            %% get contract info
            ow=IBCD.orderWatchlists.Item(0);
            cd=ow.contractDefinitions.Item(0);
            cd.contract.Symbol=string(symbol_);
            
            if (cd.contract.ConId==0)
                %% setting ConId's
                
                if (isKey(conIdMap,symbol_))
                    cd.contract.ConId=conIdMap(symbol_);
                else
                    
                    
                    ibDataHandler.ResetInterrupt('conid');
                    ibWrapper.getConId(cd);
                    timeout=5;
                    d0=datetime();
                    while (ibDataHandler.Interrupt('conid')==0 && seconds(datetime()-d0)<timeout)
                        pause(0.1);
                    end
                    if (ibWrapper.resolvedContracts.Count==1)
                        rc=ibWrapper.resolvedContracts.Item(0);
                        cd.contract.ConId=rc.ConId;
                    end
                end
            end
            
            
            if (cd.contract.ConId>0)
                disp([cd.contract.Symbol.char ' ' ...
                    num2str(contractTriggers.ThEntryStp(ci)) ' ' ...
                    num2str(round(contractTriggers.ThVol(ci)))]);
                
                
                
                
                IBCD.auxAccountInfo.qty=floor(IBCD.auxAccountInfo.accountRisk/contractTriggers.ThEntryStp(ci));
                
                %% fixing parent order
                
                od=ow.orderDefinitions.Item(0);
                %parent order is to be LMT (STP LMT with conditions not
                %possible)
                %od.order.AuxPrice=round(contractTriggers.ThEntryStp(ci),2);
                od.order.LmtPrice=round(contractTriggers.ThEntryStp(ci)*1.02,2); %bidasksprd=about 0.1%, but the market may move fast for tracking this
                
                od.order.TotalQuantity=IBCD.auxAccountInfo.qty;
                % fixing conditions
                for i=0:od.order.Conditions.Count-1
                    if (strcmp(od.order.Conditions.Item(i).Type,"Price"))
                        
                        %fix PriceCondition
                        od.order.Conditions.Item(i).ConId=cd.contract.ConId;
                        %enter the stp lmt order only if it at some point started
                        %with a price lower (xxxmor, not sure if this gives expected
                        %behaviour)
                        od.order.Conditions.Item(i).Price=round(contractTriggers.ThEntryStp(ci),2);
                    end
                    if (strcmp(od.order.Conditions.Item(i).Type,"Volume"))
                        
                        od.order.Conditions.Item(i).ConId=cd.contract.ConId;
                        od.order.Conditions.Item(i).Volume=round(contractTriggers.ThVol(ci));
                        disp(['Vol condition ' num2str(od.order.Conditions.Item(i).ConId) '@' num2str(od.order.Conditions.Item(i).Volume)]);
                 
                    end
                    if (strcmp(od.order.Conditions.Item(i).Type,"Time"))
                        
                        tempd=od.order.Conditions.Item(0).Time.char;
                        tempd(1:numel(ibtradedate))=ibtradedate;
                        od.order.Conditions.Item(i).Time=string(tempd);
                        disp(['time condition ' od.order.Conditions.Item(i).Time.char]);
                    end
                end
                if (firstorder==0)
                    firstorder=ibClient.NextOrderId;
                end
                expectedorders=expectedorders+3;
                %place
                ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, od.order);
                disp(['This order id:' num2str(ibClient.NextOrderId)]);
                od.order.OrderId=ibClient.NextOrderId;
                ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                pause(0.15); %this is important. Would get into race condition otherwise
                %% fixing child orders
                cods=od.childOrderDefinitions;
                for codi=0:cods.Count-1
                    cod=cods.Item(codi);
                    cod.order.ParentId=od.order.OrderId;
                    if (strcmp(cod.name,"target-bracket") || cod.name=="target-bracket")
                        % target order
                        cod.order.TotalQuantity=IBCD.auxAccountInfo.qty;
                        cod.order.LmtPrice=round(contractTriggers.ThTarget(ci),2);
                        
                        %place
                        ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, cod.order);
                        disp(['This order id:' num2str(ibClient.NextOrderId)]);
                        cod.order.OrderId=ibClient.NextOrderId;
                        ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                    end
                    if (strcmp(cod.name,"trail-bracket") || cod.name=="trail-bracket")
                        % stop trail order
                        initialStop=contractTriggers.ThEntryStp(ci)-contractTriggers.ThTrailAmt(ci);
                        cod.order.TotalQuantity=IBCD.auxAccountInfo.qty;
                        cod.order.LmtPrice=0; %once parent is triggered, it is expected that this triggers also at entry trigger. Otherwise, will need to manually set this.
                        cod.order.AuxPrice=round(contractTriggers.ThTrailAmt(ci),2);
                        
                        lmtprice=round(initialStop*0.9,2); %ignoring the limit but need to have it for the sake of GTC+RTH
                        
                        cod.order.LmtPriceOffset=round(-(lmtprice-initialStop),2);
                        cod.order.TrailStopPrice=round(initialStop,2);
                        ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, cod.order);
                        disp(['This order id:' num2str(ibClient.NextOrderId)]);
                        cod.order.OrderId=ibClient.NextOrderId;
                        ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                    end
                end
                
                exportxml=[IBCDLog cell2mat(contractTriggers.Symbol(ci)) ' ' date0 '.xml'];
                IBCD.saveXML(string(exportxml));
                pause(.1);
            else
                disp('Con id not found...');
            end
        end
        
    end
    
else
    disp('ib did not connect');
end
disp('disconnecting...');
ibWrapper.Disconnect();

expectedorders
ibClient.NextOrderId-firstorder