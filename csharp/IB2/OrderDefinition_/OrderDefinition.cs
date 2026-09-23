using IBApi;
using System;
using System.Collections.Generic;
using System.Xml.Serialization;
using MHA;


namespace MHA
{
    [XmlInclude(typeof(VolumeCondition))]
    [XmlInclude(typeof(PercentChangeCondition))]
    [XmlInclude(typeof(TimeCondition))]
    [XmlInclude(typeof(PriceCondition))]
    [XmlInclude(typeof(ContractCondition))]
    public class OrderDefinition
    {
        public static class Tools
        {

            public static string MessageOrderDescription(Contract contract, Order order, OrderState orderState)
            {
                 string des = String.Format("{0},{1},{2},{3},{4}",
                ContractDefinition.Tools.getLocalSymbol(contract),
                AccountInfo(order),
                MainInfo(order),
                TimeInForceInfo(order),
                OrderStateInfo(orderState)
                 );


                des = String.Concat(des, ",", ListConditions(order));

                return des;
            }

            public static string uniqueKey(Order order)
            {
                return String.Concat(order.OrderId,order.Action, order.PermId, "_",order.TotalQuantity, "_",order.FilledQuantity);
            }

            public static string FullInfo(Order order)
            {
                string des = String.Format("{0},{1},{2}",
             
              AccountInfo(order),
              MainInfo(order),
              TimeInForceInfo(order)
             
               );


                des = String.Concat(des, ",", ListConditions(order));

                return des;
            }

            public static string OrderStateInfo(OrderState orderState)
            {
                if (orderState == null)
                {
                    return String.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}",
                   "Commission","Comm Currency","Completed status","Completed time","InitMarginAfter","InitMarginBefore","InitMarginChange",
                   "MAintMarginChange","MAxCommision","MinCommision","Status","WarningText"
                    );
                }
                return String.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11}",
                    orderState.Commission,
                    orderState.CommissionCurrency,
                    orderState.CompletedStatus,
                    orderState.CompletedTime,
                    orderState.InitMarginAfter,
                    orderState.InitMarginBefore,
                    orderState.InitMarginChange,
                    orderState.MaintMarginChange,
                    orderState.MaxCommission,
                    orderState.MinCommission,
                    orderState.Status,
                    orderState.WarningText
                );
            }

            public static string AccountInfo(Order order)
            {
                if (order == null)
                {
                    return String.Format("{0},{1},{2}",
                   "Account", "Id", "Ref"
                    );
                }
                return String.Format("{0},{1},{2}",
                    order.Account, order.OrderId, order.OrderRef
                );
            }

            public static string TimeInForceInfo(Order order)
            {
                if (order == null)
                {
                    return String.Format("{0},{1}",
                   "OutsideRTH", "TIF"
                    );
                }
                return String.Format("{0},{1}",
                    order.OutsideRth, order.Tif
                );
            }

            public static string MainInfo(Order order)
            {
                if (order == null)
                {
                    return String.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8}",
                   "Qty", "filled", "Type", "Action", "Aux", "Lmt", "TrailStop", "AlgoStrategy", "LimitOffset"
               );
                }
                return String.Format("{0},{1},{2},{3},{4},{5},{6},{7},{8}",
                    order.TotalQuantity, order.FilledQuantity, order.OrderType, order.Action, order.AuxPrice, order.LmtPrice, order.TrailStopPrice, order.AlgoStrategy, order.LmtPriceOffset
                );
            }

            public static string ListConditions(Order order)
            {
                if (order == null) return "";
                string des = "";
                foreach (OrderCondition oc in order.Conditions)
                {
                    if (oc is TimeCondition)
                    {
                        des = String.Concat(des, ",", TradeExtension.Conditions.TimeConditionText(oc as TimeCondition));
                    }
                    if (oc is PriceCondition)
                    {
                        des = String.Concat(des, ",", TradeExtension.Conditions.PriceConditionText(oc as PriceCondition));
                    }
                    if (oc is VolumeCondition)
                    {
                        des = String.Concat(des, ",", TradeExtension.Conditions.VolumeConditionText(oc as VolumeCondition));
                    }
                    if (oc is MarginCondition)
                    {
                        des = String.Concat(des, ",", TradeExtension.Conditions.MarginConditionText(oc as MarginCondition));
                    }
                }
                return des;
            }

            public static void FillAdaptiveParams(Order baseOrder, string priority)
            {
                baseOrder.AlgoStrategy = "Adaptive";
                baseOrder.AlgoParams = new List<TagValue>();
                baseOrder.AlgoParams.Add(new TagValue("adaptivePriority", priority));
            }

            public static Order generateOrder(string action = "SELL", string ordertype = "MKT", double lmtprice = 0, double auxprice = 0, double totalqty = 0, string timeinforce = "DAY")
            {
                Order order = new Order();
                order.OrderId = 0;
                order.Action = action;

                order.OrderType = ordertype;
                order.LmtPrice = lmtprice;

                order.TotalQuantity = totalqty;
                order.Tif = timeinforce;

                order.AuxPrice = auxprice;
                order.DisplaySize = 0;
                order.CashQty = 0;

                order.UsePriceMgmtAlgo = true;

                return order;
            }

        }

        public int id;
        public string name = "";
        public Order order;
        public bool simulation = false;
        public DateTime MarketStartDatetime;
        public DateTime MarketEndDatetime;
        public DateTime submissionDatetime;
        public DateTime cancellationDatetime;
        public List<OrderDefinition> childOrderDefinitions = new List<OrderDefinition>();

        public List<int> contractDefinitionIndexes = new List<int>(); //in case sometime later we wanted to say order applies to which contractdefinition
        public List<ExternalCondition> externalConditions = new List<ExternalCondition>();

        public string Text
        {
            get
            {
                return String.Format("{0} {1}", order.Action, order.OrderType);
            }
        }

        public OrderDefinition()
        {
            order = new Order();
        }


        public List<ExternalCondition> listEcWithReqId(int rid)
        {
            List<ExternalCondition> ecs = new List<ExternalCondition>();

            foreach (ExternalCondition ec in externalConditions)
            {
                if (ec.contractDefinition != null)
                {
                    if (rid == ec.contractDefinition.reservedRequestId)
                    {
                        ecs.Add(ec);
                    }
                }
            }

            foreach (OrderDefinition cod in childOrderDefinitions)
            {
                foreach (ExternalCondition ec in cod.externalConditions)
                {
                    if (ec.contractDefinition != null)
                    {
                        if (rid == ec.contractDefinition.reservedRequestId)
                        {
                            ecs.Add(ec);
                        }
                    }
                }


            }

            return ecs;
        }
    }


}
