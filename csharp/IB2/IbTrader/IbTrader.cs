using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MHA;
using System.Threading;
using IBApi;
using IBApi.messages;

namespace IBApi
{
   
    public class IbTrader
    {
        
        BasicLogger basicLogger = new BasicLogger();

  
        IBAccountDefinition IBAD;
        IBControlDefinition IBCD;
        IBWrapper ibWrapper;
        int cycleremainder=0;

        private int _processedReqs = 0;

        public int ProcessedReqs
        {
            get
            {
                return _processedReqs;
            }
            set
            {
                _pool_evaluate_orders.WaitOne();
                _processedReqs = value;
                _pool_evaluate_orders.Release();
            }
        }

        private static Semaphore _pool_evaluate_orders = new Semaphore(1, 1);

        private WorkBurstRequestSnapshot workBurstRequestSnapshot;

        public event OrderManipulated orderManipulated;
        public delegate void OrderManipulated(object sender, ManipulatedOrder manipulatedOrder);

        public event TickRoundComplete tickRoundComplete;
        public delegate void TickRoundComplete(int ucnt);

        public class ManipulatedOrder
        {
            public enum Manipulation
            {
                Submit,
                Cancel,
                ImpliedCancel
            }
            public Order order;
            public Manipulation manipulation;
            public Contract contract;
            public IBControlDefinition.OrderWatchlist orderWatchlist; //this encompases order and contract, but for laziness, they are incldued

            public ManipulatedOrder(IBControlDefinition.OrderWatchlist _orderWatchlist, Order _order,Contract _contract, Manipulation _manipulation)
            {
                order = _order;
                manipulation = _manipulation;
                contract = _contract;
                orderWatchlist = _orderWatchlist;
            }
        }


        public IbTrader(IBWrapper _ibWrapper,IBControlDefinition _IBCD, IBAccountDefinition _IBAD)
        {
            IBAD = _IBAD;
            ibWrapper = _ibWrapper;
            IBCD = _IBCD;
            //IBCD.regenerateExternalConditionRequestIdDictionary();
            listenForOrderExternalConditions();
        }

        ~IbTrader()
        {
            ibWrapper.ibClient.TickPrice -= HandleTickForOrderExternalConditions;
            ibWrapper.ibClient.TickSize -= HandleTickForOrderExternalConditions;
        }

        //simply listen to ibwrapper handles
        private void listenForOrderExternalConditions()
        {
            ibWrapper.ibClient.TickPrice += HandleTickForOrderExternalConditions;
            ibWrapper.ibClient.TickSize += HandleTickForOrderExternalConditions;

            //ibWrapper.ibClient.HistoricalData += HandleBarForOrderExternalConditions;

        }

        public int AbsoluteMarketDataToRelativeRequestId(int RequestiId)
        {
            try
            {
                int rid = RequestiId - IBWrapper.TICK_ID_BASE;
                rid = rid % IBCD.cycleremainder;
                return rid;
            }
            catch
            {
                return 0;
            }
        }

        public int AbsoluteToRelativeRequestId(MarketDataMessage msg)
        {
            try
            {
                int rid = msg.RequestId - IBWrapper.TICK_ID_BASE;
                rid = rid % IBCD.cycleremainder;
                return rid;
            }
            catch
            {
                return 0;
            }
        }

        public int AbsoluteToRelativeRequestId(HistoricalDataMessage msg)
        {
            int rid = msg.RequestId - IBWrapper.HISTORICAL_ID_BASE;
            rid = rid % IBCD.cycleremainder;
            return rid;
        }

        /*
        void HandleTickForOrderExternalConditions(messages.TickPriceMessage msg)
        {
            /* // we are not generating based on IB Sample, but here for reference
         
            //if any of these gives error, then DO NOT TRY. SOEMTHING BAD IS OFF!
            int rid = AbsoluteToRelativeRequestId(msg);
            ContractDefinition cd = IBCD.mapReqIdToCd[rid];
            string ckey = ContractDefinition.Tools.uniqueKey(cd.contract);
            List<IBControlDefinition.OrderWatchlist> ows = IBCD.mapContractKeyToWl[ckey];
            foreach(IBControlDefinition.OrderWatchlist ow in ows)
            {
                List<ExternalCondition> ecs= ow.listEcWithReqId(rid);
                foreach(ExternalCondition ec in ecs)
                {
                    ec.CheckSatisfied(msg);
                }
            }

        }
*/


