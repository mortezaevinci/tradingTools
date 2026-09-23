using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IBApi.messages;
using IBApi;
using System.Threading;
//using System.Runtime.Remoting.Messaging;
using MHA;
using System.Net.Http.Headers;

namespace IBApi
{
    public class IBWrapper
    {

        public string host = "";
        public int port = 0;
        public int[] allowedPorts;
        public List<Contract> resolvedContracts;

        public int clientId
        {
            get
            {
                return ibClient.ClientId;
            }
            set
            {
                ibClient.ClientId = value;
            }
        }

        public const int HISTORICAL_TICKS_ID_BASE = 80000000;
        public const int HISTORICAL_ID_BASE = 30000000;
        public const int ACCOUNT_ID_BASE = 50000000;
        public const int TICK_ID_BASE = 10000000;
        public const int ACCOUNT_SUMMARY_ID = ACCOUNT_ID_BASE + 1;
        public const string ACCOUNT_SUMMARY_TAGS = "AccountType,NetLiquidation,TotalCashValue,SettledCash,AccruedCash,BuyingPower,EquityWithLoanValue,PreviousEquityWithLoanValue,GrossPositionValue,ReqTEquity,ReqTMargin,SMA,InitMarginReq,MaintMarginReq,AvailableFunds,ExcessLiquidity,Cushion,FullInitMarginReq,FullMaintMarginReq,FullAvailableFunds,FullExcessLiquidity,LookAheadNextChange,LookAheadInitMarginReq ,LookAheadMaintMarginReq,LookAheadAvailableFunds,LookAheadExcessLiquidity,HighestSeverity,DayTradesRemaining,Leverage";
        public const int RT_BARS_ID_BASE = 40000000;
        public const int CONTRACT_ID_BASE = 60000000;
        public const int SCANNER_BASE = 7000;
        public const int CONTRACT_DETAILS_ID = CONTRACT_ID_BASE + 1;
        public const int FUNDAMENTALS_ID = CONTRACT_ID_BASE + 2;
        public const int OPTIONS_ID_BASE = 70000000;
        private const int OPTIONS_DATA_CALL_BASE = OPTIONS_ID_BASE + 100000;
        private const int OPTIONS_DATA_PUT_BASE = OPTIONS_ID_BASE + 200000;
        private const int OPTIONS_EXERCISING_BASE = OPTIONS_ID_BASE + 1000000;

        private static Semaphore _pool_tbt_last = new Semaphore(1, 1);
        private static Semaphore _pool_tbt_bidask = new Semaphore(1, 1);
        private static Semaphore _pool_tbt_midpoint = new Semaphore(1, 1);
        private static Semaphore _pool_historicaldata = new Semaphore(1, 1);
        private static Semaphore _pool_historicaltickend = new Semaphore(1, 1);
        private static Semaphore _pool_historicaltickbidask = new Semaphore(1, 1);
        private static Semaphore _pool_historicaltickslast = new Semaphore(1, 1);
        private static Semaphore _pool_position = new Semaphore(1, 1);
        private static Semaphore _pool_summary = new Semaphore(1, 1);
        private static Semaphore _pool_order = new Semaphore(1, 1);
        private static Semaphore _pool_error = new Semaphore(1, 1);
        private static Semaphore _pool_tickprice = new Semaphore(1, 1);
        private static Semaphore _pool_ticksize = new Semaphore(1, 1);
        private static Semaphore _pool_realtimebar = new Semaphore(1, 1);
        private static Semaphore _pool_optionparameters = new Semaphore(1, 1);
        private static Semaphore _pool_deepbook = new Semaphore(1, 1);
        private static Semaphore _pool_bulletin = new Semaphore(1, 1);
        private static Semaphore _pool_news = new Semaphore(1, 1);
        private static Semaphore _pool_contractdetails = new Semaphore(1, 1);
        private static Semaphore _pool_execution = new Semaphore(1, 1);
        private static Semaphore _pool_scannerdata = new Semaphore(1, 1);

        public void releasePools()
        {
            _pool_historicaldata.Release();
            _pool_position.Release();
            _pool_summary.Release();
            _pool_order.Release();
            _pool_error.Release();
            _pool_tickprice.Release();
            _pool_realtimebar.Release();
            _pool_optionparameters.Release();
            _pool_deepbook.Release();
            _pool_bulletin.Release();
            _pool_news.Release();
            _pool_contractdetails.Release();
            _pool_execution.Release();
            _pool_historicaltickbidask.Release();
            _pool_historicaltickslast.Release();
            _pool_historicaltickend.Release();
    
    
        }

        private int invalidSerialRequest = 0;
        int firstReqId = -1;
        public int InvalidSerialRequest
        {
            get
            {
                return invalidSerialRequest;
            }
        }

        public long currentTime = 0;
        private bool requestEnded = false;

        public class ExtendedTickPriceMessage
        {
            public TickPriceMessage tickPriceMessage;
            public DateTime dateTime;

            public ExtendedTickPriceMessage(DateTime d, TickPriceMessage t)
            {
                dateTime = d;
                tickPriceMessage = t;
            }
        }

        public class ExtendedTickSizeMessage
        {
            public TickSizeMessage tickSizeMessage;
            public DateTime dateTime;

            public ExtendedTickSizeMessage(DateTime d, TickSizeMessage t)
            {
                dateTime = d;
                tickSizeMessage = t;
            }
        }

        public class NewsBulletinMessage
        {
            public int Id = 0;
            public int type;
            public string news;
            public string exchange;
        }

        private SortedList<long, double[]> historicalDataList = new SortedList<long, double[]>();

