using IBApi;
using IBApi.messages;
using MHA;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net.Mail;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows.Forms;

namespace ConsoleAppManageOrders
{

    class Program
    {
   

        [DllImport("Kernel32")]
        private static extern bool SetConsoleCtrlHandler(SetConsoleCtrlEventHandler handler, bool add);

        private delegate bool SetConsoleCtrlEventHandler(CtrlType sig);
    
    private enum CtrlType
        {
            CTRL_C_EVENT = 0,
            CTRL_BREAK_EVENT = 1,
            CTRL_CLOSE_EVENT = 2,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT = 6
        }
        CultureInfo provider = CultureInfo.InvariantCulture;

        Semaphore _pool_error = new Semaphore(1, 1);

        bool marketDataOK = false;
        TradeExtension.Config config = new TradeExtension.Config();
        IBWrapper ibWrapper;
        IBControlDefinition IBCD=new IBControlDefinition();
        IBClient ibClient;
        EReaderMonitorSignal signal;
        IbTrader ibTrader;
        IBAccountDefinition IBAD=new IBAccountDefinition();
        Thread threadGetPositions;
        Thread threadGetOpenOrders;

        MySmtpClient mySmtpClient;

        BasicLogger basicLogger;
        HashSet<string> reportedOrders = new HashSet<string>();
        const int openOrderReqIntervalBy10 = 2000;
        bool run = true;

        public void LogTick(IBApi.messages.MarketDataMessage msg)
        {

            try
            {
                double val = 0;
                if (msg is TickPriceMessage) val = (msg as TickPriceMessage).Price;
                if (msg is TickSizeMessage) val = (msg as TickSizeMessage).Size;

                if (msg.Field == TickType.VOLUME) val *= 100;

                int rid = ibTrader.AbsoluteToRelativeRequestId(msg);
                string cstr = ContractDefinition.Tools.getLocalSymbol(IBCD.mapReqIdToCd[rid].contract);

                basicLogger.WriteLine(String.Format("({3}:{4}){0}\t{1}={2}", cstr, TickType.getField(msg.Field), val, msg.RequestId, rid));
            }
            catch { }

        }

        public void LogHistorical(IBApi.messages.HistoricalDataMessage msg)
        {
         
            try
            {
                int rid = ibTrader.AbsoluteToRelativeRequestId(msg);
                string cstr = ContractDefinition.Tools.getText(IBCD.mapReqIdToCd[rid].contract);

                basicLogger.WriteLine(String.Format("{0}\tH={1}\tL={2}\tC={3}\tO={4}\tV={5}", cstr, msg.High, msg.Low, msg.Close, msg.Open, msg.Volume));
            }
            catch { }
           
        }

        public void LogPosition(IBApi.messages.PositionMessage msg)
        {
          
            try
            { 
            string cstr = ContractDefinition.Tools.getText(msg.Contract);
            basicLogger.WriteLine(String.Format("pos({0})={1}",cstr,msg.Position));
        }
            catch { }
           
        }

        public void LogOrder(IBApi.messages.OpenOrderMessage msg)
        {
           
            string cstr = ContractDefinition.Tools.uniqueKey(msg.Contract);
            basicLogger.WriteLine(String.Format("****\nOPEN ORDER\n{0}:{1},{2},{3},{4}****", cstr,
                 OrderDefinition.Tools.AccountInfo(msg.Order),
                  OrderDefinition.Tools.MainInfo(msg.Order),
                  OrderDefinition.Tools.TimeInForceInfo(msg.Order),
                  OrderDefinition.Tools.ListConditions(msg.Order)
                  ));
         
        }

        public void LogOrder(IBApi.messages.CompletedOrderMessage msg)
        {

            string cstr = ContractDefinition.Tools.uniqueKey(msg.Contract);
            basicLogger.WriteLine(String.Format("****\nOPEN ORDER\n{0}:{1},{2},{3},{4}****", cstr,
                 OrderDefinition.Tools.AccountInfo(msg.Order),
                  OrderDefinition.Tools.MainInfo(msg.Order),
                  OrderDefinition.Tools.TimeInForceInfo(msg.Order),
                  OrderDefinition.Tools.ListConditions(msg.Order)
                  ));

        }

        public void NotifyOrder(OpenOrderMessage msg)
        {
            EmailOrder(msg);
            ConsoleOrder(msg);
            LogOrder(msg);
        }