        public void HandleTickForOrderExternalConditions(IBApi.messages.MarketDataMessage msg)
        {
 
            _pool_evaluate_orders.WaitOne();
            _processedReqs++;
            int rid = AbsoluteToRelativeRequestId(msg);
            ContractDefinition cd = IBCD.mapReqIdToCd[rid];
            string ckey = ContractDefinition.Tools.uniqueKey(cd.contract);
            HashSet<IBControlDefinition.OrderWatchlist> ows = IBCD.mapContractKeyToWl[ckey];
            foreach (IBControlDefinition.OrderWatchlist ow in ows)
            {
                ContractDefinition orderCD = ow.contractDefinitions[0];


                bool haspos = IBAD.HasPosition(orderCD.contract);
                bool hasorder = IBAD.HasOrder(orderCD.contract);
                bool freeToManipulatePlace = !hasorder & !haspos;
                bool freeToManipulateCancel = hasorder & !haspos;
                {
                    foreach (OrderDefinition od in ow.orderDefinitions)
                    {
                        if (false) //have not seen an issue here, but no need to cancel chil orders anyway
                        {
                            foreach (OrderDefinition cod in od.childOrderDefinitions)
                            {
                                foreach (ExternalCondition ec in cod.externalConditions)
                                {
                                    ec.CheckSatisfied(msg, AbsoluteToRelativeRequestId(msg));
                                }
                                Dictionary<ExternalCondition.Action, bool> cr = ExternalCondition.EvaluateConditions(cod.externalConditions);
                                if (cr[ExternalCondition.Action.CancelOrder] == true)
                                {
                                    if (freeToManipulateCancel)
                                    {
                                        //cancel child order cod.order if orderid>0
                                        // generally a child order does not need external conditions, so it should never cancel because of it.
                                        if (cod.order.OrderId > 0 && cod.order.ClientId == ibWrapper.clientId)
                                        {
                                            if (od.simulation == false)
                                            {
                                                ibWrapper.ibClient.ClientSocket.cancelOrder(cod.order.OrderId);
                                            }
                                            orderManipulated?.Invoke(this, new ManipulatedOrder(ow, cod.order, orderCD.contract, ManipulatedOrder.Manipulation.Cancel));
                                        }

                                    }
                                    cod.cancellationDatetime = DateTime.Now;
                                    cod.order.OrderId = -1;
                                }

                            }
                        }

                        //List<ExternalCondition> ecs = od.listEcWithReqId(rid);
                        foreach (ExternalCondition ec in od.externalConditions)
                        {
                            ec.CheckSatisfied(msg, AbsoluteToRelativeRequestId(msg));
                        }

                        Dictionary<ExternalCondition.Action, bool> r = ExternalCondition.EvaluateConditions(od.externalConditions);
                        if (r[ExternalCondition.Action.PlaceOrder] == true && r[ExternalCondition.Action.CancelOrder]==false)
                        {
                            if (od.order.OrderId == 0)
                            {
                                //submit
                                //submit od.order if orderid=0
                                if (freeToManipulatePlace)
                                {
                                    int oid = ibWrapper.ibClient.NextOrderId;
                                    
                                    if (od.simulation == false)
                                    {
                                        IbSpacer.WaitForSpace();
                                        ibWrapper.ibClient.ClientSocket.placeOrder(oid, orderCD.contract, od.order);
                                    }
                                    od.order.OrderId = oid;
                                    od.submissionDatetime = DateTime.Now;
                                    ibWrapper.ibClient.NextOrderId++;
                                    orderManipulated?.Invoke(this, new ManipulatedOrder(ow,od.order, orderCD.contract, ManipulatedOrder.Manipulation.Submit));
                                }
                            }
                            foreach (OrderDefinition cod in od.childOrderDefinitions)
                            {
                                cod.order.ParentId = od.order.OrderId;
                                //CheckSatisfied has already run for children
                                Dictionary<ExternalCondition.Action,bool> cr = ExternalCondition.EvaluateConditions(cod.externalConditions);
                                if (freeToManipulatePlace)
                                {
                                    if (cr[ ExternalCondition.Action.PlaceOrder] == true && cr[ ExternalCondition.Action.CancelOrder]==false)
                                    {
                                        if (cod.order.OrderId == 0)
                                        {
                                            //submit and attach child
                                            int oid = ibWrapper.ibClient.NextOrderId;
                                            if (od.simulation == false)
                                            {
                                                IbSpacer.WaitForSpace();
                                                ibWrapper.ibClient.ClientSocket.placeOrder(oid, orderCD.contract, cod.order);
                                            }
                                            cod.order.OrderId = oid;
                                            cod.submissionDatetime = DateTime.Now;
                                            ibWrapper.ibClient.NextOrderId++;
                                            orderManipulated?.Invoke(this, new ManipulatedOrder(ow,cod.order, orderCD.contract, ManipulatedOrder.Manipulation.Submit));
                                            //Thread.Sleep(10);
                                        }
                                    }
                                    else
                                    {
                                        //do nothing I guess, typically child conditions should not have a condition anyway
                                    }
                                }

                            }

                        }

                        if (r[ExternalCondition.Action.CancelOrder] == true)
                        {
                            //cancel od.order if orderid>0


                            if ((freeToManipulateCancel || od.order.Action.Equals("BUY")))
                            {
                                if (od.order.OrderId > 0)
                                {
                                    if (true) //this won't work, because this clientid is simply the one written in the xml file, not what is received from IBAD, od.order.ClientId == ibWrapper.clientId)
                                    {
                                        if (od.simulation == false)
                                        {
                                            ibWrapper.ibClient.ClientSocket.cancelOrder(od.order.OrderId);
                                        }
                                        orderManipulated?.Invoke(this, new ManipulatedOrder(ow, od.order, orderCD.contract, ManipulatedOrder.Manipulation.Cancel));
                                        od.order.OrderId = -1;
                                        od.cancellationDatetime = DateTime.Now;
                                        //This will automatically cancel any child anyway

                                        //consider all childs cancelled as well
                                        foreach (OrderDefinition cod in od.childOrderDefinitions)
                                        {
                                            orderManipulated?.Invoke(this, new ManipulatedOrder(ow, cod.order, orderCD.contract, ManipulatedOrder.Manipulation.ImpliedCancel));
                                            cod.order.OrderId = -1;
                                            cod.cancellationDatetime = DateTime.Now;

                                        }
                                    }
                                }
                                else
                                {
                                    od.order.OrderId = -1;// we don't want to get into this trade
                                }

                                
                            }
                            
                        }



                    }
            }
            }

            _pool_evaluate_orders.Release();
        }
        /*
        public void HandleBarForOrderExternalConditions(IBApi.messages.HistoricalDataMessage msg)
        {
        
            
            _pool_evaluate_orders.WaitOne();

            int rid = AbsoluteToRelativeRequestId(msg);
            ContractDefinition cd = IBCD.mapReqIdToCd[rid];
            string ckey = ContractDefinition.Tools.uniqueKey(cd.contract);
            List<IBControlDefinition.OrderWatchlist> ows = IBCD.mapContractKeyToWl[ckey];
            foreach (IBControlDefinition.OrderWatchlist ow in ows)
            {
                ContractDefinition orderCD = ow.contractDefinitions[0];

              

                string ukey = ContractDefinition.Tools.uniqueKey(orderCD.contract);
                bool haspos = (IBAD.positions.ContainsKey(ukey) == true && IBAD.positions[ukey].Position > 0);
                bool hasorder = (IBAD.openOrders.ContainsKey(ukey) == true);

                if (hasorder) return;

                {
                    foreach (OrderDefinition od in ow.orderDefinitions)
                    {


                        foreach (OrderDefinition cod in od.childOrderDefinitions)
                        {
                            foreach (ExternalCondition ec in cod.externalConditions)
                            {
                                ec.CheckSatisfied(msg, AbsoluteToRelativeRequestId(msg));
                            }
                            ExternalCondition.Result cr = ExternalCondition.EvaluateConditions(cod.externalConditions);
                            if (cr.Cancel == true)
                            {
                                if (!haspos)
                                {
                                    //cancel child order cod.order if orderid>0
                                    // generally a child order does not need external conditions, so it should never cancel because of it.
                                    if (cod.order.OrderId > 0)
                                    {
                                        ibWrapper.ibClient.ClientSocket.cancelOrder(cod.order.OrderId);
                                        
                                        orderManipulated?.Invoke(this, new ManipulatedOrder(cod.order, orderCD.contract, ManipulatedOrder.Manipulation.Cancel));
                                    }
                                    cod.order.OrderId = -1; //-1 s that it does not get submitted again
                                }
                            }

                        }

                        //List<ExternalCondition> ecs = od.listEcWithReqId(rid);
                        foreach (ExternalCondition ec in od.externalConditions)
                        {
                            ec.CheckSatisfied(msg, AbsoluteToRelativeRequestId(msg));
                        }

                        ExternalCondition.Result r = ExternalCondition.EvaluateConditions(od.externalConditions);
                        if (r.Submit == true)
                        {
                            if (od.order.OrderId == 0)
                            {
                                //submit
                                //submit od.order if orderid=0
                                if (!haspos)
                                {
                                    int oid = ibWrapper.ibClient.NextOrderId;
                                    if (od.simulation == false)
                                    {
                                    ibRequestSpacer.WaitForSpace();
                                    ibWrapper.ibClient.ClientSocket.placeOrder(oid, orderCD.contract, od.order);
                                    }
                                    od.order.OrderId = oid;
                                    ibWrapper.ibClient.NextOrderId++;
                                    orderManipulated?.Invoke(this, new ManipulatedOrder(od.order, orderCD.contract, ManipulatedOrder.Manipulation.Submit));
                                    //Thread.Sleep(20);
                                }
                            }
                            foreach (OrderDefinition cod in od.childOrderDefinitions)
                            {
                                cod.order.ParentId = od.order.OrderId;
                                //CheckSatisfied has already run for children
                                ExternalCondition.Result cr = ExternalCondition.EvaluateConditions(od.externalConditions);
                                if (!haspos)
                                {
                                    if (cr.Submit == true)
                                    {
                                        if (cod.order.OrderId == 0)
                                        {
                                            //submit and attach child
                                            //Thread.Sleep(10);
                                            int oid = ibWrapper.ibClient.NextOrderId;
                                            if (od.simulation == false)
                                    {
                                            ibRequestSpacer.WaitForSpace();
                                            ibWrapper.ibClient.ClientSocket.placeOrder(oid, orderCD.contract, cod.order);
                                            }
                                            cod.order.OrderId = oid;
                                            ibWrapper.ibClient.NextOrderId++;
                                            orderManipulated?.Invoke(this, new ManipulatedOrder(cod.order, orderCD.contract, ManipulatedOrder.Manipulation.Submit));
                                          //  Thread.Sleep(10);
                                        }
                                    }
                                    else
                                    {
                                        //do nothing I guess, typically child conditions should not have a condition anyway
                                    }
                                }

                            }

                        }
                        else if (r.Cancel == true && !haspos)
                        {
                            //cancel od.order if orderid>0
                            

                            if (od.order.OrderId > 0)
                            {
                                ibWrapper.ibClient.ClientSocket.cancelOrder(od.order.OrderId);
                                orderManipulated?.Invoke(this, new ManipulatedOrder(od.order, orderCD.contract, ManipulatedOrder.Manipulation.Cancel));
                            }
                            od.order.OrderId = -1;
                            //consider all childs cancelled as well
                            foreach (OrderDefinition cod in od.childOrderDefinitions)
                            {
                                cod.order.OrderId = -1; //-1 so that it does not get submitted again
                            }
                            //This will automatically cancel any child anyway
                        }



                    }
                }
            }

            _pool_evaluate_orders.Release();
        }
    */
        public enum SetupType
        {
            ContractTriggers,
            ExternalConditions
        }

