using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using IBApi;
using System.Threading;
using IBApi.messages;
using MHA;
using System.Xml.Serialization;

namespace IBApi
{
    public partial class Form1 : Form
    {
  
        protected int currentTicker = 1;
        protected int currentTickbytick = 1;
        /*
        public const int HISTORICAL_ID_BASE = 30000000;
        private const int ACCOUNT_ID_BASE = 50000000;
        public const int TICK_ID_BASE = 10000000;
        private const int ACCOUNT_SUMMARY_ID = ACCOUNT_ID_BASE + 1;
        private const string ACCOUNT_SUMMARY_TAGS = "AccountType,NetLiquidation,TotalCashValue,SettledCash,AccruedCash,BuyingPower,EquityWithLoanValue,PreviousEquityWithLoanValue,"
             + "GrossPositionValue,ReqTEquity,ReqTMargin,SMA,InitMarginReq,MaintMarginReq,AvailableFunds,ExcessLiquidity,Cushion,FullInitMarginReq,FullMaintMarginReq,FullAvailableFunds,"
             + "FullExcessLiquidity,LookAheadNextChange,LookAheadInitMarginReq ,LookAheadMaintMarginReq,LookAheadAvailableFunds,LookAheadExcessLiquidity,HighestSeverity,DayTradesRemaining,Leverage";
             */



        MHA.IBControlDefinition IBCD;

        private EReaderMonitorSignal signal = new EReaderMonitorSignal();
        IBClient ibClient;
        IBWrapper ibWrapper;
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            int clientid = 3;
            string host = "";
            int port = Int32.Parse(TB_port.Text);
            /*
            ibClient.ClientSocket.eConnect(host, port, ibClient.ClientId);

             var reader = new EReader(ibClient.ClientSocket, signal);

             reader.Start();

            signalThread = new Thread(() => { while (ibClient.ClientSocket.IsConnected()) { signal.waitForSignal(); reader.processMsgs(); } }) { IsBackground = true };
            signalThread.Start();
            */
            ibWrapper.clientId = clientid;
            ibWrapper.allowedPorts = new int[] { port };
            ibWrapper.Connect(host);

            Console.WriteLine(ibClient.ClientSocket.IsConnected());
            
           // ibClient.ClientSocket.reqMarketDataType(2);
        //    Thread.Sleep(1500);

           // Console.WriteLine("marketdatatype:{0}", ibWrapper.MarketDataType);

        }

