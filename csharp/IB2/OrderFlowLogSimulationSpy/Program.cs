using System;
using System.Threading;
using IBApi;
using MHA;

namespace MHA
{
    class Program
    {
        Semaphore _pool_error = new Semaphore(1, 1);
        bool marketDataOK = false;
        BasicLogger basicLogger;
        IBWrapper ibWrapper;
        IBControlDefinition IBCD;
        IBClient ibClient;
        EReaderMonitorSignal signal;
        OrderFlow orderFlow;

        static void Main(string[] args)
        {
            try
            {
                Program p = new Program();

                p.Start();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

        }
             public void Start()
        {
            
            basicLogger = new BasicLogger("orderflow.log");


            IBCD = new IBControlDefinition();
            IBCD.orderWatchlists.Add(new IBControlDefinition.OrderWatchlist());
            IBCD.orderWatchlists[0].contractDefinitions.Add(new ContractDefinition());
            IBCD.orderWatchlists[0].contractDefinitions[0].contract= ContractDefinition.Tools.getGenericContract("SPY");
            IBCD.ClientId = 1000;
            IBCD.port = 4002;
            IBCD.host = "";

            signal = new EReaderMonitorSignal();
            ibClient = new IBClient(signal);
            ibWrapper = new IBWrapper(ibClient, signal, true);

            ibWrapper.ibClient.Error += HandleError;

            ibWrapper.clientId = IBCD.ClientId;
            ibWrapper.allowedPorts = new int[] { IBCD.port };
            ibWrapper.Connect(IBCD.host);
            Console.WriteLine("Connected:{0}", ibWrapper.ibClient.ClientSocket.IsConnected());
            //Thread.Sleep(1000); //intead read from error handling that Api is connected successfully, and farms are availalbe
            DateTime d0 = DateTime.Now;
            while (marketDataOK == false && (DateTime.Now - d0).TotalSeconds < 5)
            {
                Thread.Sleep(50);
            }

            orderFlow = new OrderFlow(ibWrapper, IBCD, 400);
            orderFlow.logSimulation = true;

            orderFlow.Start();

            basicLogger.WriteLine(String.Format("bid\task\tdiff\tddiff"));
            //wait for q, and then save log simulation and leave
            bool qpressed = false;
            byte mcnt = 0;
            long lastdiffsize = 0;
            while (!qpressed)
            {

                mcnt+=64;
                //wirte down stuff?
                Thread.Sleep(20);

                if (mcnt == 0)
                {
                    basicLogger.WriteLine(String.Format("{0}\t{1}\t{2}\t{3}",
                        orderFlow.flowIndicators.totalbid,
                        orderFlow.flowIndicators.totalask, 
                        orderFlow.flowIndicators.diffSize,
                        orderFlow.flowIndicators.diffSize-lastdiffsize));
                    lastdiffsize = orderFlow.flowIndicators.diffSize;

                    try
                    {
                        if (!ibWrapper.ibClient.ClientSocket.IsConnected())
                        {
                            
                            ibWrapper.Connect(IBCD.host);
                           
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
                      
                        if (Console.KeyAvailable)
                        {
                            ConsoleKeyInfo k = Console.ReadKey();
                            if (k.Key == ConsoleKey.Q)
                            {
                                basicLogger.WriteLine("QPRESSED");
                                qpressed = true;
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

                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    basicLogger.WriteLine(ex.Message);
                }


            }

            orderFlow.Stop();
            string fn = String.Format("orderFlowSimulation {0}.bin", DateTime.Now.ToString("yyyy-MM-dd HH_mm"));
            Console.WriteLine(fn);
            orderFlow.orderFlowSimulation.saveBin(fn);

            basicLogger.Close();
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
                if (msg.ErrorCode == 103)
                {
                    ibWrapper.ibClient.ClientSocket.reqIds(-1);
                }

                Console.WriteLine("ERROR RID({0}) CODE{1}:{2}", msg.RequestId, msg.ErrorCode, msg.Message);
                basicLogger.WriteLine(String.Format("ERROR RID({0}) CODE{1}:{2}", msg.RequestId, msg.ErrorCode, msg.Message));
            }
            else
                Console.WriteLine("null error");

        }
    }
}