        public void threadSetupBurstRequestSnapshot(SetupType setupType)
        {
           if (setupType == SetupType.ExternalConditions)
            {
                workBurstRequestSnapshot = new WorkBurstRequestSnapshot(ibWrapper, IBCD, cycleremainder);
                workBurstRequestSnapshot.tickRoundComplete = this.tickRoundComplete;
                workBurstRequestSnapshot.SetupForOrderExternalConditions();
                
            }

            else if (setupType == SetupType.ContractTriggers)
            {
                workBurstRequestSnapshot = new WorkBurstRequestSnapshot(ibWrapper, IBCD, cycleremainder);
                workBurstRequestSnapshot.tickRoundComplete = this.tickRoundComplete;
                workBurstRequestSnapshot.SetupForContractDefinitions();
            }

        }
            
       public bool Pause
        {
            set
            {
                workBurstRequestSnapshot.Pause = value;
            }
        }

        public void threadStartBurstRequestSnapshot()
        {
            if (workBurstRequestSnapshot == null) return;
            workBurstRequestSnapshot.Start();
        }

        public void threadStopBurstRequestSnapshot()
        {
            if (workBurstRequestSnapshot != null)
            {
                bool success = workBurstRequestSnapshot.Stop();
                workBurstRequestSnapshot = null;

            }
            
        }