        private void waitUnlessError()
        {
            while (ibWrapper.RequestEnded == false)
            {

                foreach (ErrorMessage em in ibWrapper.ErrorMessages)
                {
                    Console.WriteLine("{0}:{1}-{2}", em.RequestId, em.ErrorCode, em.Message);
                    if (true)//em.ErrorCode != 2106)
                    {
                        break;
                    }
                }
                ibWrapper.ErrorMessages.Clear();

                Thread.Sleep(100);
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            ibWrapper.CleanUpErrors();

            ibClient.ClientSocket.reqAccountSummary(IBWrapper.ACCOUNT_SUMMARY_ID, "All", IBWrapper.ACCOUNT_SUMMARY_TAGS);

            //  new Thread(() => {

            waitUnlessError();


            foreach (AccountSummaryMessage m in ibWrapper.SummaryMessages)
            {
                Console.WriteLine(m.Account);
                Console.WriteLine(m.Tag);
                Console.WriteLine(m.Value);
            }

        //}).Start();
        }

        private void button4_Click(object sender, EventArgs e)
        {

            //ibClient.ClientSocket.eDisconnect();
            ibWrapper.Disconnect();

            Console.WriteLine(ibClient.ClientSocket.IsConnected());
        }

        private void handledScannerData(object sender, EventArgs e)
        {

        }

            private void handledScannerDataEnd(object sender, EventArgs e)
        {
            foreach(ScannerMessage msg in ibWrapper.ScannerMessages)
            {
                Console.WriteLine(msg.ContractDetails.Contract.Symbol);
            }
        }

            private void handlemarketdatatype(object sender, EventArgs e)
        {
            Console.WriteLine("marketdata type by handler:{0}", ibWrapper.MarketDataType);
        }

        private void handledfundamentaldata(object sender,EventArgs e)
        {
            if (ibWrapper.FundamentalMessages.Count == 0) return;
            Console.WriteLine(ibWrapper.FundamentalMessages[0].Data);
        }

        private void handledtick(object sender, EventArgs e)
        {
            while (ibWrapper.TickPriceAvailable())
            {
                IBWrapper.ExtendedTickPriceMessage etp = ibWrapper.TickPriceDQ();
                if (etp != null)
                {
                    Console.WriteLine("{0}: ID={3} {1}={2}", etp.dateTime, TickType.getField(etp.tickPriceMessage.Field), etp.tickPriceMessage.Price, etp.tickPriceMessage.RequestId);
                }
            }
        }

        private void handledtickbytickalllast(object sender, EventArgs e)
        {
            while (ibWrapper.TickByTickAllLastAvailable())
            {
                TickByTickAllLastMessage etp = ibWrapper.TickByTickAllLastDQ();
                if (etp != null)
                {
                    //Console.WriteLine("{0}: ID={1} type(2=block)", etp.Time, TickType.getField(etp.), etp.tickPriceMessage.Price, etp.tickPriceMessage.RequestId);
                    Console.WriteLine("Tick-By-Tick. Request Id: {0}, TickType: {1}, Time: {2}, Price: {3}, Size: {4}, Exchange: {5}, Special Conditions: {6}, PastLimit: {7}, Unreported: {8}",
    etp.ReqId, etp.TickType == 1 ? "Last" : "AllLast", Util.UnixSecondsToString(etp.Time, "yyyyMMdd-HH:mm:ss zzz"), etp.Price, etp.Size, etp.Exchange, etp.SpecialConditions, etp.TickAttribLast.PastLimit, etp.TickAttribLast.Unreported);
                }
            }
        }



        private void handledtickbytickbidask(object sender, EventArgs e)
        {
            while (ibWrapper.TickByTickBidAskAvailable())
            {
                TickByTickBidAskMessage etp = ibWrapper.TickByTickBidAskDQ();
                if (etp != null)
                {
                    Console.WriteLine("Tick-By-Tick. Request Id: {0}, TickType: BidAsk, Time: {1}, BidPrice: {2}, AskPrice: {3}, BidSize: {4}, AskSize: {5}, BidPastLow: {6}, AskPastHigh: {7}",
        etp.ReqId, Util.UnixSecondsToString(etp.Time, "yyyyMMdd-HH:mm:ss zzz"), etp.BidPrice, etp.AskPrice, etp.BidSize, etp.AskSize, etp.TickAttribBidAsk.BidPastLow, etp.TickAttribBidAsk.AskPastHigh);
                }
            }
        }

        private void handledtickbytickmidpoint(object sender, EventArgs e)
        {
            while (ibWrapper.TickByTickMidPointAvailable())
            {
                TickByTickMidPointMessage etp = ibWrapper.TickByTickMidPointDQ();
                if (etp != null)
                {
                    //Console.WriteLine("{0}: ID={1} type(2=block)", etp.Time, TickType.getField(etp.), etp.tickPriceMessage.Price, etp.tickPriceMessage.RequestId);
                    Console.WriteLine("Tick-By-Tick. Request Id: {0}, TickType: MidPoint, Time: {1}, MidPoint: {2}",
        etp.ReqId, Util.UnixSecondsToString(etp.Time, "yyyyMMdd-HH:mm:ss zzz"), etp.MidPoint);
                }
            }
        }

        void HandleError(int id, int errorCode, string str, Exception ex)
        {
            Console.WriteLine("ERROR:{0}-{1}", errorCode.ToString(), str);


        }

        private void HandledError(object sender, EventArgs e)
        {
           // Console.WriteLine("errors:{0}",ibWrapper.ErrorMessages.Count);
            while (ibWrapper.ErrorAvailable())
            {
              //  Console.WriteLine("errors:{0}", ibWrapper.ErrorMessages.Count);
                ErrorMessage msg = ibWrapper.ErrorDQ();
                if (msg != null)
                {
                    Console.WriteLine("ERROR ({0}) {1}:{2}", msg.RequestId, msg.ErrorCode, msg.Message);
                }
                else
                    Console.WriteLine("null error");
            }
        }


        private void handleHistoricalTicksLast(object sender, EventArgs e)
        {
            Console.WriteLine("historical ticks last {0},{1}", ibWrapper.InvalidSerialRequest, ibWrapper.HistoricalTicksLastMessages.Count);
            foreach(HistoricalTicksLastMessage m in ibWrapper.HistoricalTicksLastMessages)
            {
                Console.WriteLine("{0}", m.Ticks.Count());
            }
        }

        private void handledHistoryEnd(object sender, EventArgs e)
        {

            Console.WriteLine("hisotrical data end {0},{1}", ibWrapper.InvalidSerialRequest, ibWrapper.HistoricalDataArray.Length);
        }
        private void button3_Click(object sender, EventArgs e)
        {


            ibClient = new IBClient(signal);

            ibWrapper = new IBWrapper(ibClient,signal);
            ibWrapper.HandledTickPrice += handledtick;
            ibWrapper.HandledFundamentaldData += handledfundamentaldata;
            ibWrapper.HandledMarketDataType += handlemarketdatatype;

            ibWrapper.HandledTickByTickAllLast += handledtickbytickalllast;
            ibWrapper.HandledTickByTickBidAsk += handledtickbytickbidask;
            ibWrapper.HandledScannerData += handledScannerData;
            ibWrapper.HandledScannerDataEnd += handledScannerDataEnd;
            ibWrapper.HandledError += HandledError;
            ibWrapper.HandledHistoricalDataEnd += handledHistoryEnd;
          
            ibWrapper.HandledHistoricalTicksLast += handleHistoricalTicksLast;

            /*
            new Thread(() =>
            {
                while (ibWrapper.ibClient.ClientSocket.IsConnected() == false)
                {
                    foreach (ErrorMessage em in ibWrapper.ErrorMessages)
                    {
                        Console.WriteLine("{0}:{1}", em.RequestId, em.Message);
                    }

                    ibWrapper.CleanUpErrors();
                    Thread.Sleep(100);
                }
            }).Start();
            */
        }

        private void button5_Click(object sender, EventArgs e)
        {
            ibWrapper.CleanUpSummary();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            getopenorders();
        }

        public void getopenorders()
        {
            ibWrapper.CleanUpOrders();
            ibClient.ClientSocket.reqAllOpenOrders();

            waitUnlessError();

            foreach (OpenOrderMessage oom in ibWrapper.OpenOrders)
            {
                Console.WriteLine(String.Concat(oom.Contract.ToString(), " ordered as ", oom.Order.Action, " ", oom.Order.OrderType, " ", oom.Order.LmtPrice, " status ", oom.OrderState));
            }
        }

        private void button7_Click(object sender, EventArgs e)
        {
            ibWrapper.CleanUpOrders();
            ibClient.ClientSocket.reqCompletedOrders(false);

            waitUnlessError();

            foreach (OpenOrderMessage oom in ibWrapper.OpenOrders)
            {
                Console.WriteLine(String.Concat(oom.Contract.ToString(), " ordered as ", oom.Order.Action, " ", oom.Order.OrderType, " ", oom.Order.LmtPrice, " status ", oom.OrderState));
            }
        }


        private void button8_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            DialogResult dr = ofd.ShowDialog();
            if (dr == DialogResult.OK)
            {
                IBCD = new IBControlDefinition();
                IBCD.loadXML(ofd.FileName);

                if (IBCD.orderWatchlists.Count() > 0)
                {
                    Console.WriteLine("IBCD OPENED.");
                }
            }

        }

