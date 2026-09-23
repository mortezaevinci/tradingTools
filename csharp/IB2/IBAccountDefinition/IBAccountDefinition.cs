using System;
using System.Collections.Generic;
using System.Collections;
using IBApi.messages;
using System.Threading;
using System.IO;
using IBApi;

namespace MHA
{
    [Serializable]
    public class IBAccountDefinition
    {
        Semaphore _pool_positions = new Semaphore(1, 1);
        Semaphore _pool_openorders = new Semaphore(1, 1);
        Semaphore __pool_completedorders = new Semaphore(1, 1);
        Semaphore _pool_executions = new Semaphore(1, 1);
        Semaphore _pool_comissions = new Semaphore(1, 1);
        Semaphore _pool_portfolio = new Semaphore(1, 1);
        
        public Dictionary<string, IBApi.messages.PositionMessage> positions=new Dictionary<string, IBApi.messages.PositionMessage>();
        public Dictionary<string, List<IBApi.messages.OpenOrderMessage>> openOrders=new Dictionary<string, List<IBApi.messages.OpenOrderMessage>>();
        public Dictionary<string, List<IBApi.messages.CompletedOrderMessage>> completedOrders = new Dictionary<string, List<IBApi.messages.CompletedOrderMessage>>();
        public List<IBApi.messages.ExecutionMessage> executionMessages = new List<ExecutionMessage>();
        public List<IBApi.messages.CommissionMessage> comissionMessages = new List<IBApi.messages.CommissionMessage>();
        public IBApi.messages.ManagedAccountsMessage managedAccounts;
        public Dictionary<string, List<IBApi.messages.UpdatePortfolioMessage>> updatePortfolioMessages = new Dictionary<string, List<IBApi.messages.UpdatePortfolioMessage>>();

        public void HandleManagedAccounts(IBApi.messages.ManagedAccountsMessage msg)
        {
            managedAccounts=(msg);
        }

        public void HandlePortFolio(IBApi.messages.UpdatePortfolioMessage msg)
        {
            _pool_portfolio.WaitOne();
            if (updatePortfolioMessages.ContainsKey(msg.AccountName))
            {
                updatePortfolioMessages[msg.AccountName].Add(msg);
            }
            else
            {
                List<IBApi.messages.UpdatePortfolioMessage> msgs = new List<UpdatePortfolioMessage>();
                msgs.Add(msg);
                updatePortfolioMessages.Add(msg.AccountName, msgs);
            }
            _pool_portfolio.Release();
        }

        public void HandleExecutions(IBApi.messages.ExecutionMessage msg)
        {
            _pool_executions.WaitOne();
            try
            {
                executionMessages.Add(msg);
            }
            catch { }
            _pool_executions.Release();
        }

        public void HandleComissions(IBApi.messages.CommissionMessage msg)
        {
            _pool_executions.WaitOne();
            try
            {
                comissionMessages.Add(msg);
            }
            catch { }
            _pool_executions.Release();
        }

        public bool HasPosition(Contract contract)
        {
            string ukey = ContractDefinition.Tools.uniqueKey(contract);
            bool haspos = (positions.ContainsKey(ukey) == true && positions[ukey].Position > 0);
            return haspos;
        }

        public bool HasOrder(Contract contract)
        {
            string ukey = ContractDefinition.Tools.uniqueKey(contract);
            return (openOrders.ContainsKey(ukey) == true);
        }

        public void HandlePositionMessage(IBApi.messages.PositionMessage msg)
        {
            _pool_positions.WaitOne();
            try
            {
                string ukey = ContractDefinition.Tools.uniqueKey(msg.Contract);
                if (positions.ContainsKey(ukey))
                {
                    positions[ukey] = msg;
                }
                else
                {
                    positions.Add(ukey, msg);
                }
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex.Message);
                _pool_positions.Release();
                throw ex;
            }
            _pool_positions.Release();
        }