        public void NotifyOrder(CompletedOrderMessage msg)
        {
            EmailOrder(msg);
            ConsoleOrder(msg);
            LogOrder(msg);
        }

        public void EmailOrder(OpenOrderMessage msg)
        {
            try
            {
                if (msg.OrderState == null) return;
                if (String.IsNullOrEmpty(msg.OrderState.CompletedStatus)) return;
                if (!msg.OrderState.CompletedStatus.ToLower().Contains("filled")) return;

                //need to find its OrderWatchlist to see if it should notify by email!
                string ckey = ContractDefinition.Tools.uniqueKey(msg.Contract);
                HashSet<IBControlDefinition.OrderWatchlist> ows = IBCD.mapContractKeyToWl[ckey];
                foreach (IBControlDefinition.OrderWatchlist ow in ows)
                {
                    if (!String.IsNullOrEmpty(ow.notificationEmail))
                    {
                        string okey = OrderDefinition.Tools.uniqueKey(msg.Order);
                        if (reportedOrders.Contains(okey)) return;//already email

                        //we should also parse time, and only send recent ones so that a rerun of the program doesn't submit all again!

                        DateTime d0 = DateTime.ParseExact(msg.OrderState.CompletedTime.Substring(0, 17), "yyyyMMdd-HH:mm:ss", provider);
                        if ((DateTime.Now - d0).TotalMilliseconds / 10 < openOrderReqIntervalBy10)
                        {
                            //send email
                            MailAddress toAddress = new MailAddress(ow.notificationEmail);
                            string subject = String.Format("STK:{0} {1} {2}", "filled", msg.Order.Action, msg.Contract.Symbol);
                            string str = OrderDefinition.Tools.MessageOrderDescription(msg.Contract, msg.Order, msg.OrderState);
                            mySmtpClient.Send(toAddress, subject, str);

                        }
                        break; //only do one of ow's

                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

         public void EmailOrder(CompletedOrderMessage msg)
        {
            try
            {
                if (!msg.OrderState.CompletedStatus.ToLower().Contains("filled")) return;

                //need to find its OrderWatchlist to see if it should notify by email!
                string ckey = ContractDefinition.Tools.uniqueKey(msg.Contract);
                if (!IBCD.mapContractKeyToWl.ContainsKey(ckey)) return;
                HashSet<IBControlDefinition.OrderWatchlist> ows = IBCD.mapContractKeyToWl[ckey];
                foreach (IBControlDefinition.OrderWatchlist ow in ows)
                {
                    if (!String.IsNullOrEmpty(ow.notificationEmail))
                    {
                        string okey = OrderDefinition.Tools.uniqueKey(msg.Order);
                        if (reportedOrders.Contains(okey)) return;//already email

                        //we should also parse time, and only send recent ones so that a rerun of the program doesn't submit all again!

                        DateTime d0 = DateTime.ParseExact(msg.OrderState.CompletedTime.Substring(0, 17), "yyyyMMdd-HH:mm:ss", provider);
                        if ((DateTime.Now - d0).TotalMilliseconds / 10 < openOrderReqIntervalBy10)
                        {
                            //send email
                            MailAddress toAddress = new MailAddress(ow.notificationEmail);
                            string subject = String.Format("STK:{0} {1} {2}", "filled", msg.Order.Action, msg.Contract.Symbol);
                            string str = OrderDefinition.Tools.MessageOrderDescription(msg.Contract, msg.Order, msg.OrderState);
                            mySmtpClient.Send(toAddress, subject, str);

                        }
                        break; //only do one of ow's

                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

        private bool consoleCtrlEventHandler(CtrlType signal)
        {
            switch (signal)
            {
                case CtrlType.CTRL_BREAK_EVENT:
                case CtrlType.CTRL_C_EVENT:
                case CtrlType.CTRL_LOGOFF_EVENT:
                case CtrlType.CTRL_SHUTDOWN_EVENT:
                case CtrlType.CTRL_CLOSE_EVENT:
                    run = false;
                    return true;
                default:
                    return false;
            }
        }

        public void ConsoleOrder(IBApi.messages.OpenOrderMessage msg)
        {
          
            string cstr = ContractDefinition.Tools.getText(msg.Contract);
            Console.WriteLine("****\nOPEN ORDER\n{0}:{1},{2},{3},{4}****", cstr,
                 OrderDefinition.Tools.AccountInfo(msg.Order),
                  OrderDefinition.Tools.MainInfo(msg.Order),
                  OrderDefinition.Tools.TimeInForceInfo(msg.Order),
                  OrderDefinition.Tools.ListConditions(msg.Order)
                  );
           
        }

        public void ConsoleOrder(IBApi.messages.CompletedOrderMessage msg)
        {

            string cstr = ContractDefinition.Tools.getText(msg.Contract);
            Console.WriteLine("****\nOPEN ORDER\n{0}:{1},{2},{3},{4}****", cstr,
                 OrderDefinition.Tools.AccountInfo(msg.Order),
                  OrderDefinition.Tools.MainInfo(msg.Order),
                  OrderDefinition.Tools.TimeInForceInfo(msg.Order),
                  OrderDefinition.Tools.ListConditions(msg.Order)
                  );

        }

        public void ConsoleTick(IBApi.messages.MarketDataMessage msg)
        {
            try
            {
                double val = 0;
                if (msg is TickPriceMessage) val = (msg as TickPriceMessage).Price;
                if (msg is TickSizeMessage) val = (msg as TickSizeMessage).Size;

                if (msg.Field == 8) val *= 100;

                int rid = ibTrader.AbsoluteToRelativeRequestId(msg);
                string cstr = ContractDefinition.Tools.getText(IBCD.mapReqIdToCd[rid].contract);

                Console.WriteLine("{0}\t{1}={2}", cstr, TickType.getField(msg.Field), val);
            }
            catch { }
          
        }

        public void ConsoleHistorical(IBApi.messages.HistoricalDataMessage msg)
        {
          
            try
            {
                int rid = ibTrader.AbsoluteToRelativeRequestId(msg);
                string cstr = ContractDefinition.Tools.getText(IBCD.mapReqIdToCd[rid].contract);

                Console.WriteLine("{0}\tH={1}\tL={2}\tC={3}\tO={4}\tV={5}", cstr, msg.High, msg.Low, msg.Close, msg.Open, msg.Volume);
            }
            catch { }
        }


        static void Main(string[] args)
        {
            try
            {
                Program p = new Program();

                string configfilename = null;

                foreach (string arg in args)
                {
                    Console.WriteLine(arg);
                }

                if (args.Count() == 1)
                {
                    configfilename = args[0];
                }

                p.Start(configfilename);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }


    

        public void Start(string configfilename)
        {
            string tradedate = DateTime.Now.ToString("yyyy-MM-dd");
            try
            {
                SetConsoleCtrlHandler(consoleCtrlEventHandler, true);

                Console.WriteLine("CFN:{0}", configfilename);


                if (configfilename != null)
                {
                    try
                    {
                        config.loadXML(configfilename);
                        config.ConfigFilename = configfilename;
                    }
                    catch
                    {
                        Console.Write("Failed config.");
                        Thread.Sleep(5000);
                        return;
                    }
                }
                else
                {
                    Console.Write("No config.");
                    Thread.Sleep(5000);
                    return;
                }
                Console.Write(config.ToString());


                basicLogger = new BasicLogger(config.LogFilename.Replace("{0}",tradedate));

                //init
                Console.WriteLine("Init!");
               
                IBCD.loadXML(config.IBCDOrdersFilename.Replace("{0}", tradedate));
                try
                {
                    System.IO.File.Copy(config.IBCDOrdersFilename.Replace("{0}", tradedate), String.Concat(config.IBCDOrdersFilename.Replace("{0}", tradedate), ".bak_", DateTime.Now.ToString("yyyy-MM-dd_HH_mm")));
                }
                catch { }


                signal = new EReaderMonitorSignal();
                ibClient = new IBClient(signal);

                ibWrapper = new IBWrapper(ibClient, signal, true);
                ibWrapper.ibClient.Error += HandleError;


                ibWrapper.ibClient.Position += LogPosition;
                ibWrapper.ibClient.Position += IBAD.HandlePositionMessage;
                ibWrapper.ibClient.OpenOrder += NotifyOrder;
                ibWrapper.ibClient.OpenOrder += IBAD.HandleOpenOrderMessage;
                ibWrapper.ibClient.CompletedOrder += NotifyOrder;
                ibWrapper.ibClient.NextValidId += HandleNextValidId;
                
               // ibWrapper.ibClient.TickSize += LogTick;
              //  ibWrapper.ibClient.TickPrice += LogTick;
                ibWrapper.ibClient.HistoricalData += LogHistorical;
                // ibWrapper.ibClient.TickSize += ConsoleTick;
                // ibWrapper.ibClient.TickPrice += ConsoleTick;
                // ibWrapper.ibClient.HistoricalData += ConsoleHistorical;

                Console.WriteLine("Connect!");
                ibWrapper.clientId = config.clientid;
                ibWrapper.allowedPorts = new int[] { config.port };
                ibWrapper.Connect(config.host);
                Console.WriteLine("Connected:{0}", ibWrapper.ibClient.ClientSocket.IsConnected());
                //Thread.Sleep(1000); //intead read from error handling that Api is connected successfully, and farms are availalbe
                DateTime d0 = DateTime.Now;
                while (marketDataOK == false && (DateTime.Now - d0).TotalSeconds < 5)
                {
                    Thread.Sleep(50);
                }

                IbSpacer.Init(22);

                mySmtpClient = new MySmtpClient(new MailAddress("freddiejive@gmail.com", "Freddie Jive"), "Tofang22!");

                basicLogger.WriteLine(String.Format("next order id={0}", ibWrapper.ibClient.NextOrderId));

                //just for testin
                //ibWrapper.ibClient.ClientSocket.reqMarketDataType(2);
                //Thread.Sleep(1000);

                threadGetPositions = new Thread(asyncGetPositions);
                threadGetPositions.Start();
                threadGetOpenOrders = new Thread(asyncGetOpenOrders);
                threadGetOpenOrders.Start();
                Thread.Sleep(2000);



                //establish status


                //init management
                Console.WriteLine("Setup trader!");
                ibTrader = new IbTrader(ibWrapper, IBCD, IBAD);
                ibTrader.orderManipulated += HandleOrderManipulated;
                ibTrader.tickRoundComplete += HandleTickRoundComplete;
                ibTrader.threadSetupBurstRequestSnapshot(IbTrader.SetupType.ExternalConditions);
                Console.WriteLine("GO!");



                ibTrader.threadStartBurstRequestSnapshot();

                if (config.simulateOrderAll)
                {
                    foreach (var item in IBCD.mapReqIdToCd)
                    {
                        TickPriceMessage msg = new TickPriceMessage(item.Key + IBWrapper.TICK_ID_BASE, 6, 0.01, new TickAttrib());
                        ibTrader.HandleTickForOrderExternalConditions(msg);
                    }
                }

                bool qpressed = false;
                bool autoshut = false;
                byte mcnt = 0;

                while (!qpressed)
                {

                    mcnt++;
                    //wirte down stuff?
                    Thread.Sleep(20);
                  

                    if (mcnt == 0)
                    {
                        basicLogger.WriteLine("LOOP");
                        if (config.autoShutdown)
                        {
                            try
                            {
                                DateTime ds = DateTime.Parse(config.autoShutdownTime);
                                DateTime dateTimeNY = TimeZoneInfo.ConvertTime(DateTime.Now,
                                TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time"));
                                if (dateTimeNY > ds)
                                {
                                    autoshut = true;
                                    basicLogger.WriteLine("AUTO SHUTDOWN");
                                    break;
                                }
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine(ex.Message);
                                basicLogger.WriteLine(ex.Message);
                            }
                        }

                        try
                        {
                            if (!ibWrapper.ibClient.ClientSocket.IsConnected())
                            {
                                basicLogger.WriteLine("RECONNECT");
                                ibTrader.Pause = true;
                                basicLogger.WriteLine("ibTrader paused");
                                ibWrapper.Connect(config.host);
                                ibTrader.Pause = false;
                                basicLogger.WriteLine("ibTrader resumed");
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.Message);
                            basicLogger.WriteLine(ex.Message);
                        }

                        try
                        {
                            basicLogger.WriteLine("POSITIONS");
                            foreach (KeyValuePair<string, PositionMessage> kv in IBAD.positions)
                            {
                                basicLogger.WriteLine(String.Format("pos({0})={1}", kv.Key, kv.Value.Position));
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.Message);
                            basicLogger.WriteLine(ex.Message);
                        }

                        try
                        {

                            basicLogger.Flush();
                            Console.Write("P({0})", ibTrader.ProcessedReqs);
                            ibTrader.ProcessedReqs = 0;

                            if (Console.KeyAvailable)
                            {
                                ConsoleKeyInfo k = Console.ReadKey();
                                if (k.Key == ConsoleKey.Q)
                                {
                                    basicLogger.WriteLine("QPRESSED");
                                    qpressed = true;
                                }

                                if (k.Key == ConsoleKey.U)
                                {
                                    basicLogger.WriteLine("UPRESSED");
                                    OrderManager.OrderManagerForm om = new OrderManager.OrderManagerForm(ibWrapper, IBAD);
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.Message);
                            basicLogger.WriteLine(ex.Message);
                        }
                    }

                    try
                    {

                        if (Console.KeyAvailable)
                        {
                            ConsoleKeyInfo k = Console.ReadKey();
                            if (k.Key == ConsoleKey.Q)
                            {
                                basicLogger.WriteLine("QPRESSED");
                                qpressed = true;
                            }

                            if (k.Key == ConsoleKey.U)
                            {
                                basicLogger.WriteLine("UPRESSED");
                                OrderManager.OrderManagerForm om = new OrderManager.OrderManagerForm(ibWrapper, IBAD);
                                om.Show();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                        basicLogger.WriteLine(ex.Message);
                    }


                }
                run = false;
                ibTrader.threadStopBurstRequestSnapshot();


                Thread.Sleep(2000);

                if (config.collectTickInfoOnly)

                {
                    Thread.Sleep(9000); //give it 11 (9+2) seconds to retreive all ticks
                }
                //wrap up
                ibTrader.orderManipulated -= HandleOrderManipulated;
                ibTrader.tickRoundComplete -= HandleTickRoundComplete;

                //list positions
                Console.WriteLine("Shutdown...");
                foreach(KeyValuePair<string,PositionMessage> kv in IBAD.positions)
                {
                    basicLogger.WriteLine(String.Format("pos({0})={1}", kv.Key, kv.Value.Position));
                }

                //cancel orders without position

                basicLogger.WriteLine(String.Format("Cancel={0}", config.cancelOrdersWithoutPosition));
                if (autoshut && config.cancelOrdersWithoutPosition)
                {
                    HashSet<OpenOrderMessage> msgs = IBAD.OrdersWithZeroPos();

                    foreach (OpenOrderMessage msg in msgs)
                    {
                        try
                        {
                            if (msg.Order.ClientId == config.clientid && msg.Order.ParentId==0)
                            {
                                Console.WriteLine("cancelling order id {0},{1} for {2}", msg.Order.OrderId,OrderDefinition.Tools.MainInfo(msg.Order),ContractDefinition.Tools.uniqueKey(msg.Contract));
                                basicLogger.WriteLine(String.Format("cancelling order id {0},{1} for {2}", msg.Order.OrderId, OrderDefinition.Tools.MainInfo(msg.Order), ContractDefinition.Tools.uniqueKey(msg.Contract)));
                                IbSpacer.WaitForSpace();
                                ibClient.ClientSocket.cancelOrder(msg.Order.OrderId);
                               
                            }
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("Cancelling error:{0}", ex.Message);
                        }
                    }
                }

                ibWrapper.Disconnect();
                basicLogger.Close();


                IBCD.saveXML(config.IBCDOrdersFilename.Replace("{0}", tradedate));
                // config.saveXML(config.ConfigFilename);

                Console.WriteLine(ibClient.ClientSocket.IsConnected());
            }
            catch (Exception ex)
            {
                Console.WriteLine("{0}\n{1}",ex.Message, ex.StackTrace);
                IBCD.saveXML(config.IBCDOrdersFilename.Replace("{0}", tradedate));
            }

            Console.WriteLine("Press any key to continue...");
            Console.ReadKey();
        }

        private void asyncGetPositions()
        {
            byte cnt = 0;
            while (run)
            {
                if (ibClient.ClientSocket.IsConnected())
                {
                    if (cnt++ == 0)
                    {
                        ibWrapper.CleanUpPositions();
                        IbSpacer.WaitForSpace();
                        ibClient.ClientSocket.reqPositions();
                      
                    }
                    for (int i = 0; i < 10; i++)
                    {
                        Thread.Sleep(1000);
                    }
                }
            }
        }

        private void asyncGetOpenOrders()
        {
            byte cnt = 0;
            while (run)
            {
                if (ibClient.ClientSocket.IsConnected())
                {

                    if (cnt++ == 0)
                    {

                        ibWrapper.CleanUpOrders();
                        IbSpacer.WaitForSpace();
                        ibClient.ClientSocket.reqAllOpenOrders();
                        IbSpacer.WaitForSpace();
                        ibClient.ClientSocket.reqCompletedOrders(false);
                    }
                    for (int i = 0; i < 10; i++)

                    {
                        Thread.Sleep(openOrderReqIntervalBy10);
                    }
                }
            }
        }

        private void HandleNextValidId(ConnectionStatusMessage msg)
        {
            if (msg.IsConnected)
            {
                //api connection is ok
            }
          
        }
        private void HandleOrderManipulated(object sender, IbTrader.ManipulatedOrder mo)
        {
            
         
             string str= String.Format("{0} {1}:,{2},{3},{4}",mo.manipulation.ToString("g"),
                  ContractDefinition.Tools.getText(mo.contract),
                  OrderDefinition.Tools.AccountInfo(mo.order),
                  OrderDefinition.Tools.MainInfo(mo.order),
                  OrderDefinition.Tools.TimeInForceInfo(mo.order),
                  OrderDefinition.Tools.ListConditions(mo.order)
                  );

            Console.WriteLine(str);

            basicLogger.WriteLine(str);


            //send email notification
            if (!String.IsNullOrEmpty( mo.orderWatchlist.notificationEmail) && mo.manipulation == IbTrader.ManipulatedOrder.Manipulation.Submit)
            {

                MailAddress toAddress = new MailAddress(mo.orderWatchlist.notificationEmail, "To Freddie");
               string subject = String.Format("STK:{0} {1} {2}",mo.manipulation.ToString("g"),mo.order.Action,mo.contract.Symbol);
                              mySmtpClient.Send(toAddress, subject, str);
               
            }

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
            //xxxmor, this is important, some notifications should be sent around
            try
            {
                ErrorMessage error = new ErrorMessage(id, errorCode, str);
                HandledError(error);
            }
            catch { }

            _pool_error.Release();
   
        }

        private void HandledError(ErrorMessage msg)
        {
            // Console.WriteLine("errors:{0}",ibWrapper.ErrorMessages.Count);

                //  Console.WriteLine("errors:{0}", ibWrapper.ErrorMessages.Count);
                if (msg != null)
                {
                    if (msg.ErrorCode == 2104)
                        marketDataOK = true;
                if (msg.ErrorCode == 2103)
                {
                   // marketDataOK = false;
                   // ibTrader.Pause = true;
                   // basicLogger.WriteLine("ibTrader paused");
                   // ibWrapper.Disconnect();
                }

                    if (msg.ErrorCode == 601 || msg.ErrorCode == 504)
                {
                    marketDataOK = false;
                    try
                    {
                        //basicLogger.WriteLine("ibTrader paused");
                        //ibTrader.Pause = true;
                        //ibWrapper.Disconnect();
                    }
                    catch { }
                }
                if (msg.ErrorCode ==103)
                {
                    ibWrapper.ibClient.ClientSocket.reqIds(-1);
                }

                int rid=ibTrader==null?0: ibTrader.AbsoluteMarketDataToRelativeRequestId(msg.RequestId);
                string c = "";
                if (rid>0)
                {
                    c = ContractDefinition.Tools.getLocalSymbol(IBCD.mapReqIdToCd[rid].contract);
                }
                    Console.WriteLine("ERROR RID({0}:{3}=>{4}) CODE{1}:{2}", msg.RequestId, msg.ErrorCode, msg.Message,rid,c);
                    basicLogger.WriteLine(String.Format("ERROR RID({0}:{3}=>{4}) CODE{1}:{2}", msg.RequestId, msg.ErrorCode, msg.Message, rid, c));
                }
                else
                    Console.WriteLine("null error");
  
        }

        private void HandleTickRoundComplete(int ucnt)
        {
            Console.WriteLine("{1}: Tick round done {0}!", ucnt,DateTime.Now.ToString("HH:mm:ss"));
            basicLogger.WriteLine(String.Format("{1}: Tick round done {0}!", ucnt, DateTime.Now.ToString("HH:mm:ss")));
            if (config.collectTickInfoOnly)
            {
                run = false;
            }
        }
    }
}