        private void button9_Click(object sender, EventArgs e)
        {
            int cind = 0;
            int oind = 1;

            Contract contract = IBCD.orderWatchlists[0].contractDefinitions[cind].contract;
            Order order = IBCD.orderWatchlists[0].orderDefinitions[oind].order;
            order.OrderId = 0; //set to new order, my xml is by default 0

            OrderDefinition.Tools.FillAdaptiveParams(order, "Normal"); //Urgent, 

            IBCD.saveXML("backup.xml");

            ibWrapper.CleanUpOrders();

            if (order.OrderId != 0)
            {
                //replace order
                ibClient.ClientSocket.placeOrder(order.OrderId, contract, order);
            }
            else
            {
                //add new order
                ibClient.ClientSocket.placeOrder(ibClient.NextOrderId, contract, order);
                Console.WriteLine("orderid was {0}", ibClient.NextOrderId);
                TB_orderId.Text = ibClient.NextOrderId.ToString();
                ibClient.NextOrderId++;
            }

          
            getopenorders();
        }

        private void button10_Click(object sender, EventArgs e)
        {
            ibWrapper.CleanUpPositions();
            ibClient.ClientSocket.reqPositions();
            waitUnlessError();

            foreach(PositionMessage pm in ibWrapper.PositionMessages)
            {
                Console.WriteLine("{0} avg={1} qty={2}", ContractDefinition.Tools.getText(pm.Contract), pm.AverageCost, pm.Position);                    
            }
        }