        EReaderMonitorSignal signal;
        Thread signalThread;
        //back buffers


        private List<FundamentalsMessage> fundamentalMessages = new List<FundamentalsMessage>();
        private List<TickByTickAllLastMessage> tickByTickAllLastMessages = new List<TickByTickAllLastMessage>();
        private List<TickByTickBidAskMessage> tickByTickBidAskMessages = new List<TickByTickBidAskMessage>();
        private List<TickByTickMidPointMessage> tickByTickMidPointMessages = new List<TickByTickMidPointMessage>();
        private List<AccountSummaryMessage> summaryMessages = new List<AccountSummaryMessage>();
        private List<AccountSummaryEndMessage> summaryEndMessages = new List<AccountSummaryEndMessage>();
        private List<PositionMessage> positionMessages = new List<PositionMessage>();
        private List<OpenOrderMessage> openOrderMessages = new List<OpenOrderMessage>();
        private List<CompletedOrderMessage> completedOrderMessages = new List<CompletedOrderMessage>();
        private List<OrderStatusMessage> orderStatusMessages = new List<OrderStatusMessage>();
        private List<ErrorMessage> errorMessages = new List<ErrorMessage>();
        private List<ExtendedTickPriceMessage> extendedTickPriceMessages = new List<ExtendedTickPriceMessage>();
        private List<ExtendedTickSizeMessage> extendedTickSizeMessages = new List<ExtendedTickSizeMessage>();
        private List<HistoricalDataEndMessage> historicalDataEndMessages = new List<HistoricalDataEndMessage>();
        private List<HistoricalDataMessage> historicalDataMessages = new List<HistoricalDataMessage>();

        private List<HistoricalTickBidAskMessage> historicalTickBidAskMessages = new List<HistoricalTickBidAskMessage>();
        private List<HistoricalTicksLastMessage> historicalTicksLastMessages = new List<HistoricalTicksLastMessage>();
        private List<int> historicalTickEndMessages = new List<int>();
        private List<int> historicalTicksEndMessages = new List<int>();

        private List<RealTimeBarMessage> realTimeBarMessages = new List<RealTimeBarMessage>();
        private List<SecurityDefinitionOptionParameterMessage> securityDefinitionOptionParameterMessages = new List<SecurityDefinitionOptionParameterMessage>();
        private List<DeepBookMessage> deepBookMessages = new List<DeepBookMessage>();
        private List<NewsBulletinMessage> newsBulletinMessages = new List<NewsBulletinMessage>();
        private List<HistoricalNewsMessage> historicalNewsMessages = new List<HistoricalNewsMessage>();
        private List<ExecutionMessage> executionMessages = new List<ExecutionMessage>();
        private List<HistoricalNewsEndMessage> historicalNewsEndMessages = new List<HistoricalNewsEndMessage>();
        private List<ContractDetailsMessage> contractDetailsMessages = new List<ContractDetailsMessage>();
        private List<ScannerMessage> scannerMessages = new List<ScannerMessage>();

        //public double[,] historicalBufferData=new double[1500,5]

        private int marketDataType = 0; //realtime default

        public List<ScannerMessage> ScannerMessages
        {
            get { return scannerMessages; }
        }

        public List<FundamentalsMessage> FundamentalMessages
        {
            get { return fundamentalMessages; }
        }

        public List<TickByTickAllLastMessage> TickByTickAllLastMessages
        {
            get { return tickByTickAllLastMessages; }
        }
        public List<TickByTickBidAskMessage> TickByTickBidAskMessages
        {
            get { return tickByTickBidAskMessages; }
        }
        public List<TickByTickMidPointMessage> TickByTickMidPointMessages
        {
            get { return tickByTickMidPointMessages; }
        }

        public List<SecurityDefinitionOptionParameterMessage> SecurityDefinitionOptionParameterMessages
        {
            get { return securityDefinitionOptionParameterMessages; }
        }
        public List<DeepBookMessage> DeepBookMessages
        {
            get { return deepBookMessages; }
        }
        public List<NewsBulletinMessage> NewsBulletinMessages
        {
            get { return newsBulletinMessages; }
        }

        public List<HistoricalNewsMessage> HistoricalNewsMessages
        {
            get { return historicalNewsMessages; }
        }

        public List<ExecutionMessage> ExecutionMessages
        {
            get { return executionMessages; }
        }

        public List<HistoricalNewsEndMessage> HistoricalNewsEndMessages
        {
            get { return historicalNewsEndMessages; }
        }


        public List<ContractDetailsMessage> ContractDetailsMessages
        {
            get { return contractDetailsMessages; }
        }

        public double[][] HistoricalDataArray
        {
            get
            {
                return historicalDataList.Values.ToArray();
            }
        }

        public List<HistoricalDataEndMessage> HistoricalDataEndMessages
        {
            get
            {
                return historicalDataEndMessages;
            }
        }

        public List<HistoricalDataMessage> HistoricalDataMessages
        {
            get
            {
                return historicalDataMessages;
            }
        }

        public List<HistoricalTickBidAskMessage> HistoricalTickBidAskMessages
        {
            get
            {
                return historicalTickBidAskMessages;
            }
        }

        public List<HistoricalTicksLastMessage> HistoricalTicksLastMessages
        {
            get
            {
                return historicalTicksLastMessages;
            }
        }

        public List<int> HistorcalTickEndMessages
        {
            get
            {
                return historicalTickEndMessages;
            }
        }

        public List<int> HistorcalTicksEndMessages
        {
            get
            {
                return historicalTicksEndMessages;
            }
        }

