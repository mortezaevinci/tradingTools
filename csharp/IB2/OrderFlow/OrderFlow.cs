using IBApi;
using System;
using IBApi.messages;
using IBApi.types;
using IBApi.util;
using System.Collections.Generic;
using System.Threading;
using System.Xml.Serialization;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace MHA
{
    [Serializable]
    public class OrderFlowSimulation
    {
        [Serializable]
        public class OrderFlowMessage
        {
            public TickByTickAllLastMessage AllLast;
            public TickByTickBidAskMessage BidAsk;

            public OrderFlowMessage()
            {

            }

            public OrderFlowMessage(TickByTickAllLastMessage _AllLast, TickByTickBidAskMessage _BidAsk)
            {
                AllLast = _AllLast;
                BidAsk = _BidAsk;
            }
        }

        public List<OrderFlowMessage> orderFlowMessages = new List<OrderFlowMessage>();


        public void saveXML(string filename)
        {
            XmlSerializer ser = new XmlSerializer(typeof(OrderFlowSimulation));

            TextWriter writer = new StreamWriter(filename);
            ser.Serialize(writer, this);
            writer.Close();
        }

        public void loadXML(string filename)
        {
            XmlSerializer ser = new XmlSerializer(typeof(OrderFlowSimulation));
            TextReader reader = new StreamReader(filename);
            try
            {
                OrderFlowSimulation od = (OrderFlowSimulation)ser.Deserialize(reader);
                reader.Close();
                this.orderFlowMessages = od.orderFlowMessages;

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            reader.Close();

        }

        public void saveBin(string filename)
        {
            BinaryFormatter ser = new BinaryFormatter();

            FileStream file = File.Create(filename);
            ser.Serialize(file, this);
            file.Close();

        }

        public void loadBin(string filename)
        {
            BinaryFormatter ser = new BinaryFormatter();
            FileStream file = File.Open(filename, FileMode.Open);
            try
            {
                OrderFlowSimulation od = (OrderFlowSimulation)ser.Deserialize(file);
                file.Close();
                this.orderFlowMessages = od.orderFlowMessages;

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                file.Close();
            }
            

        }
    }
    public class OrderFlow
    {
        public OrderFlowSimulation orderFlowSimulation = new OrderFlowSimulation();
        public class FlowValues
        {
            public long BidSize = 0;
            public long AskSize = 0;
            public long MidSize = 0;
        }

        public class FlowIndicators
        {
            public long diffSize=0;
            public long diffSizePrice=0;
            public long totalbid = 0;
            public long totalask = 0;
        }

        public bool logSimulation = false;

        double cellPenny = 0.01;
        IBControlDefinition IBCD;
        IBWrapper ibWrapper;
        double prevbid = 0;
        double prevask = 0;
        double prevlast = 0;

        double pivotvalue;

        protected int currentTicker = 0;
        protected int currentTickbytick = 0;

        Semaphore _pool_orderflow = new Semaphore(1, 1);
        Semaphore _pool_flowvalues = new Semaphore(1, 1);

        public FlowValues[] flowValues;
        public FlowIndicators flowIndicators = new FlowIndicators();


        private double ind2penny(int ind)
        {

            return (double)ind * cellPenny;
        }

        private int penny2ind(double p)
        {
            int roundp = (int)(Math.Round(p / cellPenny) * cellPenny);
            return roundp;
        }

        public OrderFlow(IBWrapper _ibWrapper, IBControlDefinition _IBCD, int maxcontractprice)
        {
            ibWrapper = _ibWrapper;
            IBCD = _IBCD;

            int cnt = penny2ind(maxcontractprice);
            flowValues = new FlowValues[cnt];
            for (int i = 0; i < cnt; i++)
            {
                flowValues[i] = new FlowValues();
            }
        }

        public void Start()
        {
            ibWrapper.ibClient.tickByTickAllLast += handletickbytickalllast;
            ibWrapper.ibClient.tickByTickBidAsk += handletickbytickbidask;

            currentTickbytick++;
            int nextReqId = currentTickbytick;
            string ticktype = "BidAsk"; //Last, AllLast
            ibWrapper.ibClient.ClientSocket.reqTickByTickData(nextReqId, IBCD.orderWatchlists[0].contractDefinitions[0].contract, ticktype, 0, false);
            currentTickbytick++;
            nextReqId = currentTickbytick;
            ticktype = "AllLast"; //Last, AllLast
            ibWrapper.ibClient.ClientSocket.reqTickByTickData(nextReqId, IBCD.orderWatchlists[0].contractDefinitions[0].contract, ticktype, 0, false);
        }

        public void Stop()
        {

            removePreviousTickers();
            ibWrapper.ibClient.tickByTickAllLast -= handletickbytickalllast;
            ibWrapper.ibClient.tickByTickBidAsk -= handletickbytickbidask;
        }

        public void removePreviousTickers()
        {
            for (int i = 0; i <= currentTickbytick; i++)
            {
                // ibClient.ClientSocket.cancelMktData(i);
                ibWrapper.ibClient.ClientSocket.cancelTickByTickData(i);

            }
            currentTickbytick = 0;
        }
        private void handletickbytickalllast(TickByTickAllLastMessage etp)
        {

            {
                try
                {
                    if (logSimulation)
                    {
                        _pool_orderflow.WaitOne();
                        orderFlowSimulation.orderFlowMessages.Add(new OrderFlowSimulation.OrderFlowMessage(etp, null));
                        _pool_orderflow.Release();
                    }

                    if (etp != null)
                    {
                        if ((currentTickbytick) == etp.ReqId)
                        {
                            if (pivotvalue == 0)
                            {
                                pivotvalue = Math.Round(etp.Price / cellPenny) * cellPenny;

                            }

                            if (pivotvalue > 0)
                            {

                                {//bid
                                    double price = etp.Price;
                                    if (price > 0)
                                    {

                                        int placeind = penny2ind(price);
                                        _pool_flowvalues.WaitOne();
                                        if (price <= prevbid && price < prevask) //on bid size
                                        {
                                            flowValues[placeind].BidSize += etp.Size;
                                            flowIndicators.totalbid += etp.Size;

                                        }
                                        else if (price >= prevask && price > prevbid) // on ask size
                                        {

                                            flowValues[placeind].AskSize += etp.Size;
                                            flowIndicators.totalask += etp.Size;
                                        }
                                        else if (price == prevask && price == prevbid)
                                        {
                                            long e2 = etp.Size / 2;
                                            flowValues[placeind].BidSize += e2;
                                            flowValues[placeind].AskSize += e2;
                                            flowIndicators.totalask += e2;
                                            flowIndicators.totalbid += e2;
                                        }
                                        else
                                        {
                                            flowValues[placeind].MidSize = etp.Size;
                                        }

                                        _pool_flowvalues.Release();

                                        flowIndicators.diffSize = flowIndicators.totalask-flowIndicators.totalbid;
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                catch { }

            }
        }

        private void handletickbytickbidask(TickByTickBidAskMessage etp)
        {

            try
            {
                if (etp != null)
                {

                    if (logSimulation)
                    {
                        _pool_orderflow.WaitOne();
                        orderFlowSimulation.orderFlowMessages.Add(new OrderFlowSimulation.OrderFlowMessage(null, etp));
                        _pool_orderflow.Release();
                    }

                    if ((currentTickbytick - 1) == etp.ReqId)
                    {

                        if (pivotvalue > 0)
                        {

                            {//bid
                                double price = etp.BidPrice;
                                if (price > 0)
                                {
                                    prevbid = price;
                                }
                            }

                            {//ask
                                double price = etp.AskPrice;
                                if (price > 0)
                                {
                                    prevask = price;

                                }
                            }

                        }
                    }
                }

            }
            catch (Exception ex)
            {

            }


        }



    }


}