        private void button11_Click(object sender, EventArgs e)
        {

            ibClient.ClientSocket.cancelOrder(Int32.Parse(TB_orderId.Text));
            getopenorders();

        }

        private void button12_Click(object sender, EventArgs e)
        {
            Contract contract=ContractDefinition.Tools.getGenericContract("AAPL");

            int nextReqId = IBWrapper.TICK_ID_BASE + (currentTicker++);
            ibClient.ClientSocket.reqMktData(nextReqId, contract, "100,101,225,236,233,578", false, false, new List<TagValue>());
        }

        private void button13_Click(object sender, EventArgs e)
        {
            while (ibWrapper.TickPriceAvailable())
            {
                IBWrapper.ExtendedTickPriceMessage etp= ibWrapper.TickPriceDQ();
                Console.WriteLine("{0}: ID={3} {1}={2}", etp.dateTime, TickType.getField(etp.tickPriceMessage.Field), etp.tickPriceMessage.Price,etp.tickPriceMessage.RequestId);
            }
        }

        private void button14_Click(object sender, EventArgs e)
        {
            ibClient.ClientSocket.cancelMktData(IBWrapper.TICK_ID_BASE +currentTicker);
            currentTicker--;

            ibWrapper.CleanUpTickPrices();
        }

        private void button15_Click(object sender, EventArgs e)
        {
            ibWrapper.CleanUpHistoricalData();
            IBApi.ScannerSubscription ss;

            Contract contract = ContractDefinition.Tools.getGenericContract("AAPL");
            contract.Exchange = "NYSE";
            contract.SecType = "IND";
            contract.Symbol = "TICK-NYSE";

            int reqid = IBWrapper.HISTORICAL_ID_BASE + currentTicker;
            currentTicker++;

            string enddatetime = ""; //empty for most recent when keepuptodate=true... sample 20200615 13:22:00, if goal is to get only historical data, then use end of day time, and keepuptodate=false
            string duration = "1 D";  //S,D,W,M,Y
            string barsize = "1 min";
            int markettimeonly = 1;
                bool keepuptodate = true;
            ibClient.ClientSocket.reqHistoricalData(reqid, contract, enddatetime, duration, barsize, "TRADES", markettimeonly, 1, keepuptodate, new List<TagValue>());
        }

        private void button16_Click(object sender, EventArgs e)
        {
            while (ibWrapper.HistoricalDataAvailable())
            {
                HistoricalDataMessage m = ibWrapper.HistoricalDataDQ();
                if (m != null)
                {
                    Console.WriteLine("{0}: ID={1} OHLCV={2},{3},{4},{5},{6}", m.Date, m.RequestId, m.Open, m.High, m.Low, m.Close, m.Volume * 100);
                }
            }
        }