        public List<RealTimeBarMessage> RealTimeBarMessages
        {
            get
            {
                return realTimeBarMessages;
            }
        }

        public int MarketDataType
        {
            get
            {
                return marketDataType;
            }
        }

        public List<ExtendedTickPriceMessage> ExtendedTickPriceMessages
        {
            get
            {
                return extendedTickPriceMessages;
            }
        }

        public List<ExtendedTickSizeMessage> ExtendedTickSizeMessages
        {
            get
            {
                return extendedTickSizeMessages;
            }
        }

        public List<ErrorMessage> ErrorMessages
        {
            get
            {
                return errorMessages;
            }
        }

        public List<OrderStatusMessage> OrderStatusMessages
        {
            get
            {
                return orderStatusMessages;
            }
        }

        public List<CompletedOrderMessage> CompletedOrders
        {
            get
            {
                return completedOrderMessages;
            }
        }
        public List<OpenOrderMessage> OpenOrders
        {
            get
            {
                return openOrderMessages;
            }
        }

        public List<PositionMessage> PositionMessages
        {
            get
            {
                return positionMessages;
            }
        }

        public List<AccountSummaryMessage> SummaryMessages
        {
            get
            {
                return summaryMessages;
            }
        }

        public List<AccountSummaryEndMessage> SummaryEndMessages
        {
            get
            {
                return summaryEndMessages;
            }
        }

        public long CurrentTime
        {
            get
            {
                return currentTime;
            }
            set

            {
                currentTime = value;
            }
        }

        public void CleanUpScannerData()
        {
            scannerMessages.Clear();

            requestEnded = false;
        }

        public void CleanUpFundamentalData()
        {
            fundamentalMessages.Clear();
            requestEnded = false;
        }

        public void CleanUpContractDetails()
        {
            contractDetailsMessages.Clear();
            requestEnded = false;
        }
        public void CleanUpTickPrices()
        {
            extendedTickPriceMessages.Clear();
            requestEnded = false;
        }

        public void CleanUpTickByTick()
        {
            tickByTickAllLastMessages.Clear();
            tickByTickBidAskMessages.Clear();
            tickByTickMidPointMessages.Clear();
            requestEnded = false;
        }


        public void CleanUpMktData()
        {
            extendedTickPriceMessages.Clear();
            extendedTickSizeMessages.Clear();
            requestEnded = false;
        }

        public void CleanUpOrders()
        {
            completedOrderMessages.Clear();
            orderStatusMessages.Clear();
            openOrderMessages.Clear();
            requestEnded = false;
            CleanUpErrors();
        }

        public void CleanUpErrors()
        {
            errorMessages.Clear();


        }

        public void CleanupHistoricalTick()
        {
            historicalTickEndMessages.Clear();
            historicalTicksEndMessages.Clear();
            historicalTicksLastMessages.Clear();
            historicalTickBidAskMessages.Clear();

            firstReqId = -1;
            invalidSerialRequest = 0;
            requestEnded = false;
        }

        public void CleanUpHistoricalData()
        {
            historicalDataMessages.Clear();
            historicalDataList.Clear();
            firstReqId = -1;
            invalidSerialRequest = 0;
            requestEnded = false;
        }

        public void CleanUpHistoricalDataEnd()
        {
            historicalDataEndMessages.Clear();
            firstReqId = -1;
            invalidSerialRequest = 0;
            requestEnded = false;
        }


        public void CleanUpPositions()
        {
            positionMessages.Clear();
            requestEnded = false;
        }

        public void CleanUpSummary()
        {
            CleanUpErrors();
            summaryMessages.Clear();
            summaryEndMessages.Clear();
            requestEnded = false;
        }

        public bool TickByTickAllLastAvailable()
        {
            return (tickByTickAllLastMessages.Count > 0);
        }

        public bool TickByTickBidAskAvailable()
        {
            return (tickByTickBidAskMessages.Count > 0);
        }

        public bool ErrorAvailable()
        {
            _pool_error.WaitOne();
            bool a = errorMessages.Count > 0;
            _pool_error.Release();
            return (a);
        }

        public bool TickByTickMidPointAvailable()
        {
            return (tickByTickMidPointMessages.Count > 0);
        }
        public bool TickPriceAvailable()
        {
            return (extendedTickPriceMessages.Count > 0);
        }

        public bool TickSizeAvailable()
        {
            return (extendedTickSizeMessages.Count > 0);
        }

        public bool HistoricalTickBidAskAvailable()
        {
            return (historicalTickBidAskMessages.Count > 0);
        }

        public bool HistoricalDataAvailable()
        {
            return (historicalDataMessages.Count > 0);
        }

        public bool RealTimeBarsAvailable()
        {
            return (realTimeBarMessages.Count > 0);
        }

        public bool ScannerDataAvailable()
        {
            return (scannerMessages.Count > 0);
        }

        public ScannerMessage ScannerDataDQ()
        {
            ScannerMessage temp=null;
            _pool_scannerdata.WaitOne();
            try
            {
                if (scannerMessages.Count == 0)
                    temp = null;
                else
                {
                    temp = scannerMessages[0];
                    scannerMessages.RemoveAt(0);

                }
            }
            catch { }
            _pool_scannerdata.Release();
            return temp;
        }

        public HistoricalDataMessage HistoricalDataDQ()
        {
            HistoricalDataMessage temp=null;

            _pool_historicaldata.WaitOne();
            try
            {
                if (historicalDataMessages.Count == 0)
                {
                    temp = null;
                }
                else
                {
                    temp = historicalDataMessages[0];

                    historicalDataMessages.RemoveAt(0);
                    historicalDataList.RemoveAt(0);
                }
            }
            catch { }
            _pool_historicaldata.Release();
            return temp;
        }