        public void HandleOpenOrderMessage(IBApi.messages.OpenOrderMessage msg)
        {
            _pool_openorders.WaitOne();
            try
            {
                string ukey = ContractDefinition.Tools.uniqueKey(msg.Contract);
                if (openOrders.ContainsKey(ukey))
                {
                    openOrders[ukey].Add(msg);
                }
                else
                {
                    List<OpenOrderMessage> l = new List<OpenOrderMessage>();
                    l.Add(msg);
                    openOrders.Add(ukey, l);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                _pool_openorders.Release();
                throw ex;
            }
            _pool_openorders.Release();
        }

        public void HandleCompletedOrderMessage(IBApi.messages.CompletedOrderMessage msg)
        {
            __pool_completedorders.WaitOne();
            try
            {
                string ukey = ContractDefinition.Tools.uniqueKey(msg.Contract);
                if (completedOrders.ContainsKey(ukey))
                {
                    completedOrders[ukey].Add(msg);
                }
                else
                {
                    List<CompletedOrderMessage> l = new List<CompletedOrderMessage>();
                    l.Add(msg);
                    completedOrders.Add(ukey, l);
                }
            }
            catch { }
            __pool_completedorders.Release();
        }


        public HashSet<OpenOrderMessage> OrdersWithZeroPos()
        {
            HashSet<OpenOrderMessage> orders = new HashSet<OpenOrderMessage>();
            foreach (KeyValuePair<string,List<OpenOrderMessage>> item in openOrders)
            {
                List<OpenOrderMessage> msgs = item.Value;
                string ukey = item.Key;
                
                if (positions.ContainsKey(ukey))
                {

                    if (positions[ukey].Position == 0)
                    {
                        foreach (OpenOrderMessage o in msgs)
                        {

                            //delete
                            Console.WriteLine("pos0 for {0}", ukey);
                            orders.Add(o);
                        }

                    }

                }
                else
                {
                    foreach (OpenOrderMessage o in msgs)
                    {

                        //delete
                        Console.WriteLine("nopos for {0}", ukey);
                        orders.Add(o);
                    }
                }
            }
        
            return orders;
        }


        public OpenOrderMessage findOrder(int orderid)
        {
            foreach (KeyValuePair<string, List<OpenOrderMessage>> item in openOrders)
            {
                List<OpenOrderMessage> msgs = item.Value;

                foreach (OpenOrderMessage o in msgs)
                {

                    if (o.OrderId == orderid) return o;
                }

              
            }
            return null;
        }

        public void savePortfolioCSV(string filename)
        {
            try
            {
                using (StreamWriter writer = File.CreateText(filename))
                {
                    writer.WriteLine(",,,,,,=sum(G3:G500),=sum(H3:H500)");
                    writer.WriteLine("acct,contract,averageCost,MArketPrice,MarketValue,Position,RPNL,UPNL");

                    foreach (string acct in managedAccounts.ManagedAccounts)
                    {
                        if (updatePortfolioMessages.ContainsKey(acct))
                        {
                            foreach (UpdatePortfolioMessage msg in updatePortfolioMessages[acct])
                            {
                                writer.WriteLine(String.Concat(
                                    msg.AccountName, ",",
                                    ContractDefinition.Tools.getText(msg.Contract), ",",
                                    msg.AverageCost, ",",
                                    msg.MarketPrice, ",",
                                    msg.MarketValue, ",",
                                    msg.Position, ",",
                                    msg.RealizedPNL, ",",
                                    msg.UnrealizedPNL
                                    ));

                            }
                        }
                    }
                }
            }
            catch { }
        }
        public void saveExecutionsCSV(string filename)
        {
            try
            {
                using (StreamWriter writer = File.CreateText(filename))
                {

                    writer.WriteLine("contract,execid,comm,curr,PNL,yield,yieldate,acct,clientid,orderid,orderref,permid,time,side,shares,price,avgprice,liquid,evX,evRule,last liq,cum qty");
                    foreach (ExecutionMessage msg in executionMessages)
                    {
                            try
                            {
                                writer.WriteLine(String.Concat(
                                    ContractDefinition.Tools.getText( msg.Contract), ",",
                                    msg.Execution.ExecId, ",",
                                    "", ",",
                                    "", ",",
                                    "", ",",
                                    "", ",",
                                    "", ",",
                                    msg.Execution.AcctNumber, ",",
                                    msg.Execution.ClientId, ",",
                                    msg.Execution.OrderId, ",",
                                    msg.Execution.OrderRef, ",",
                                    msg.Execution.PermId, ",",
                                    msg.Execution.Time, ",",
                                    msg.Execution.Side, ",",
                                    msg.Execution.Shares, ",",
                                    msg.Execution.Price, ",",
                                    msg.Execution.AvgPrice, ",",
                                    msg.Execution.Liquidation, ",",
                                    msg.Execution.EvMultiplier, ",",
                                    msg.Execution.Exchange, ",",
                                    msg.Execution.EvRule, ",",
                                    msg.Execution.LastLiquidity, ",",
                                    msg.Execution.CumQty,","
                                    ));
                            }
                            catch (Exception ex)
                            {

                            }
                    }

                    foreach (CommissionMessage msg in comissionMessages)
                    {
                        try
                        {
                            double pnl = msg.CommissionReport.RealizedPNL;
                            if (pnl > 1e100) pnl = 0;

                            double y = msg.CommissionReport.Yield;
                            if (y > 1e100) y = 0;


                            writer.WriteLine(String.Concat(
                                "",",",
                                msg.CommissionReport.ExecId, ",",
                                msg.CommissionReport.Commission, ",",
                                msg.CommissionReport.Currency, ",",
                                pnl, ",",
                                y, ",",
                                msg.CommissionReport.YieldRedemptionDate,","
                                ));
                        }
                        catch (Exception ex)
                        {

                        }
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        public void saveOpenOrdersCSV(string filename)
        {
            try
            {
                using (StreamWriter writer = File.CreateText(filename))
                {

                    writer.WriteLine(OrderDefinition.Tools.MessageOrderDescription(null, null, null));
                    foreach (List<OpenOrderMessage> msgs in openOrders.Values)
                    {
                        foreach (OpenOrderMessage msg in msgs)
                        {
                            try
                            {

                                writer.WriteLine(OrderDefinition.Tools.MessageOrderDescription(msg.Contract, msg.Order, msg.OrderState));
                            }
                            catch (Exception ex)
                            {

                            }
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                
            }
        }

        public void saveOpenOrdersXML(string filename)
        {
            IBControlDefinition od = new IBControlDefinition();

            int watchlistindex = -1;
            foreach (List<OpenOrderMessage> msgs in openOrders.Values)
            {
                foreach (OpenOrderMessage msg in msgs)
                {
                    od.orderWatchlists.Add(new IBControlDefinition.OrderWatchlist());
                    watchlistindex++;
                    od.orderWatchlists[watchlistindex].contractDefinitions.Add(new ContractDefinition());
                    od.orderWatchlists[watchlistindex].orderDefinitions.Add(new OrderDefinition());
                    od.orderWatchlists[watchlistindex].contractDefinitions[0].contract = msg.Contract;
                    od.orderWatchlists[watchlistindex].orderDefinitions[0].order = msg.Order;
                }
            }

            od.saveXML(filename);
        }

        public void saveCompletedOrdersCSV(string filename)
        {
            try
            {
                using (StreamWriter writer = File.CreateText(filename))
                {

                    writer.WriteLine(OrderDefinition.Tools.MessageOrderDescription(null, null, null));
                    foreach (List<CompletedOrderMessage> msgs in completedOrders.Values)
                    {
                        foreach (CompletedOrderMessage msg in msgs)
                        {
                            try
                            {
                                
                                writer.WriteLine(OrderDefinition.Tools.MessageOrderDescription(msg.Contract, msg.Order, msg.OrderState));
                            }
                            catch (Exception ex)
                            {

                            }
                        }

                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        public void saveCompletedOrdersXML(string filename)
        {
            IBControlDefinition od = new IBControlDefinition();

            int watchlistindex = -1;
            foreach (List<CompletedOrderMessage> msgs in completedOrders.Values)
            {
                foreach (CompletedOrderMessage msg in msgs)
                {
                    od.orderWatchlists.Add(new IBControlDefinition.OrderWatchlist());
                    watchlistindex++;
                    od.orderWatchlists[watchlistindex].contractDefinitions.Add(new ContractDefinition());
                    od.orderWatchlists[watchlistindex].orderDefinitions.Add(new OrderDefinition());
                    od.orderWatchlists[watchlistindex].contractDefinitions[0].contract = msg.Contract;
                    od.orderWatchlists[watchlistindex].orderDefinitions[0].order = msg.Order;
                }
            }

            od.saveXML(filename);
        }

    }
}