        private class WorkBurstRequestSnapshot
        {
            Thread threadBurstRequestSnapshot;
            Thread threadBurstRequestSnapshot2;
            bool run = false;
            public bool Pause = false;

            public TickRoundComplete tickRoundComplete;
         
            IBWrapper ibWrapper;
            IBControlDefinition IBCD;
            int cycleremainder;
            public WorkBurstRequestSnapshot(IBWrapper _ibWrapper, IBControlDefinition _IBCD, int _cycleremainder)
            {
                // Start a thread that calls a parameterized static method.
                //Thread thredBurstRequestSnapshot = new Thread(() => RunThreadForContractDefinition(ibWrapper, IBCD, cycleremainder));
                ibWrapper = _ibWrapper;
                IBCD = _IBCD;
                cycleremainder = _cycleremainder;
        
            }

            public void SetupForContractDefinitions()
            {
                threadBurstRequestSnapshot = new Thread(() => RunThreadForContractDefinition(ibWrapper, IBCD));
            }

            //will need a regeenratelink from watchlist before running
            public void SetupForOrderExternalConditions()
            {
                IBCD.generateUniqueIdsForExternalConditions();
  
               threadBurstRequestSnapshot2 = new Thread(() => RunThreadForOrderExternalConditionsByTick(ibWrapper, IBCD));
              //  threadBurstRequestSnapshot = new Thread(() => RunThreadForOrderExternalConditionsByHistorical(ibWrapper, IBCD));
            }