        public RealTimeBarMessage RealTimeBarDQ()
        {
            RealTimeBarMessage temp=null;

            _pool_realtimebar.WaitOne();
            try
            {
                if (realTimeBarMessages.Count == 0)
                {
                    temp = null;
                }
                else
                {
                    temp = realTimeBarMessages[0];

                    realTimeBarMessages.RemoveAt(0);

                }
            }
            catch { }
            _pool_realtimebar.Release();
            return temp;
        }

        public TickByTickAllLastMessage TickByTickAllLastDQ()
        {
            TickByTickAllLastMessage temp = null;
            _pool_tbt_last.WaitOne();
            try
            {
                if (tickByTickAllLastMessages.Count > 0)
                {
                    temp = tickByTickAllLastMessages[0];

                    tickByTickAllLastMessages.RemoveAt(0);
                }
            }
            catch { }
            _pool_tbt_last.Release();
            return temp;
        }

        public TickByTickBidAskMessage TickByTickBidAskDQ()
        {
            TickByTickBidAskMessage temp = null;
            _pool_tbt_bidask.WaitOne();
            try
            {
                if (tickByTickBidAskMessages.Count > 0)
                {
                    temp = tickByTickBidAskMessages[0];

                    tickByTickBidAskMessages.RemoveAt(0);
                }
            }
            catch { }
            _pool_tbt_bidask.Release();
            return temp;
        }

        public TickByTickMidPointMessage TickByTickMidPointDQ()
        {
            TickByTickMidPointMessage temp = null;
            _pool_tbt_midpoint.WaitOne();
            try
            {
                if (tickByTickMidPointMessages.Count > 0)
                {
                    temp = tickByTickMidPointMessages[0];

                    tickByTickMidPointMessages.RemoveAt(0);
                }
            }
            catch { }
            _pool_tbt_midpoint.Release();
            return temp;
        }

        public ExtendedTickPriceMessage TickPriceDQ()
        {
            ExtendedTickPriceMessage temp = null;
            _pool_tickprice.WaitOne();
            try
            {
                if (extendedTickPriceMessages.Count > 0)
                {
                    temp = extendedTickPriceMessages[0];

                    extendedTickPriceMessages.RemoveAt(0);
                }
            }
            catch { }
            _pool_tickprice.Release();
            return temp;
        }

        public HistoricalTickBidAskMessage HistoricalTickBidAskDQ()
        {
            HistoricalTickBidAskMessage temp = null;
            _pool_historicaltickbidask.WaitOne();
            try
            {
                if (historicalTickBidAskMessages.Count > 0)
                {
                    temp = historicalTickBidAskMessages[0];

                    historicalTickBidAskMessages.RemoveAt(0);
                }
            }
            catch { }
            _pool_historicaltickbidask.Release();
            return temp;
        }

        public ExtendedTickSizeMessage TickSizeDQ()
        {
            ExtendedTickSizeMessage temp = null;
            _pool_ticksize.WaitOne();
            try
            {
                if (extendedTickSizeMessages.Count > 0)
                {
                    temp = extendedTickSizeMessages[0];

                    extendedTickSizeMessages.RemoveAt(0);
                }
            }
            catch { }
            _pool_ticksize.Release();
            return temp;
        }

        public ErrorMessage ErrorDQ()
        {
            ErrorMessage temp = null;
            _pool_error.WaitOne();
            if (errorMessages.Count > 0)
            {
                temp = errorMessages[0];

                errorMessages.RemoveAt(0);
            }

            _pool_error.Release();
            return temp;
        }




        public bool RequestEnded
        {
            get
            {
                return requestEnded;
            }
            set
            {
                requestEnded = value;
            }
        }



        //init
        public IBClient ibClient;


        public IBWrapper(IBClient ibclient, EReaderMonitorSignal _signal,bool ignoreEvents=false)
        {
            ibClient = ibclient;
            signal = _signal;
            if (ignoreEvents==false)
            {
                setEvents();
            }
        }

        public class ErrorEventArgs : System.EventArgs
        {
            public Exception exception;

            public ErrorEventArgs(Exception ex)
            {
                exception = ex;
            }
        }


        public event EventHandler Error;

        public event EventHandler HandledFundamentaldData;
        public event EventHandler HandledTickByTickAllLast;
        public event EventHandler HandledTickByTickBidAsk;
        public event EventHandler HandledTickByTickMidPoint;
        public event EventHandler HandledAccountSummary;
        public event EventHandler HandledAccountSummaryEnd;
        public event EventHandler HandledPosition;
        public event EventHandler HandledPositionEnd;
        public event EventHandler HandledOrderStatus;
        public event EventHandler HandledOpenOrder;
        public event EventHandler HandledCompletedOrder;
        public event EventHandler HandledTickPrice;
        public event EventHandler HandledTickSize;
        public event EventHandler HandledMarketDataType;
        public event EventHandler HandledError;
        public event EventHandler HandledConnectionClose;
        public event EventHandler HandledHistoricalDataUpdate;
        public event EventHandler HandledHistoricalDataEnd;

        public event EventHandler HandledHistoricalTicksLast;
        public event EventHandler HandledHistoricalTickBidAsk;
        public event EventHandler HandledHistoricalTickEnd;
        public event EventHandler HandledHistoricalTicksEnd;