        private void button17_Click(object sender, EventArgs e)
        {
            Contract contract = ContractDefinition.Tools.getGenericContract("AAPL");
            
            ibClient.ClientSocket.reqContractDetails(IBWrapper.CONTRACT_DETAILS_ID, contract);

        }

        private void button18_Click(object sender, EventArgs e)
        {
            ibWrapper.CleanUpHistoricalData();


            Contract contract = ContractDefinition.Tools.getGenericContract("AAPL");

            int reqid = IBWrapper.HISTORICAL_ID_BASE + currentTicker;
            currentTicker++;

            string enddatetime = ""; //empty for most recent when keepuptodate=true... sample 20200615 13:22:00, if goal is to get only historical data, then use end of day time, and keepuptodate=false
            string duration = "1 Y";  //S,D,W,M,Y
            string barsize = "1 day";
            int markettimeonly = 1;
            bool keepuptodate = false;
            ibClient.ClientSocket.reqHistoricalData(reqid, contract, enddatetime, duration, barsize, "TRADES", markettimeonly, 1, keepuptodate, new List<TagValue>());
        }

        private void button19_Click(object sender, EventArgs e)
        {
            Contract contract = ContractDefinition.Tools.getGenericContract("PINS");

            int nextReqId = currentTickbytick;
            string ticktype = "AllLast"; //Last, AllLast
            ibClient.ClientSocket.reqTickByTickData(nextReqId, contract,ticktype,0,false);
            currentTickbytick++;
            nextReqId = currentTickbytick;
            ticktype = "BidAsk"; //Last, AllLast
            ibClient.ClientSocket.reqTickByTickData(nextReqId, contract, ticktype, 0, false);
            currentTickbytick++;
        }

        private void button20_Click(object sender, EventArgs e)
        {
            currentTickbytick--;
            ibWrapper.ibClient.ClientSocket.cancelTickByTickData(currentTickbytick);
            currentTickbytick--;
            ibWrapper.ibClient.ClientSocket.cancelTickByTickData(currentTickbytick);

        }

        private void button21_Click(object sender, EventArgs e)
        {
            Contract contract = ContractDefinition.Tools.getGenericContract("PINS");

            ibWrapper.reqFundamentalData(contract, "RESC");

            while(ibWrapper.RequestEnded==false)
            {

                Thread.Sleep(50);
                Console.Write("Waiting for requestended...");
            }
        }

        private void B_Scan_Click(object sender, EventArgs e)
        {
            TagValue t1 = new TagValue("usdMarketCapAbove", "10000");
            TagValue t2 = new TagValue("optVolumeAbove", "1000");
            TagValue t3 = new TagValue("avgVolumeAbove", "100000000");
            List<TagValue> TagValues = new List<TagValue> { t1, t2, t3 };

            //Hot US stocks by volume
            ScannerSubscription scanSub = new ScannerSubscription();
            scanSub.Instrument = "STK";
            scanSub.LocationCode = "STK.US.MAJOR";
            scanSub.ScanCode = "HOT_BY_VOLUME";


            ibClient.ClientSocket.reqScannerSubscription(7001, scanSub, null, TagValues);
        }

        private void button22_Click(object sender, EventArgs e)
        {
            ibClient.ClientSocket.cancelScannerSubscription(7001);
        }

        private void button23_Click(object sender, EventArgs e)
        {
            ibWrapper.CleanupHistoricalTick();


            Contract contract = ContractDefinition.Tools.getGenericContract("AAPL");

            int reqid = IBWrapper.HISTORICAL_TICKS_ID_BASE + currentTicker;
            currentTicker++;

            string startdatetime = "20210608 04:00:00"; //empty for most recent when keepuptodate=true... sample 20200615 13:22:00, if goal is to get only historical data, then use end of day time, and keepuptodate=false

            ibWrapper.reqHistoricalTicks(reqid, contract, startdatetime, "", 1000, "TRADES", 1, false, new TagValue[0]);

        }
    }
}