            public bool Stop()
            {
                bool complete = false;
                run = false;
                if (threadBurstRequestSnapshot != null)
                {
                    complete = threadBurstRequestSnapshot.Join(5000);
                }
                if (threadBurstRequestSnapshot2 != null)
                {
                    complete = threadBurstRequestSnapshot2.Join(5000);
                }
                return complete;
            }
            public void Start()
            {
                run = true;
                if (threadBurstRequestSnapshot != null)
                {
                    threadBurstRequestSnapshot.Start();
                }

                if (threadBurstRequestSnapshot2 != null)
                {
                    threadBurstRequestSnapshot2.Start();
                }
            }

            private void RunThreadForContractDefinition(IBWrapper ibWrapper, IBControlDefinition IBCD)
            {
                //xxxmor, will need to check first available tickerid, for now let's say it is 1
                int tickerIdBase = IBWrapper.TICK_ID_BASE;

                int nw = IBCD.orderWatchlists.Count;
                List<TagValue> options = new List<TagValue>();
                while (run == true)
                {
                    for (int i = 0; i < nw; i++)
                    {
                        ContractDefinition cd = IBCD.orderWatchlists[i].contractDefinitions[0];
                        if (cd.marked)
                        {
                            int tickerId = 0;
                            if (cd.reservedRequestId == -1)
                            {
                                tickerId = tickerIdBase + i + 1;//for now coming from index. Could come from IBCD contractdef ReservedRequesTId
                            }
                            else
                            {
                                tickerId = tickerIdBase + cd.reservedRequestId;
                            }
                            IbSpacer.WaitForSpace();
                                ibWrapper.ibClient.ClientSocket.reqMktData(tickerId, cd.contract, cd.genericTicks, true, false, options);
                            //Thread.Sleep(21);
                        }
                    }
                    tickerIdBase += IBCD.cycleremainder;
                }
            }