        public event EventHandler HandledRealtimeBar;
        public event EventHandler HandledHistoricalData;
        public event EventHandler HandledContractDetails;
        public event EventHandler HandledContractDetailsEnd;// reqId => UpdateUI(new ContractDetailsEndMessage());
        public event EventHandler HandledExecDetails;
        public event EventHandler HandledExecDetailsEnd;// reqId => addTextToBox("ExecDetailsEnd. " + reqId + "\n");
        public event EventHandler HandledHistoricalNews;
        public event EventHandler HandledHistoricalNewsEnd;
        public event EventHandler HandledSecurityDefinitionOptionParameter;
        public event EventHandler HandledSecurityDefinitionOptionParameterEnd;
        public event EventHandler HandledUpdateMktDepth;
        public event EventHandler HandledUpdateMktDepthL2;
        public event EventHandler HandledUpdateNewsBulletin;// (msgId, msgType, message, origExchange) =>   addTextToBox("News Bulletins. " + msgId + " - Type: " + msgType + ", Message: " + message + ", Exchange of Origin: " + origExchange + "\n");
        public event EventHandler HandledScannerData;
        public event EventHandler HandledScannerDataEnd;

        //other ibWrapper originated events
        public event EventHandler ResolvedContractsReady;

        public void setEvents()
        {
            ibClient.AccountSummary += HandleAccountSummary;
            ibClient.AccountSummaryEnd += HandleAccountSummaryEnd;
            ibClient.Position += HandlePosition;
            ibClient.PositionEnd += HandlePositionEnd;
            ibClient.OrderStatus += HandleOrderStatus;
            ibClient.OpenOrder += HandleOpenOrder;
            ibClient.CompletedOrder += HandleCompletedOrder;
            ibClient.TickPrice += HandleTickPrice;
            ibClient.TickSize += HandleTickSize;
            ibClient.MarketDataType += HandleMarketDataType;
            ibClient.Error += HandleError;
            ibClient.ConnectionClosed += HandleConnectionClose;
            ibClient.CurrentTime += time => currentTime = time;
            ibClient.HistoricalData += HandleHistoricalData;
            ibClient.HistoricalDataUpdate += HandleHistoricalDataUpdate;
            ibClient.HistoricalDataEnd += HandleHistoricalDataEnd;
           
            ibClient.historicalTicksLast += HandleHistoricalTicksLast;
            ibClient.historicalTickBidAsk += HandleHistoricalTickBidAsk;

            ibClient.RealtimeBar += HandleRealtimeBar;
            ibClient.ContractDetails += HandleContractDetails;
            ibClient.ContractDetailsEnd += HandleContractDetailsEnd;// reqId => UpdateUI(new ContractDetailsEndMessage());
            ibClient.ExecDetails += HandleExecDetails;
            ibClient.ExecDetailsEnd += HandleExecDetailsEnd;// reqId => addTextToBox("ExecDetailsEnd. " + reqId + "\n");
            ibClient.HistoricalNews += HandleHistoricalNews;
            ibClient.HistoricalNewsEnd += HandleHistoricalNewsEnd;
            ibClient.SecurityDefinitionOptionParameter += HandleSecurityDefinitionOptionParameter;
            ibClient.SecurityDefinitionOptionParameterEnd += HandleSecurityDefinitionOptionParameterEnd;
            ibClient.UpdateMktDepth += HandleUpdateMktDepth;
            ibClient.UpdateMktDepthL2 += HandleUpdateMktDepthL2;
            ibClient.UpdateNewsBulletin += HandleUpdateNewsBulletin;// (msgId, msgType, message, origExchange) =>   addTextToBox("News Bulletins. " + msgId + " - Type: " + msgType + ", Message: " + message + ", Exchange of Origin: " + origExchange + "\n");
            ibClient.FundamentalData += HandleFundamentalsData;

            ibClient.tickByTickAllLast += HandleTickByTickAllLast;
            ibClient.tickByTickBidAsk += HandleTickByTickBidAsk;
            ibClient.tickByTickMidPoint += HandleTickByTickMidPoint;

            ibClient.ScannerData += HandleScannerData;
            ibClient.ScannerDataEnd += HandleScannerDataEnd;

            ibClient.TickSnapshotEnd += LastRequestEnd;
            ibClient.ContractDetailsEnd += LastRequestEnd;
            ibClient.OpenOrderEnd += LastRequestEnd;
            ibClient.CompletedOrdersEnd += LastRequestEnd;
            ibClient.PositionEnd += LastRequestEnd;
            ibClient.SecurityDefinitionOptionParameterEnd += LastRequestEnd;
            ibClient.ExecDetailsEnd += LastRequestEnd;
            ibClient.HistoricalDataEnd += LastRequestEnd;

        }

        private void HandleScannerDataEnd(int reqid)
        {
            requestEnded = true;
            HandledScannerDataEnd?.Invoke(this, null);
        }

        private void HandleScannerData(ScannerMessage msg)
        {
            _pool_scannerdata.WaitOne();
            try
            {
                scannerMessages.Add(msg);
            }
            catch { }
            _pool_scannerdata.Release();

            HandledScannerData?.Invoke(this, null);
        }

        private void HandleTickByTickAllLast(TickByTickAllLastMessage msg)
        {
            _pool_tbt_last.WaitOne();
            try
            {
                
                tickByTickAllLastMessages.Add(msg);
            }
            catch { }
            _pool_tbt_last.Release();
            HandledTickByTickAllLast?.Invoke(this, null);

        }

