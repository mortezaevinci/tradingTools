% pre-orders approach
% we have contract triggers
% We have an IBCD template (load it and fill it basically)
% for each contractTrigger
% Read template
% Set quantities of ALL orders to int(accountRisk/entrylevel)
base='Z:\My files\Project trading\traderdata\data_other\IB\';
conidmapfn=[base 'conids.mat'];
date0='2020-12-27';
tradedate='2020-12-28';

placeorders=1;

datef=['d' date0(1:4) date0(6:7) date0(9:10)];

ibtradedate=datestr(datetime(tradedate),'yyyymmdd');
firstorder=0;
base_profiling='Z:\My files\Project trading\traderdata\algotrading\autoswing\triggers\';
ctfn=[base_profiling 'contractTriggers' ' ' 'livetraders' ' ' date0 '.mat'];

load(conidmapfn);

IBCDTemplate='Z:\My files\Project trading\traderdata\algotrading\autoswing\trader_live\auto swing order stp lmt template 6.xml';
IBCDLog='Z:\My files\Project trading\traderdata\algotrading\autoswing\trader_live\log\';
ibDataHandler=IbDataHandler;

ib_libraries;
ib_ibWrapperSetup;
events.eventhandlerError= addlistener(ibWrapper,'HandledError',@ibDataHandler.HandledErrorFcn);
events.eventhandlerError= addlistener(ibWrapper,'ResolvedContractsReady',@ibDataHandler.ResolvedContractsReadyFcn);

ports=[4001];
ibClient.ClientId=1999;%floor(rand()*10)+2000;

expectedorders=0;

isconnected=ibConnect(ibWrapper,ports);

cnth=0;
while(ibDataHandler.ApiOk==0)
    disp('Api not connected...');
    pause(0.5);
    cnth=cnth+1;
    if (cnth==10)
        cnth=0;
        %% reconnect
        disp('disconnecting ib...');
        ibWrapper.Disconnect();
        isconnected=ibConnect(ibWrapper,ports);
        
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
        if (contractTriggers.Marked(ci)==2)
            IBCD.loadXML(IBCDTemplate);
            symbol_=cell2mat(contractTriggers.Symbol(ci));
            %% get contract info
            ow=IBCD.orderWatchlists.Item(0);
            cd=ow.contractDefinitions.Item(0);
            cd.contract.Symbol=string(symbol_);
            
            setConId(ibWrapper,cd,ibDataHandler,conIdMap);
            
            
            if (cd.contract.ConId>0)
                initialStop=round(contractTriggers.ThEntryStp(ci)-contractTriggers.ThMAtr(ci),2);
                disp([cd.contract.Symbol.char ' entry=' num2str(contractTriggers.ThEntryStp(ci)) ...
                    ' vol+=' num2str(round(contractTriggers.ThVol(ci))) ...
                    ' stop=' num2str(initialStop) ...
                    ' tgt=' num2str(round(contractTriggers.ThTarget(ci))) ...
                    ]);
                

                
                IBCD.auxAccountInfo.qty=floor(IBCD.auxAccountInfo.accountRisk/contractTriggers.ThEntryStp(ci));
                
                %% fixing parent order
                
                od=ow.orderDefinitions.Item(0);
                %parent order is to be LMT (STP LMT with conditions not
                %possible)
                if (contains(od.order.OrderType.char,'STP'))
                    od.order.AuxPrice=round(contractTriggers.ThEntryStp(ci),2);
                end
                if (contains(od.order.OrderType.char,'LMT'))
                    od.order.LmtPrice=round(contractTriggers.ThEntryLmt(ci),2); %bidasksprd=about 0.1%, but the market may move fast for tracking this
                end
                if (od.order.TotalQuantity==0)
                od.order.TotalQuantity=IBCD.auxAccountInfo.qty;
                end
                % fixing conditions
                for i=0:od.order.Conditions.Count-1
                    if (strcmp(od.order.Conditions.Item(i).Type,"Price"))
                        disp('setting price condition...');
                        %fix PriceCondition
                        od.order.Conditions.Item(i).ConId=rc.ConId;
                        %enter the stp lmt order only if it at some point started
                        %with a price lower (xxxmor, not sure if this gives expected
                        %behaviour)
                        od.order.Conditions.Item(i).Price=round(contractTriggers.ThEntryStp(ci),2);
                    end
                    if (strcmp(od.order.Conditions.Item(i).Type,"Volume"))
                        disp('setting volume condition...');
                        od.order.Conditions.Item(i).ConId=rc.ConId;
                        od.order.Conditions.Item(i).Volume=round(contractTriggers.ThVol(ci));
                    end
                    if (strcmp(od.order.Conditions.Item(i).Type,"Time"))
                        disp('setting time condition...');
                        tempd=od.order.Conditions.Item(0).Time.char;
                        tempd(1:numel(ibtradedate))=ibtradedate;
                        od.order.Conditions.Item(i).Time=string(tempd);
                    end
                end
                if (firstorder==0)
                    firstorder=ibClient.NextOrderId;
                end
                expectedorders=expectedorders+3;
                %place
                if (placeorders==1)
                ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, od.order);
                
                disp(['This order id:' num2str(ibClient.NextOrderId)]);
                od.order.OrderId=ibClient.NextOrderId;
                ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                end
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
                        if (placeorders==1)
                        ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, cod.order);
                        disp(['This order id:' num2str(ibClient.NextOrderId)]);
                        
                        cod.order.OrderId=ibClient.NextOrderId;
                        ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                        end
                    end
                    if (strcmp(cod.name,"trail-bracket") || cod.name=="trail-bracket")
                        % stop trail order
                        
                        cod.order.TotalQuantity=IBCD.auxAccountInfo.qty;
                        cod.order.LmtPrice=0; %once parent is triggered, it is expected that this triggers also at entry trigger. Otherwise, will need to manually set this.
                        cod.order.AuxPrice=round(contractTriggers.ThMAtr(ci),2);
                        lmtprice=round(initialStop/2,2); %ignoring the limit but need to have it for the sake of GTC+RTH
                        
                        cod.order.LmtPriceOffset=round(lmtprice-initialStop,2);
                        cod.order.TrailStopPrice=round(initialStop,2);
                        if (placeorders==1)
                        ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, cod.order);
                        disp(['This order id:' num2str(ibClient.NextOrderId)]);
                        cod.order.OrderId=ibClient.NextOrderId;
                        ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                        end
                    end
                    if (strcmp(cod.name,"stop-bracket") || cod.name=="stop-bracket")
                        % stop trail order
                        %initialStop=contractTriggers.ThEntryStp(ci)-contractTriggers.ThMAtr(ci);
                        cod.order.TotalQuantity=IBCD.auxAccountInfo.qty;
                        cod.order.AuxPrice=round(initialStop,2);
                        
                        cod.order.LmtPrice=round(initialStop*0.8,2); %ignoring the limit but need to have it for the sake of GTC+RTH
                        if (placeorders==1)
                        ibWrapper.ibClient.ClientSocket.placeOrder(ibWrapper.ibClient.NextOrderId, cd.contract, cod.order);
                        disp(['This order id:' num2str(ibClient.NextOrderId)]);
                        cod.order.OrderId=ibClient.NextOrderId;
                        ibWrapper.ibClient.NextOrderId=ibWrapper.ibClient.NextOrderId+1;
                        end
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