            private void RunThreadForOrderExternalConditionsByTick(IBWrapper ibWrapper, IBControlDefinition IBCD)
            {
                //xxxmor, will need to check first available tickerid, for now let's say it is 1
                int tickerIdBase = IBWrapper.TICK_ID_BASE;

                int cycle = 0;
                List<TagValue> options = new List<TagValue>();
                int ucnt = IBCD.mapReqIdToCd.Keys.Count;
                while (run == true)
                {
                    while (Pause && run)
                    {
                        Thread.Sleep(100);

                    }


                    DateTime t0 = DateTime.Now;

                    foreach (int uid in IBCD.mapReqIdToCd.Keys)
                    {
                        ContractDefinition cd = IBCD.mapReqIdToCd[uid];

                        if (uid > 0)
                        {
                            int tickerId = tickerIdBase + uid;
                            IbSpacer.WaitForSpace();
                            ibWrapper.ibClient.ClientSocket.reqMktData(tickerId, cd.contract, cd.genericTicks, true, false, options);
                           // Thread.Sleep(21);// 20 minium but order placement counts as request as well
                            // Console.WriteLine("Requensting tick for {0}", cd.contract.Symbol);
                            // ibWrapper.ibClient.ClientSocket.reqHistoricalData(tickerId, cd.contract, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), "1 D", "1 day", "TRADES", 0, 0, false, options);
                        }
                        if (!run) break;
                    }
                   
                    cycle++;
                    tickerIdBase = tickerIdBase + cycle * IBCD.cycleremainder;
                    
                    tickRoundComplete?.Invoke(ucnt);
                    ibWrapper.CleanUpMktData();
                  

                    while ((DateTime.Now - t0).TotalSeconds < 12); //if all was done in less than 12 seconds, just wait
                }
            }

            /*
            private void RunThreadForOrderExternalConditionsByHistorical(IBWrapper ibWrapper, IBControlDefinition IBCD)
            {
                //xxxmor, will need to check first available tickerid, for now let's say it is 1
                int tickerIdBase = IBWrapper.HISTORICAL_ID_BASE;

                int cycle = 0;
                List<TagValue> options = new List<TagValue>();

                string day = String.Concat(DateTime.Now.ToString("yyyy-MM-dd"), " 23:00:00");

                string date0=DateTime.Parse(day).ToString("yyyyMMdd HH:mm:ss");

                while (run == true)
                {
                    DateTime t0 = DateTime.Now;

                    int ucnt = IBCD.mapReqIdToCd.Keys.Count;
                    for(int ui=0;ui<ucnt;ui++)
                    {
                        int uid = IBCD.mapReqIdToCd.Keys.ElementAt(ui);
                        ContractDefinition cd = IBCD.mapReqIdToCd[uid];

                        if (uid > 0)
                        {
                            int tickerId = tickerIdBase + uid;
                            ibRequestSpacer.WaitForSpace();
                            ibRequestSpacer.WaitForSpace();
                            ibRequestSpacer.WaitForSpace();
                            ibWrapper.ibClient.ClientSocket.reqHistoricalData(tickerId, cd.contract, date0, "1 D", "1 day", "TRADES", 0, 1, false, options);

                           // Thread.Sleep(500);
                           // Console.WriteLine("Requensting hist for {0}", cd.contract.Symbol);
                        }
                        if (!run) break;
                    }

                    cycle++;
                    tickerIdBase = tickerIdBase + cycle * IBCD.cycleremainder;
                    Console.WriteLine("Historical round done!");
                    ibWrapper.CleanUpHistoricalData();
                    ibWrapper.CleanUpHistoricalDataEnd();

                    while ((DateTime.Now - t0).TotalSeconds < 12) ; //if all was done in less than 12 seconds, just wait
                }
            }
            */

        }


      
    }
}
