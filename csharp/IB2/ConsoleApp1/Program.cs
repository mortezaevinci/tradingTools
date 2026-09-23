using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IBApi;
using System.Threading;
using IBApi.messages;

namespace ConsoleApp1
{
    class Program
    {
       

        private const int ACCOUNT_ID_BASE = 50000000;

        private const int ACCOUNT_SUMMARY_ID = ACCOUNT_ID_BASE + 1;

        private const string ACCOUNT_SUMMARY_TAGS = "AccountType,NetLiquidation,TotalCashValue,SettledCash,AccruedCash,BuyingPower,EquityWithLoanValue,PreviousEquityWithLoanValue,"
             + "GrossPositionValue,ReqTEquity,ReqTMargin,SMA,InitMarginReq,MaintMarginReq,AvailableFunds,ExcessLiquidity,Cushion,FullInitMarginReq,FullMaintMarginReq,FullAvailableFunds,"
             + "FullExcessLiquidity,LookAheadNextChange,LookAheadInitMarginReq ,LookAheadMaintMarginReq,LookAheadAvailableFunds,LookAheadExcessLiquidity,HighestSeverity,DayTradesRemaining,Leverage";






        static void Main(string[] args)
        {

            Console.WriteLine(DateTime.Parse("22:00:00").ToString("yyyy-MM-dd HH:mm:ss"));

            Console.ReadKey();
            return;

            EReaderMonitorSignal signal;
            IBClient ibClient;
            IBWrapper ibWrapper;

            signal = new EReaderMonitorSignal();
            ibClient = new IBClient(signal);

            ibWrapper = new IBWrapper(ibClient,signal);

            int clientId = 3;
            string host = "";
            int port = 7497;

            ibWrapper.ibClient.ClientId = clientId;

            ibWrapper.Connect(host, port);

            Console.WriteLine(ibClient.ClientSocket.IsConnected());

            ibWrapper.CleanUpSummary();

            ibClient.ClientSocket.reqAccountSummary(ACCOUNT_SUMMARY_ID, "All", ACCOUNT_SUMMARY_TAGS);

            while (ibWrapper.RequestEnded == false)
            {
                Thread.Sleep(200);
            }


            foreach (AccountSummaryMessage m in ibWrapper.SummaryMessages)
            {
                Console.WriteLine(m.Account);
                Console.WriteLine(m.Tag);
                Console.WriteLine(m.Value);
            }

            ibWrapper.Disconnect();

            Console.WriteLine(ibClient.ClientSocket.IsConnected());

            Console.ReadKey();
        }
    }
}
