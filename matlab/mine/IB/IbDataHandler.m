classdef IbDataHandler < handle
    properties
        IbErrorSummary
        historicalData;
        historicalTicksLast;
        historicalTickBidAsk;
        contractDetails;
        reqid;
        interruptIsDone;
        marketData; %(ignored, doing raw)is a struct.symbol.timetable of all tickers (datetime,tick index)
        marketDataUpdate;
        processedData;
        processFunctions;
        historicalFarmOk;
        marketFarmOk;
        ApiOk;
        LastError;
        cycleRemainder;
        signalQ; %this better be a class as well, as we need to update it in different place
        %queue of signals (symbol, buy/sell ,qty, etc, etc)
        interruptDoneList; % interruptIsDone should happen through this one instead. Would be a list of associated intr
    end
    methods
        function h = IbDataHandler()
            h.ResetBase();
            h.ResetMarketData();
            h.historicalFarmOk=0;
            h.marketFarmOk=0;
            h.ApiOk=0;
            h.cycleRemainder=10000;
            h.historicalData=[];
            h.historicalTicksLast=[];
            h.historicalTickBidAsk=[];
        end
        
        function ResetMarketData(h)
            h.marketData=[];
            h.marketDataUpdate=[];
        end
        
        function SetMarketData(h,noContracts,noData)
            h.marketData=zeros(noContracts,noData);
            h.marketDataUpdate=datetime(zeros(noContracts,noData),0,0);
        end
        
        function ResetBase(h)
            h.ResetIbErrorSummary();
            h.reqid=0;
            h.historicalData=[];
            h.interruptIsDone=0;
            h.interruptDoneList=zeros(1,100);
            h.contractDetails=struct();
            h.LastError=0;
            h.historicalTicksLast=[];
            h.historicalTickBidAsk=[];
        end
        
        function ResetInterrupt(h,name)
            h.SetInterruptTo(name,0);
        end
        
        function SetInterrupt(h,name)
            h.SetInterruptTo(name,1);
        end
        
        function SetInterruptTo(h,name,val)
            switch name
                case 'historicaldata'
                    h.interruptDoneList(1)=val;
                    h.interruptIsDone=val; % for legacy support, only use interruptDoneList
                case 'conid'
                    h.interruptDoneList(2)=val;
                case 'contractdetails'
                    h.interruptDoneList(3)=val;
                case 'historicaltickslast'
                    h.interruptDoneList(4)=val;
                case 'historicaltickbidask'
                    h.interruptDoneList(5)=val;
            end
        end
        
        function intr=Interrupt(h,name)
            switch name
                case 'historicaldata'
                    intr=h.interruptDoneList(1);
                case 'conid'
                    intr=h.interruptDoneList(2);
                case 'contractdetails'
                    intr=h.interruptDoneList(3);
                case 'historicaltickslast'
                    intr=h.interruptDoneList(4);
                case 'historicaltickbidask'
                    intr=h.interruptDoneList(5);
            end
        end
        
        function ResetIbErrorSummary(h)
            h.IbErrorSummary=newIbErrorSummary();
            h.IbErrorSummary.MajorErrorsList=[];
        end
        
        
        function SetProcessFunctions(h,noContracts,functions)
            h.processFunctions=functions;
            h.processedData=zeros(noContracts,numel(functions));
        end
        
        function ResolvedContractsReadyFcn(h,src,event)
            h.interruptDoneList(2)=1;
            
        end
        
        function HandledTickPriceFcn(h,src,event)
            try
                while (src.TickPriceAvailable())
                    
                    etp = src.TickPriceDQ();
                    if (~isempty(etp))
                        
                        rowcycled=etp.tickPriceMessage.RequestId-src.TICK_ID_BASE;
                        row=rem(rowcycled,h.cycleRemainder);
                        col=1+etp.tickPriceMessage.Field;
                        h.marketData(row,col)=etp.tickPriceMessage.Price;
                        h.marketDateUpdate(row,col)=datetime();
                        for j=1:numel(h.processFunctions)
                            h.processedData(row,j)=h.processFunctions{j}(h.processedData(row,j),h.marketData(row,:));
                        end
                        
                    end
                end
                
            catch exception
                dumpReport('error.log', exception)
            end
            
        end
        
        function HandledTickSizeFcn(h,src,event)
            try
                while (src.TickSizeAvailable())
                    
                    etp = src.TickSizeDQ();
                    if (~isempty(etp))
                        
                        rowcycled=etp.tickSizeMessage.RequestId-src.TICK_ID_BASE;
                        row=rem(rowcycled,h.cycleRemainder);
                        col=1+etp.tickSizeMessage.Field;
                        h.marketData(row,col)=etp.tickSizeMessage.Size;
                        h.marketDataUpdate(row,col)=datetime();
                    end
                end
                
            catch exception
                dumpReport('error.log', exception)
            end
            
        end
        
        function HandledContractDetailsFcn(h,src,event)
            try
                ms=src.ContractDetailsMessages;
                
                for i=0:ms.Count-1
                    m=ms.Item(i);
                    disp([m.ContractDetails.Contract.Symbol.char '@' m.ContractDetails.Contract.PrimaryExch.char]);
                    
                    h.contractDetails=IbContractDetails2Mat(m.ContractDetails);
                    h.SetInterrupt('contractdetails');
                end
            catch exception
                disp(['Grabbing ContractDetails error.' exception.message]);
                dumpReport('error.log', exception)
            end
            
        end
        
        function HandledHistoricalDataEnd_getarray_Fcn(h,src,event)
            
            try
                %disp(src.InvalidSerialRequest);
                iscorrect=src.InvalidSerialRequest==0;
                cnt=src.HistoricalDataMessages.Count;
                
                if (iscorrect==1)
                    for i=[1:(cnt/30):cnt-1 cnt-1]
                        if (h.reqid~=src.HistoricalDataMessages.Item(i).RequestId)
                            iscorrect=0;
                            
                            break;
                        end
                    end
                end
                
                if (iscorrect==1)
                    disp(['(C)processing ' num2str(cnt) ' historical data...']);
                    
                    att=src.HistoricalDataArray.cell;
                    att=att(~cellfun('isempty',att));
                    atm=vertcat(att{:});
                    if (isempty(atm))
                        return;
                    end
                    
                    Date=datetime(atm(:,1),'ConvertFrom','posixtime','TimeZone','America/New_York');
                    h.historicalData=table(Date,atm(:,2),atm(:,3),atm(:,4),atm(:,5),atm(:,6),'VariableNames',{'Date','Open','High','Low','Close','Volume'});
                    disp(['setting historical data...']);
                    
                else
                    %disp(['reqid to be:' num2str(reqid) ' reqid returned:' num2str(src.HistoricalDataMessages.Item(1).RequestId)]);
                    h.historicalData=[];
                    disp('invalid request ids found');
                end
                
            catch exception
                dumpReport('error.log', exception)
            end
            h.interruptIsDone=1;
            h.SetInterrupt('historicaldata');
        end
        
        function HandledHistoricalTickBidAskFcn(h,src,event)
            
            try
                
                while (src.HistoricalTickBidAskAvailable())
                    
                    etp = src.HistoricalTickBidAskDQ();
                    if (~isempty(etp))
                        
                        if (h.reqid==etp.ReqId)
                            t = table(datetime(etp.Time,'ConvertFrom','posixtime','TimeZone','America/New_York'),...
                                etp.PriceBid,etp.SizeBid,...
                                etp.PriceAsk,etp.SizeAsk,...
                                'VariableNames',...
                                {'Date',...
                                'PriceBid','SizeBid',...
                                'PriceAsk','SizeAsk'});

                                h.historicalTickBidAsk = [h.historicalTickBidAsk;t];

                        else
                            h.historicalTickBidAsk=[];
                            disp('Reuqest id not found');
                        end
                        
                        
                    end
                end
                
            catch exception
                dumpReport('error.log', exception)
            end
            h.SetInterrupt('historicaltickbidask');
        end
        
        function HandledHistoricalTicksLastFcn(h,src,event)
            
            try
                cnt=src.HistoricalTicksLastMessages.Count;
                
                for i=0:cnt-1
                    if (h.reqid==src.HistoricalTicksLastMessages.Item(i).ReqId)
                        iscorrect=1;
                        %select the array message we want
                        msg = src.HistoricalTicksLastMessages.Item(i);
                        break;
                    end
                end
                
                if (iscorrect==1)
                    cnt = msg.Ticks.Length;
                    disp(['(C)processing ' num2str(cnt) ' historical ticks last...']);
                    
                    if (cnt == 0)
                        return;
                    end
                    
                    for i=1:cnt
                        tick=msg.Ticks(i);
                        
                        sc = tick.SpecialConditions;
                        if (~isempty(sc))
                            sc = sc.string;
                        else
                            sc = "";
                        end
                        
                        ex = tick.SpecialConditions;
                        if (~isempty(ex))
                            ex = ex.string;
                        else
                            ex = "";
                        end
                        
                        t = table(datetime(tick.Time,'ConvertFrom','posixtime','TimeZone','America/New_York'),...
                            tick.TickAttribLast.PastLimit,tick.TickAttribLast.Unreported,...
                            tick.Price,tick.Size,ex,sc,...
                            'VariableNames', {'Date','PastLimit','Unreported','Price','Size','Exchange','SpecialConditions'});
                        if (i~=1)
                            h.historicalTicksLast(i,:) = t;
                        else
                            h.historicalTicksLast = t;
                        end
                        
                    end
                    
                else
                    h.historicalTicksLast=[];
                    disp('Reuqest id not found');
                end
                
            catch exception
                dumpReport('error.log', exception)
            end
            disp('Processed');
            h.SetInterrupt('historicaltickslast');
        end
        
        function HandledErrorFcn(h,src,event)
            try
                while(src.ErrorAvailable())
                    m=src.ErrorDQ();
                    if (isempty(m))
                        continue;
                    end
                    h.LastError=m.ErrorCode;
                    disp(['(C)' num2str(m.ErrorCode) ':' m.Message.char]);
                    
                    if (m.ErrorCode==2106)
                        h.historicalFarmOk=1;
                        h.ApiOk=1;
                    end
                    if (m.ErrorCode==2107)
                        h.historicalFarmOk=2;
                        h.ApiOk=1;
                    end
                    if (m.ErrorCode==2105)
                        h.historicalFarmOk=0;
                    end
                    if (m.ErrorCode==2103)
                        h.marketFarmOk=0;
                    end
                    if (m.ErrorCode==2104)
                        h.marketFarmOk=1;
                        h.ApiOk=1;
                    end
                    if (m.ErrorCode==2108)
                        h.marketFarmOk=2;
                        h.ApiOk=1;
                    end
                    
                    
                    if (m.ErrorCode==2157)
                        h.ApiOk=0;
                    end
                    if (m.ErrorCode==2158)
                        h.ApiOk=1;
                    end
                    
                    if (m.ErrorCode==430 ...
                            || m.ErrorCode==162 ...
                            || m.ErrorCode==165 ...
                            || m.ErrorCode==200 ...
                            || m.ErrorCode==100 ...
                            || m.ErrorCode==321 ...
                            || m.ErrorCode==2105 ...
                            || m.ErrorCode==504 ...
                            || m.ErrorCode==1100 ...
                            || m.ErrorCode==2105)
                        h.IbErrorSummary.Major=1;
                        h.IbErrorSummary.MajorErrorsList=[h.IbErrorSummary.MajorErrorsList m.ErrorCode];
                    end
                    
                    if (m.ErrorCode==100 || m.ErrorCode==2105 ...
                            || m.ErrorCode==527 ...
                            || m.ErrorCode==504 ...
                            || m.ErrorCode>500 || m.ErrorCode==1100 || m.ErrorCode==2105)
                        h.IbErrorSummary.TWS=1;
                        % src.Disconnect();
                        % src.Connect();
                    end
                    
                    if (m.ErrorCode==504)
                        h.IbErrorSummary.Connection=1;
                    end
                    
                    if (m.ErrorCode == 101 || m.ErrorCode == 102)
                        h.IbErrorSummary.MarketData=1;
                    end
                    
                    if (m.ErrorCode >= 103 && m.ErrorCode <=122 ...
                            || m.ErrorCode >= 125 && m.ErrorCode <=161 )
                        h.IbErrorSummary.Order=1;
                    end
                    
                    if (m.ErrorCode==430 || m.ErrorCode==165 ...
                            )
                        h.IbErrorSummary.Symbol=1;
                        
                    end
                    % 162 is a special case, it's text actually changes
                    % need to only filter if it says, no subscription permission
                    % "No market data permissions"
                    if ((m.ErrorCode==162 && contains(m.Message.char,'No market data permissions')) ...
                            ||  m.ErrorCode==200 ...
                            )
                        h.IbErrorSummary.Exchange=1;
                        %h.IbErrorSummary.Symbol=1;
                    end
                end
            catch exception
                dumpReport('error.log', exception)
            end
        end
    end
end