        private void HandleTickByTickBidAsk(TickByTickBidAskMessage msg)
        {
            _pool_tbt_bidask.WaitOne();
            try
            {
               
                tickByTickBidAskMessages.Add(msg);
            }
            catch (Exception)
            {

            }
            _pool_tbt_bidask.Release();
            HandledTickByTickBidAsk?.Invoke(this, null);

        }

        private void HandleTickByTickMidPoint(TickByTickMidPointMessage msg)
        {
            _pool_tbt_midpoint.WaitOne();
            try
            {
                tickByTickMidPointMessages.Add(msg);
            }
            catch (Exception)
            {

            }
            _pool_tbt_midpoint.Release();
            HandledTickByTickMidPoint?.Invoke(this, null);

        }

        private void HandleContractDetailsEnd(int msg)
        {
            HandledContractDetailsEnd?.Invoke(this, null);
        }
        private void HandleExecDetails(ExecutionMessage msg)
        {
            _pool_execution.WaitOne();
            try
            {
                executionMessages.Add(msg);
            }
            catch { }
            _pool_execution.Release();
            HandledExecDetails?.Invoke(this, null);
        }
        private void HandleExecDetailsEnd(int msg)
        {
            HandledExecDetailsEnd?.Invoke(this, null);

        }
        private void HandleHistoricalNews(HistoricalNewsMessage msg)
        {
            _pool_news.WaitOne();
            try { 
            historicalNewsMessages.Add(msg);
            }
            catch { }
            _pool_news.Release();
            HandledHistoricalNews?.Invoke(this, null);
        }
        private void HandleHistoricalNewsEnd(HistoricalNewsEndMessage msg)
        {
            historicalNewsEndMessages.Add(msg);
            HandledHistoricalNewsEnd?.Invoke(this, null);
        }

        private void HandleSecurityDefinitionOptionParameterEnd(int id)
        {
            HandledSecurityDefinitionOptionParameterEnd?.Invoke(this, null);
        }

        private void HandleSecurityDefinitionOptionParameter(SecurityDefinitionOptionParameterMessage msg)
        {
            _pool_optionparameters.WaitOne();
            try { 
            securityDefinitionOptionParameterMessages.Add(msg);
            }
            catch { }
            _pool_optionparameters.Release();
            HandledSecurityDefinitionOptionParameter?.Invoke(this, null);
        }

        private void HandleUpdateMktDepth(DeepBookMessage msg)
        {
            _pool_deepbook.WaitOne();
            try{ 
            deepBookMessages.Add(msg);
            }
            catch { }
            _pool_deepbook.Release();
            HandledUpdateMktDepth?.Invoke(this, null);
        }

        private void HandleUpdateMktDepthL2(DeepBookMessage msg)
        {
            _pool_deepbook.WaitOne();
            try { 
            deepBookMessages.Add(msg);
            }
            catch { }
            _pool_deepbook.Release();
            HandledUpdateMktDepthL2?.Invoke(this, null);
        }

        private void HandleFundamentalsData(FundamentalsMessage msg)
        {
            fundamentalMessages.Add(msg);
            try { 
            HandledFundamentaldData?.Invoke(this, null);
            }
            catch { }
            requestEnded = true;
        }

        private void HandleUpdateNewsBulletin(int msgid, int msgtype, string message, string exchange)
        {
            _pool_news.WaitOne();
            try { 
            NewsBulletinMessage m = new NewsBulletinMessage();
            m.Id = msgid;
            m.type = msgtype;
            m.news = message;
            m.exchange = exchange;

            newsBulletinMessages.Add(m);
            }
            catch { }
            _pool_news.Release();
            HandledUpdateNewsBulletin?.Invoke(this, null);
        }

        private void HandleContractDetails(ContractDetailsMessage msg)
        {
            _pool_contractdetails.WaitOne();
            try { 
            contractDetailsMessages.Add(msg);
            }
            catch { }
            _pool_contractdetails.Release();
            HandledContractDetails?.Invoke(this, null);
        }

        private static DateTime ToLocalTime(DateTime utcDateTime, string tzId)
        {
            TimeZoneInfo tz = TimeZoneInfo.FindSystemTimeZoneById(tzId);
            return TimeZoneInfo.ConvertTimeFromUtc(utcDateTime, tz);
        }

        private void addToHistoricalDataList(HistoricalDataMessage msg)
        {
            try
            {
                if (msg != null)
                {
                    bool dateset = false;
                    DateTimeOffset _dateo = DateTimeOffset.Now;
                    try
                    {
                        if (msg.Date.Length == 8)
                        {
                            _dateo = DateTimeOffset.ParseExact(msg.Date, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);
                            dateset = true;
                        }
                        else
                        {
                            _dateo = DateTimeOffset.ParseExact(msg.Date, "yyyyMMdd  HH:mm:ss", System.Globalization.CultureInfo.InvariantCulture);
                            dateset = true;
                        }
                        TimeZoneInfo tz0 = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
                        TimeZoneInfo tz1 = TimeZoneInfo.Local;


                        TimeSpan tso0 = tz0.GetUtcOffset(_dateo);
                        TimeSpan tso1 = tz1.GetUtcOffset(_dateo);


                        _dateo = _dateo.AddHours(-tso0.Hours + tso1.Hours);


                    }
                    catch (Exception ex)
                    {

                        Error?.Invoke(this, new ErrorEventArgs(ex));
                    }

              
                    if (dateset)
                    {
                        long unixTime = _dateo.ToUnixTimeSeconds();


                        if (Double.IsNaN(msg.Open) || unixTime == 0)
                        {

                            Error?.Invoke(this, new ErrorEventArgs(new Exception("isnan or unixTime is zero")));
                        }
                        else
                        {
                            
                            double[] dd = new double[] { (double)unixTime, msg.Open, msg.High, msg.Low, msg.Close, msg.Volume * 100 };
                            if (dd != null)
                            {
                                historicalDataList.Add(unixTime, dd);
                            }
                            else
                            {
                                Error?.Invoke(this, new ErrorEventArgs(new Exception("null dd!")));
                            }
                        }
                    }
                }
                else
                {
                    Error?.Invoke(this, new ErrorEventArgs(new Exception("null msg!")));
                }
            }
            catch (Exception ex)
            {
                //todo
                Error?.Invoke(this, new ErrorEventArgs(new Exception(String.Format("wrapper data list:{0}", ex.Message))));
            }
        }

