using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MHA;
using IBApi;
using System.Threading;
using IBApi.messages;

namespace LogOrders
{
    class Program
    {

        Semaphore _pool_error = new Semaphore(1, 1);

        bool marketDataOK = false;
        TradeExtension.Config config = new TradeExtension.Config();
        IBWrapper ibWrapper;
        IBClient ibClient;
        EReaderMonitorSignal signal;
        IBAccountDefinition IBAD;

        static void Main(string[] args)
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

        public void Start(string configfilename)
        {
           
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
                    return;
                }
            }
            else
            {
                Console.Write("No config.");
                return;
            }
            Console.Write(config.ToString());


            //init
            Console.WriteLine("Init!");
            IBAD = new IBAccountDefinition();

            signal = new EReaderMonitorSignal();
            ibClient = new IBClient(signal);

            ibWrapper = new IBWrapper(ibClient, signal, true);
            ibWrapper.ibClient.Error += HandleError;
            ibWrapper.ibClient.Position += IBAD.HandlePositionMessage;
            ibWrapper.ibClient.OpenOrder += IBAD.HandleOpenOrderMessage;
            ibWrapper.ibClient.CompletedOrder += IBAD.HandleCompletedOrderMessage;
            ibWrapper.ibClient.ExecDetails += IBAD.HandleExecutions;
            ibWrapper.ibClient.UpdatePortfolio += IBAD.HandlePortFolio;
            ibWrapper.ibClient.ManagedAccounts += IBAD.HandleManagedAccounts;

            ibWrapper.ibClient.CommissionReport += commissionReport => IBAD.HandleComissions(new IBApi.messages.CommissionMessage(commissionReport));

            Console.WriteLine("Connect!");
            ibWrapper.clientId = config.clientid;
            ibWrapper.allowedPorts = new int[] { config.port };
            ibWrapper.Connect(config.host);

            //Thread.Sleep(1000); //intead read from error handling that Api is connected successfully, and farms are availalbe
            DateTime d0 = DateTime.Now;
            while (marketDataOK == false && (DateTime.Now - d0).TotalSeconds < 5)
            {
                Thread.Sleep(50);
            }

            ibClient.ClientSocket.reqManagedAccts();
            Thread.Sleep(2000);

            foreach (string acct in IBAD.managedAccounts.ManagedAccounts)
            {
                ibClient.ClientSocket.reqAccountUpdates(true, acct);
            }


            ibClient.ClientSocket.reqPositions();
            ibClient.ClientSocket.reqAllOpenOrders();
            ibClient.ClientSocket.reqCompletedOrders(false);

            ExecutionFilter execFilter = new ExecutionFilter();
            execFilter.ClientId = 0;
            execFilter.AcctCode = "";
            execFilter.Time = "";
            execFilter.Symbol = "";
            execFilter.SecType = "";
            execFilter.Exchange = "";
            execFilter.Side = "";

            ibClient.ClientSocket.reqExecutions(1, execFilter);
            

            Thread.Sleep(20000);

            ibWrapper.Disconnect();

            string date0 = DateTime.Now.ToString("yyyy-MM-dd");
            string basename = String.Concat("Orders ", date0);
           
            IBAD.saveCompletedOrdersCSV(String.Concat(config.DumpDirectory, "Completed", basename, ".csv"));
            IBAD.saveCompletedOrdersXML(String.Concat(config.DumpDirectory, "Completed", basename, ".xml"));
            IBAD.saveOpenOrdersCSV(String.Concat(config.DumpDirectory, "Open", basename, ".csv"));
            IBAD.saveOpenOrdersXML(String.Concat(config.DumpDirectory, "Open", basename, ".xml"));
            IBAD.saveExecutionsCSV(String.Concat(config.DumpDirectory, "Execution", basename, ".csv"));
            IBAD.savePortfolioCSV(String.Concat(config.DumpDirectory, "Portfolio", basename, ".csv"));
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
                    marketDataOK = false;

                Console.WriteLine("ERROR REQID({0}) CODE{1}:{2}", msg.RequestId, msg.ErrorCode, msg.Message);
            }
            else
                Console.WriteLine("null error");

        }
    }
}