        private void HandleHistoricalDataUpdate(HistoricalDataMessage msg)
        {
            _pool_historicaldata.WaitOne();
            try { 
            historicalDataMessages.Add(msg);

            if (firstReqId < 0) firstReqId = msg.RequestId;
            if (firstReqId != msg.RequestId) invalidSerialRequest = 1;
            addToHistoricalDataList(msg);
            }
            catch { }
            _pool_historicaldata.Release();
            HandledHistoricalDataUpdate?.Invoke(this, null);
        }
        private void HandleHistoricalDataEnd(HistoricalDataEndMessage msg)
        {
            // gonna need to wait a bit until all dataupdates are actually done
            Thread.Sleep(10);
            _pool_historicaldata.WaitOne();
            try
            {
                historicalDataEndMessages.Add(msg);
                HandledHistoricalDataEnd?.Invoke(this, null);
            }
            catch (Exception ex)
            {
               
                invalidSerialRequest = 1;
            }
            _pool_historicaldata.Release();
        }

        private void HandleHistoricalTickEnd(int reqId)
        {
            // gonna need to wait a bit until all dataupdates are actually done
            Thread.Sleep(10);
            _pool_historicaltickend.WaitOne();
            try
            {
                historicalTickEndMessages.Add(reqId);
                HandledHistoricalTickEnd?.Invoke(this, null);
            }
            catch (Exception ex)
            {

                invalidSerialRequest = 1;
            }
            _pool_historicaltickend.Release();
        }

        private void HandleRealtimeBar(RealTimeBarMessage msg)
        {
            _pool_realtimebar.WaitOne();
            try
            {

                realTimeBarMessages.Add(msg);
                HandledRealtimeBar?.Invoke(this, null);
            }
            catch (Exception ex)
            {
                Error?.Invoke(this, new ErrorEventArgs(new Exception(String.Format("wrapper handle historical:{0}", ex.Message))));
            }
            _pool_realtimebar.Release();
        }


        private void HandleHistoricalTicksLast(HistoricalTicksLastMessage msg)
        {
            _pool_historicaltickslast.WaitOne();
            try
            {
                historicalTicksLastMessages.Add(msg);

            }
            catch { }
            _pool_historicaltickslast.Release();
            requestEnded = true;
            HandledHistoricalTicksLast?.Invoke(this, null);
        }

        private void HandleHistoricalTickBidAsk(HistoricalTickBidAskMessage msg)
        {
            _pool_historicaltickbidask.WaitOne();
            try
            {
                historicalTickBidAskMessages.Add(msg);

            }
            catch { }
            _pool_historicaltickbidask.Release();
            requestEnded = true;
            HandledHistoricalTickBidAsk?.Invoke(this, null);
        }

        private void HandleHistoricalData(HistoricalDataMessage msg)
        {
            _pool_historicaldata.WaitOne();
            try { 
            historicalDataMessages.Add(msg);

            if (firstReqId < 0) firstReqId = msg.RequestId;
            if (firstReqId != msg.RequestId) invalidSerialRequest = 1;
            addToHistoricalDataList(msg);
                //can't handle this fast enough
            }
            catch { }
            _pool_historicaldata.Release();
            HandledHistoricalData?.Invoke(this, null);
        }

        private void HandleMarketDataType(MarketDataTypeMessage message)
        {
            marketDataType = message.MarketDataType;
            HandledMarketDataType?.Invoke(this, null);
        }

        void HandleTickPrice(TickPriceMessage msg)
        {
            _pool_tickprice.WaitOne();
            try { 
            extendedTickPriceMessages.Add(new ExtendedTickPriceMessage(DateTime.Now, msg));
            }
            catch { }
            _pool_tickprice.Release();
            HandledTickPrice?.Invoke(this, null);
        }

        void HandleTickSize(TickSizeMessage msg)
        {
            _pool_ticksize.WaitOne();
            try { 
            extendedTickSizeMessages.Add(new ExtendedTickSizeMessage(DateTime.Now, msg));
            }
            catch { }
            _pool_ticksize.Release();
            HandledTickSize?.Invoke(this, null);
        }

        void HandleError(int id, int errorCode, string str, Exception ex)
        {
            if (ex != null)
            {

                return;
            }

            if (errorCode == 0)
            {
                return;
            }
            if (String.IsNullOrEmpty(str)) return;

            _pool_error.WaitOne();
            try { 
            //xxxmor, this is important, some notifications should be sent around
            ErrorMessage error = new ErrorMessage(id, errorCode, str);
            errorMessages.Add(error);
            }
            catch { }
            _pool_error.Release();
            HandledError?.Invoke(this, null);
        }

        public void HandleConnectionClose()
        {
            //can maybe reconnect?
            HandledConnectionClose?.Invoke(this, null);
        }

        public void HandleOrderStatus(OrderStatusMessage statusmessage)
        {
            _pool_order.WaitOne();
            try { 
            orderStatusMessages.Add(statusmessage);
            }
            catch { }
            _pool_order.Release();
            HandledOrderStatus?.Invoke(this, null);
        }

        public void HandleCompletedOrder(CompletedOrderMessage completedorder)
        {
            _pool_order.WaitOne();
            try { 
            completedOrderMessages.Add(completedorder);
            }
            catch { }
            _pool_order.Release();
            HandledCompletedOrder?.Invoke(this, null);
        }

        public void HandleOpenOrder(OpenOrderMessage openorder)
        {
            _pool_order.WaitOne();
            try { 
            openOrderMessages.Add(openorder);
            }
            catch { }
            _pool_order.Release();
            HandledOpenOrder?.Invoke(this, null);
        }

        public void HandlePositionEnd()
        {

            requestEnded = true;
            HandledPositionEnd?.Invoke(this, null);

        }

        public void HandleAccountSummary(AccountSummaryMessage summarymessage)
        {
            _pool_summary.WaitOne();
            try { 
            summaryMessages.Add(summarymessage.Clone());
            }
            catch { }

            _pool_summary.Release();
            HandledAccountSummary?.Invoke(this, null);
        }

        public void HandleAccountSummaryEnd(AccountSummaryEndMessage message)
        {
            summaryEndMessages.Add(message);
            requestEnded = true;
            HandledAccountSummaryEnd?.Invoke(this, null);
        }


        public void LastRequestEnd()
        {
            requestEnded = true;

        }

        public void LastRequestEnd(object o)
        {
            requestEnded = true;

        }

        public void LastRequestEnd(int i)
        {
            requestEnded = true;

        }


        public void HandlePosition(PositionMessage positionmessage)
        {
            _pool_position.WaitOne();
            try { 
            positionMessages.Add(positionmessage);
            }
            catch { }
            _pool_position.Release();
            HandledPosition?.Invoke(this, null);
        }

        public void Connect(string host)
        {
            this.host = host;
            foreach (int port in allowedPorts)
            {
                ibClient.ClientSocket.eConnect(host, port, ibClient.ClientId);
                if (ibClient.ClientSocket.IsConnected())
                {
                    this.port = port;
                    InitReader();
                    return;
                }
            }
        }

        public void Connect()
        {
            Connect(host);
        }

        private void InitReader()
        {

            var reader = new EReader(ibClient.ClientSocket, signal);
            reader.Start();

            signalThread = new Thread(() => { while (ibClient.ClientSocket.IsConnected()) { signal.waitForSignal(); reader.processMsgs(); } }) { IsBackground = true };
            signalThread.Start();
        }

        public void Connect(string host, int port)
        {
            this.host = host;
            ibClient.ClientSocket.eConnect(host, port, ibClient.ClientId);
            if (ibClient.ClientSocket.IsConnected())
            {
                this.port = port;
                InitReader();
            }
        }

        public void Disconnect()
        {
            ibClient.ClientSocket.eDisconnect();

            signalThread.Join();

        }

        public void reqFundamentalData(Contract contract, string reportType)
        {
            ibClient.ClientSocket.reqFundamentalData(FUNDAMENTALS_ID, contract, reportType, new List<TagValue>());
        }

        public void cancelFundamentalData()
        {
            ibClient.ClientSocket.cancelFundamentalData(FUNDAMENTALS_ID);
        }


        public async void getConId(ContractDefinition cd)
        {
            resolvedContracts = new List<Contract>();
            resolvedContracts.AddRange(await ibClient.ResolveContractAsync(cd.contract.SecType, cd.contract.Symbol, cd.contract.Currency, cd.contract.Exchange));
            int timeout = 2000;
            DateTime dt0 = DateTime.Now;
            while (resolvedContracts.Count == 0 && (DateTime.Now - dt0).TotalMilliseconds < timeout) ;

            if (resolvedContracts.Count > 0)
            {
                //send handledevent
                ResolvedContractsReady?.Invoke(this, null);

            }
        }


        public void reqMktData(int tickerId, Contract contract, string genericTickList, bool snapshot, bool regulatorySnaphsot, TagValue[] mktDataOptions)
        {
            List<TagValue> options = mktDataOptions.ToList();

            ibClient.ClientSocket.reqMktData(tickerId, contract, genericTickList, snapshot, regulatorySnaphsot, options);
        }


        public void reqHistoricalData(int reqId, Contract contract, string enddatetime, string duration, string barsize, string whatToShow, int useRTH, int formatDate, bool keepuptodate, TagValue[] chartOptions)
        {
            List<TagValue> options = chartOptions.ToList();
            ibClient.ClientSocket.reqHistoricalData(reqId, contract, enddatetime, duration, barsize, whatToShow, useRTH, 1, keepuptodate, options);
        }

        public void reqHistoricalTicks(int reqId, Contract contract, string startDateTime, string endDateTime, int numberOfTicks, string whatToShow, int useRth, bool ignoreSize, TagValue[] tagOptions)
        {
            List<TagValue> options = tagOptions.ToList();
            ibClient.ClientSocket.reqHistoricalTicks(reqId, contract, startDateTime, endDateTime, numberOfTicks, whatToShow, useRth, ignoreSize, options);
        }

        public void reqRealTimrBars(int reqid, Contract contract, int barsize, string whatToShow, int useRTH, TagValue[] chartOptions)
        {
            List<TagValue> options = chartOptions.ToList();
            ibClient.ClientSocket.reqRealTimeBars(reqid, contract, barsize, whatToShow, useRTH == 1 ? true : false, options);
        }



    }
}
