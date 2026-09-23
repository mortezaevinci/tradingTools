/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using IBSampleApp.messages;
using IBApi;
using System.Windows.Forms;
using System.ComponentModel;
using IBSampleApp.util;
using System.Threading.Tasks;
using MHA;
using System.Threading;

namespace IBSampleApp.ui
{
    class OrderManager
    {

        public bool showMessages = false;
        public class GridOrder
        {
            public string Name;
            public string Text;
            public int Order;
            public bool isReadOnly;
            public int Width;


            public GridOrder(string name, string text, int order, bool isreadonly, int width)
            {
                Name = name;
                Text = text;
                Order = order;
                isReadOnly = isreadonly;
                Width = width;
            }
        }

        public enum GRIDORDER_VALS
        {
            GRIDORDER_TRANSMIT,
            GRIDORDER_STATUS,
            GRIDORDER_CONTRACT,
            GRIDORDER_SYMBOL,
            GRIDORDER_ACTION,
            GRIDORDER_TYPE,
            GRIDORDER_IBALGO,
            GRIDORDER_TOTALQTY,
            GRIDORDER_UNDERLYINGLAST,
            GRIDORDER_LMTPRICE,
            GRIDORDER_AUXPRICE,
            GRIDORDER_TRAILSTOPPRICE,
            GRIDORDER_LMTPRICEOFFSET,
            GRIDORDER_COND1,
            GRIDORDER_COND2,
            GRIDORDER_COND3,
            GRIDORDER_COND4,
            GRIDORDER_ACCOUNT,
            GRIDORDER_ORDERID,
            GRIDORDER_PERMID,
            GRIDORDER_CLIENTID,
            GRIDORDER_MODELCODE,
            GRIDORDER_CASHQTY,
            GRIDORDER_COUNT
        }

        public readonly GridOrder[] GRIDORDER = new GridOrder[] {
          new GridOrder("Transmit","Transmit",(int)GRIDORDER_VALS.GRIDORDER_TRANSMIT,false,20),
          new GridOrder("Status","Status",(int)GRIDORDER_VALS.GRIDORDER_STATUS,true,50),
          new GridOrder("Contract","Contract",(int)GRIDORDER_VALS.GRIDORDER_CONTRACT,true,130),
          new GridOrder("Symbol","Symbol",(int)GRIDORDER_VALS.GRIDORDER_SYMBOL,true,50),
          new GridOrder("Action","Action",(int)GRIDORDER_VALS.GRIDORDER_ACTION,true,50),
          new GridOrder("Type","Type",(int)GRIDORDER_VALS.GRIDORDER_TYPE,false,75),
          new GridOrder("IBALGO","IBALGO",(int)GRIDORDER_VALS.GRIDORDER_IBALGO,true,75),
          new GridOrder("QTY","QTY",(int)GRIDORDER_VALS.GRIDORDER_TOTALQTY,false,40),
          new GridOrder("Last","Last",(int)GRIDORDER_VALS.GRIDORDER_UNDERLYINGLAST, false,50),
          new GridOrder("LMT","LMT",(int)GRIDORDER_VALS.GRIDORDER_LMTPRICE,false,50),
          new GridOrder("AUX","AUX",(int)GRIDORDER_VALS.GRIDORDER_AUXPRICE,false,50),
          new GridOrder("TRAIL","TRAIL",(int)GRIDORDER_VALS.GRIDORDER_TRAILSTOPPRICE,false,50),
          new GridOrder("LMTOFF","LMTOFF",(int)GRIDORDER_VALS.GRIDORDER_LMTPRICEOFFSET,false,50),
          new GridOrder("C1","C1",(int)GRIDORDER_VALS.GRIDORDER_COND1,true,150),
          new GridOrder("C2","C2",(int)GRIDORDER_VALS.GRIDORDER_COND2,true,150),
          new GridOrder("C3","C3",(int)GRIDORDER_VALS.GRIDORDER_COND3,true,150),
          new GridOrder("C4","C4",(int)GRIDORDER_VALS.GRIDORDER_COND4,true,150),
          new GridOrder("Account","Account",(int)GRIDORDER_VALS.GRIDORDER_ACCOUNT,true,50),
          new GridOrder("OID","OID",(int)GRIDORDER_VALS.GRIDORDER_ORDERID,true,40),
          new GridOrder("PID","PID",(int)GRIDORDER_VALS.GRIDORDER_PERMID,true,80),
          new GridOrder("CID","CID",(int)GRIDORDER_VALS.GRIDORDER_CLIENTID,true,40),
          new GridOrder("Model","Model",(int)GRIDORDER_VALS.GRIDORDER_MODELCODE,true,50),
          new GridOrder("CashQ","CashQ",(int)GRIDORDER_VALS.GRIDORDER_CASHQTY,true,50)

        };



        private OrderDialog orderDialog;
        private IBClient ibClient;
        private List<string> managedAccounts;

        public List<IBControlDefinition> presubmitOrders = new List<IBControlDefinition>();
        public List<OpenOrderMessage> openOrders = new List<OpenOrderMessage>();
        public List<CompletedOrderMessage> completedOrders = new List<CompletedOrderMessage>();

        private DataGridView liveOrdersGrid;
        private DataGridView completedOrdersGrid;
        private DataGridView tradeLogGrid;

        public IBClient IBClient { get { return ibClient; } }
        private NotifyIcon notifyIcon;

        public OrderManager(IBClient ibClient, DataGridView liveOrdersGrid, DataGridView completedOrdersGrid, DataGridView tradeLogGrid,NotifyIcon notifyIcon)
        {
            this.ibClient = ibClient;
            this.orderDialog = new OrderDialog(this);
            this.liveOrdersGrid = liveOrdersGrid;
            this.completedOrdersGrid = completedOrdersGrid;
            this.tradeLogGrid = tradeLogGrid;
            this.notifyIcon = notifyIcon;
        }

        public List<string> ManagedAccounts
        {
            get { return managedAccounts; }
            set 
            {
                orderDialog.SetManagedAccounts(value);
                managedAccounts = value;
            }
        }

        public int PlaceOrder(IBControlDefinition ibcd)
        {
            int retrycnt = 3;

            showMessages = true;

            Contract c = ibcd.orderWatchlists[0].contractDefinitions[0].contract;
            Order o = ibcd.orderWatchlists[0].orderDefinitions[0].order;
            OrderDefinition od = ibcd.orderWatchlists[0].orderDefinitions[0];
            o.Transmit = true;
            int orderid = 0;
            for (int i = 0; i < retrycnt; i++)
            {
                orderid = PlaceOrder(c, o);
                o.OrderId = orderid;
                Thread.Sleep(25);
                Application.DoEvents();
                if (orderid > 0) break;
            }
            Thread.Sleep(150);
            int ccnt = od.childOrderDefinitions.Count;
            if (orderid > 0)
            {
                for (int idc = 0; idc < ccnt; idc++)
                {
                    if (od.childOrderDefinitions[idc] == null) continue;
                    if (od.childOrderDefinitions[idc].order.OrderType.Contains("LMT") && od.childOrderDefinitions[idc].order.LmtPrice == 0) continue;
                    if (od.childOrderDefinitions[idc].order.OrderType.Contains("STP") && od.childOrderDefinitions[idc].order.AuxPrice == 0) continue;
                    if (od.childOrderDefinitions[idc].order.OrderType.Contains("TRAIL") && od.childOrderDefinitions[idc].order.AuxPrice == 0) continue;
                    if (od.childOrderDefinitions[idc].order.OrderType.Contains("MKT") && od.childOrderDefinitions[idc].order.Conditions.Count == 0) continue;
                    

                    od.childOrderDefinitions[idc].order.ParentId = orderid;
                    od.childOrderDefinitions[idc].order.Transmit = true;
                    for (int i = 0; i < retrycnt; i++)
                    {
                        int childorderid = PlaceOrder(c, od.childOrderDefinitions[idc].order);
                        od.childOrderDefinitions[idc].order.OrderId = childorderid;
                        Thread.Sleep(25);
                        Application.DoEvents();
                        if (childorderid > 0) break;
                    }
                    
                    Application.DoEvents();
                }
            }
            else
            {
               // MessageBox.Show("Order not placed.");
                notifyIcon.BalloonTipTitle = "Order";
                notifyIcon.BalloonTipText = "Order not placed.";
                notifyIcon.BalloonTipIcon = ToolTipIcon.Warning;
                notifyIcon.ShowBalloonTip(2000);
            }
            string fn = String.Concat(ibcd.orderWatchlists[0].contractDefinitions[0].generatedLocalSysmbol, " ", DateTime.Now.ToString("yyyy-MM-dd HH_mm_ss"), " ", o.Action, " ", o.LmtPrice.ToString(), " ", o.AuxPrice.ToString(), ".xml");

            ibcd.saveXML(fn);

            return orderid;
        }

        public int PlaceOrder(Contract contract, Order order)
        {
            if (order.OrderId != 0)
            {
                ibClient.ClientSocket.placeOrder(order.OrderId, contract, order);
                return order.OrderId;
            }
            else
            {
                ibClient.ClientSocket.placeOrder(ibClient.NextOrderId, contract, order);
                ibClient.NextOrderId++;
                return ibClient.NextOrderId - 1;
            }
        }

        public void OpenOrderDialog()
        {
            orderDialog.ShowDialog();
        }

        public void OpenNewOrderDialog()
        {
            orderDialog = new OrderDialog(this);

            orderDialog.ShowDialog();
        }
        /*
         *         public static readonly int (int)GRIDORDER_VALS.GRIDORDER_CONTRACT = 0;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_ACCOUNT = 8;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_ACTION = 1;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_TOTALQTY = 2;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_LMTPRICE = 3;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_AUXPRICE = 4;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_COND1 = 5;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_COND2 = 6;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_COND3 = 7;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_ORDERID = 11;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_PERMID = 10;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_CLIENTID = 12;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_MODELCODE = 13;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_STATUS = 9;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_CASHQTY = 14;
        public static readonly int (int)GRIDORDER_VALS.GRIDORDER_COUNT = 15;
        */

        public void modifyOrder(int r,int c)
        {
            if ((int)(liveOrdersGrid.Rows[r].Cells[(int)GRIDORDER_VALS.GRIDORDER_ORDERID].Value) != 0)//&& (int)(liveOrdersGrid.SelectedRows[0].Cells[(int)GRIDORDER_VALS.GRIDORDER_CLIENTID].Value) == ibClient.ClientId)
            {
                object val = liveOrdersGrid.Rows[r].Cells[c].Value;
                DataGridViewRow selectedRow = liveOrdersGrid.Rows[r];
                int orderId = (int)selectedRow.Cells[(int)GRIDORDER_VALS.GRIDORDER_ORDERID].Value;
                for (int i = 0; i < openOrders.Count; i++)
                {
                    if (openOrders[i].OrderId == orderId)
                    {
                        bool domodify = false;
                        switch (c)
                            {
                            case (int)GRIDORDER_VALS.GRIDORDER_ACTION:
                                {
                                    openOrders[i].Order.Action = val as string;
                                    domodify = true;
                                }
                                break;
                            case (int)GRIDORDER_VALS.GRIDORDER_TOTALQTY:
                                {
                                    try
                                    {
                                        openOrders[i].Order.TotalQuantity = Double.Parse(val as string);
                                        domodify = true;
                                    }
                                    catch { }
                                }
                                break;
                            case (int)GRIDORDER_VALS.GRIDORDER_LMTPRICE:
                                {
                                    try
                                    {
                                        openOrders[i].Order.LmtPrice = Double.Parse(val as string);
                                        domodify = true;
                                    }
                                    catch { }
                                }
                                break;
                            case (int)GRIDORDER_VALS.GRIDORDER_LMTPRICEOFFSET:
                                {
                                    try
                                    {
                                        openOrders[i].Order.LmtPriceOffset = Double.Parse(val as string);
                                        domodify = true;
                                    }
                                    catch { }
                                }
                                break;
                            case (int)GRIDORDER_VALS.GRIDORDER_AUXPRICE:
                                {
                                    try
                                    {
                                        openOrders[i].Order.AuxPrice = Double.Parse(val as string);
                                        domodify = true;
                                    }
                                    catch { }
                                }
                                break;
                            case (int)GRIDORDER_VALS.GRIDORDER_TRAILSTOPPRICE:
                                {
                                    try
                                    {
                                        openOrders[i].Order.TrailStopPrice = Double.Parse(val as string);
                                        domodify = true;
                                    }
                                    catch { }
                                }
                                break;
                            case (int)GRIDORDER_VALS.GRIDORDER_TYPE:
                                {
                                    try
                                    {
                                        openOrders[i].Order.OrderType = (val as string);
                                        domodify = true;
                                    }
                                    catch { }
                                }
                                break;
                            case (int)GRIDORDER_VALS.GRIDORDER_IBALGO:
                                {
                                    try
                                    {
                                        openOrders[i].Order.AlgoStrategy = (val as string);
                                        domodify = true;
                                    }
                                    catch { }
                                }
                                break;
                            case (int)GRIDORDER_VALS.GRIDORDER_TRANSMIT:
                                {
                                    try
                                    {
                                        //this is a whole different thing now
                                        //openOrders[i].Order.Transmit =!String.IsNullOrEmpty(val as string);
                                        //domodify = true;

                                    }
                                    catch { }
                                }
                                break;
                            default:
                                break;
                            }

                        if (domodify)
                        {
                            
                            IBClient.ClientSocket.placeOrder(orderId,openOrders[i].Contract, openOrders[i].Order);
                        }
                    }
                }

                
            }
        }

        public void EditOrder()
        {
            if (liveOrdersGrid.SelectedRows.Count > 0 && (int)(liveOrdersGrid.SelectedRows[0].Cells[(int)GRIDORDER_VALS.GRIDORDER_ORDERID].Value) != 0)//&& (int)(liveOrdersGrid.SelectedRows[0].Cells[(int)GRIDORDER_VALS.GRIDORDER_CLIENTID].Value) == ibClient.ClientId)
            {
                DataGridViewRow selectedRow = liveOrdersGrid.SelectedRows[0];
                int orderId = (int)selectedRow.Cells[(int)GRIDORDER_VALS.GRIDORDER_ORDERID].Value;
                for (int i = 0; i < openOrders.Count; i++)
                {
                    if (openOrders[i].OrderId == orderId)
                    {
                        orderDialog.SetOrderContract(openOrders[i].Contract);
                        orderDialog.SetOrder(openOrders[i].Order);
                    }
                }

                orderDialog.ShowDialog();
            }
        }


        public void AttachOrder()
        {
            if (liveOrdersGrid.SelectedRows.Count > 0 && (int)(liveOrdersGrid.SelectedRows[0].Cells[(int)GRIDORDER_VALS.GRIDORDER_ORDERID].Value) != 0)// && (int)(liveOrdersGrid.SelectedRows[0].Cells[(int)GRIDORDER_VALS.GRIDORDER_CLIENTID].Value) == ibClient.ClientId)
            {
                DataGridViewRow selectedRow = liveOrdersGrid.SelectedRows[0];
                int orderId = (int)selectedRow.Cells[(int)GRIDORDER_VALS.GRIDORDER_ORDERID].Value;
                for (int i = 0; i < openOrders.Count; i++)
                {
                    if (openOrders[i].OrderId == orderId)
                    {
                        orderDialog.SetOrderContract(openOrders[i].Contract);
                        orderDialog.SetOrder(openOrders[i].Order);

                        orderDialog.SetOrderId(ibClient.NextOrderId);
                        ibClient.NextOrderId++;
                        orderDialog.SetParentOrderId(orderId);
                    }
                }

                orderDialog.ShowDialog();
            }
        }

        public OpenOrderMessage GetSelectedOrder()
        {
            if (liveOrdersGrid.SelectedRows.Count > 0)
            {
                for (int i = 0; i < liveOrdersGrid.SelectedRows.Count; i++)
                {
                    int orderId = (int)liveOrdersGrid.SelectedRows[i].Cells[(int)GRIDORDER_VALS.GRIDORDER_ORDERID].Value;
                    int clientId = (int)liveOrdersGrid.SelectedRows[i].Cells[(int)GRIDORDER_VALS.GRIDORDER_CLIENTID].Value;
                    OpenOrderMessage openOrder = GetOpenOrderMessage(orderId, clientId);
                    if (openOrder != null)
                    {
                        return openOrder;
                    }
                }
            }
            return null;
        }

        public void CancelSelection()
        {
            if (liveOrdersGrid.SelectedRows.Count > 0)
            {
                for (int i = 0; i < liveOrdersGrid.SelectedRows.Count; i++)
                {
                    int orderId = (int)liveOrdersGrid.SelectedRows[i].Cells[(int)GRIDORDER_VALS.GRIDORDER_ORDERID].Value;
                    int clientId = (int)liveOrdersGrid.SelectedRows[i].Cells[(int)GRIDORDER_VALS.GRIDORDER_CLIENTID].Value;
                    OpenOrderMessage openOrder = GetOpenOrderMessage(orderId, clientId);
                    if (openOrder != null)
                    {
                        

                        ibClient.ClientSocket.cancelOrder(openOrder.OrderId);
                    }
                }
            }
        }

        private OpenOrderMessage GetOpenOrderMessage(int orderId, int clientId)
        {
            for (int i = 0; i < openOrders.Count; i++)
            {
                if (openOrders[i].Order.OrderId == orderId && openOrders[i].Order.ClientId == clientId)
                    return openOrders[i];
            }
            return null;
        }

        public void HandleCommissionMessage(CommissionMessage message)
        {
            for (int i = 0; i < tradeLogGrid.Rows.Count; i++)
            {
                if (((string)tradeLogGrid[0, i].Value).Equals(message.CommissionReport.ExecId))
                {
                    tradeLogGrid[8, i].Value = message.CommissionReport.Commission;
                    tradeLogGrid[9, i].Value = message.CommissionReport.RealizedPNL<10000000? message.CommissionReport.RealizedPNL:0;
                }
            }
        }

        public void handleOpenOrder(OpenOrderMessage openOrder)
        {
            if (openOrder.Order.WhatIf)
                orderDialog.HandleOpenOrder(openOrder);
            
            else
            {

                bool added=UpdateLiveOrders(openOrder);
                UpdateLiveOrdersGrid(openOrder);
                
            }
        }

        public void handleCompletedOrder(CompletedOrderMessage completedOrder)
        {

           // if(!completedOrder.OrderState.CompletedStatus.ToLower().Contains("cancelled") )
            UpdateCompletedOrdersGrid(completedOrder);
          
            completedOrders.Add(completedOrder);
           
        }

        public void HandleExecutionMessage(ExecutionMessage message)
        {
            for (int i = 0; i < tradeLogGrid.Rows.Count; i++)
            {
                if (((string)tradeLogGrid[0, i].Value).Equals(message.Execution.ExecId))
                {
                    PopulateTradeLog(i, message);
                }
            }
            tradeLogGrid.Rows.Add(1);
            PopulateTradeLog(tradeLogGrid.Rows.Count-1, message);
        }

        private void PopulateTradeLog(int index, ExecutionMessage message)
        {
            tradeLogGrid[0, index].Value = message.Execution.ExecId;
            tradeLogGrid[1, index].Value = message.Execution.Time;
            tradeLogGrid[2, index].Value = message.Execution.AcctNumber;
            tradeLogGrid[3, index].Value = message.Execution.ModelCode;
            tradeLogGrid[4, index].Value = message.Execution.Side;
            tradeLogGrid[5, index].Value = message.Execution.Shares;
            tradeLogGrid[6, index].Value =Utils.ContractToString( message.Contract);
            tradeLogGrid[7, index].Value = message.Execution.Price;
            tradeLogGrid["LastLiquidity", index].Value = message.Execution.LastLiquidity;
        }

        public void HandleOrderStatus(OrderStatusMessage statusMessage)
        {
            for (int i = 0; i < liveOrdersGrid.Rows.Count; i++)
            {
                if (liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_PERMID, i].Value!=null && liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_PERMID, i].Value.Equals(statusMessage.PermId))
                {
                    liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_STATUS, i].Value = statusMessage.Status;
                    return;
                }
            }
        }

        public void HandleSoftDollarTiers(SoftDollarTiersMessage msg)
        {
            orderDialog.HandleSoftDollarTiers(msg);
        }

        private void UpdateCompletedOrdersGrid(CompletedOrderMessage completedOrderMessage)
        {
            completedOrdersGrid.Rows.Add(1);
            PopulateCompletedOrderRow(completedOrdersGrid.Rows.Count - 1, completedOrderMessage);
        }


        private bool UpdateLiveOrders(OpenOrderMessage msg)
        {
            for (int i = 0; i < openOrders.Count; i++ )
            {
                if (openOrders[i].Order.PermId == msg.Order.PermId)
                {
                    openOrders[i] = msg;
                    return false;
                }
            }
            openOrders.Add(msg);

            //notify that order is added

            string des = String.Format("{0},{1},{2},{3},{4}",
            ContractDefinition.Tools.getLocalSymbol(msg.Contract),
            OrderDefinition.Tools.AccountInfo(msg.Order),
            OrderDefinition.Tools.MainInfo(msg.Order),
            OrderDefinition.Tools.TimeInForceInfo(msg.Order),
             msg.OrderState.CompletedStatus
             );
            if (showMessages)
            {
                //MessageBox.Show(des);
                notifyIcon.BalloonTipTitle = "Order";
                notifyIcon.BalloonTipText = des;
                notifyIcon.BalloonTipIcon = ToolTipIcon.Info;
                notifyIcon.ShowBalloonTip(3000);
            }

            return true;
        }

        private void UpdateLiveOrdersGrid(OpenOrderMessage orderMessage)
        {
            Console.WriteLine(String.Concat(orderMessage.OrderId,":", orderMessage.Contract.Symbol,"-", orderMessage.Contract.ToString()," ", orderMessage.Order.OrderId," ", orderMessage.Order.PermId));
            for (int i = 0; i<liveOrdersGrid.Rows.Count; i++)
            {
                if ((int)(liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_PERMID, i].Value) == orderMessage.Order.PermId)
                {
                    PopulateOrderRow(i, orderMessage);
                    return;
                }
            }
            AddToOrderGrid(orderMessage);


        }

        public void AddToOrderGrid(OpenOrderMessage orderMessage)
        {
            liveOrdersGrid.Rows.Add(1);
            PopulateOrderRow(liveOrdersGrid.Rows.Count - 1, orderMessage);

        }

        private void PopulateOrderRow(int rowIndex, OpenOrderMessage orderMessage)
        {
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_TYPE, rowIndex].Value = orderMessage.Order.OrderType;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_IBALGO, rowIndex].Value = orderMessage.Order.AlgoStrategy;
          
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_LMTPRICE, rowIndex].Value = orderMessage.Order.LmtPrice;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_LMTPRICEOFFSET, rowIndex].Value = orderMessage.Order.LmtPriceOffset;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_AUXPRICE, rowIndex].Value = orderMessage.Order.AuxPrice;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_TRAILSTOPPRICE, rowIndex].Value = orderMessage.Order.TrailStopPrice;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_TRANSMIT, rowIndex].Value = orderMessage.Order.Transmit?"X":"";

            int cnt=orderMessage.Order.Conditions.Count;

            for (int i=0;i<cnt;i++)
            {
                string conditiontext ="";
                int col = 0;
                if (i == 0)
                    col = (int)GRIDORDER_VALS.GRIDORDER_COND1;
                if (i == 1)
                    col = (int)GRIDORDER_VALS.GRIDORDER_COND2;
                if (i == 2)
                    col = (int)GRIDORDER_VALS.GRIDORDER_COND3;
                if (i == 3)
                    col = (int)GRIDORDER_VALS.GRIDORDER_COND4;

                OrderCondition oc = orderMessage.Order.Conditions[i];
                if (oc.Type== OrderConditionType.Price)
                {
                    
                    PriceCondition pc = oc as PriceCondition;

                    String symbol = "";
                    
                    conditiontext = TradeExtension.Conditions.PriceConditionText(pc);
                    conditiontext = String.Concat("P ", symbol, " ", conditiontext);
                }

                if (oc.Type == OrderConditionType.Volume)
                {

                    VolumeCondition pc = oc as VolumeCondition;

                    String symbol = "";

                    conditiontext = TradeExtension.Conditions.VolumeConditionText(pc);
                    conditiontext = String.Concat("V ", symbol, " ", conditiontext);
                }

                if (oc.Type== OrderConditionType.Time)
                {
                    TimeCondition tc = oc as TimeCondition;
                    string dirs = tc.IsMore ? "≥" : "≤";
                    conditiontext = String.Concat(tc.Time, dirs);
                }
                if (oc.Type == OrderConditionType.Margin)
                {
                    MarginCondition tc = oc as MarginCondition;
                    string dirs = tc.IsMore ? "≥" : "≤";
                    conditiontext = String.Concat("margin", dirs,tc.Percent,"%");
                }

                liveOrdersGrid[col, rowIndex].Value = conditiontext;
            }

          
            
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_PERMID, rowIndex].Value = orderMessage.Order.PermId;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_CLIENTID, rowIndex].Value = orderMessage.Order.ClientId;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_ORDERID, rowIndex].Value = orderMessage.Order.OrderId;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_ACCOUNT, rowIndex].Value = orderMessage.Order.Account;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_MODELCODE, rowIndex].Value = orderMessage.Order.ModelCode;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_ACTION, rowIndex].Value = orderMessage.Order.Action;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_TOTALQTY, rowIndex].Value = orderMessage.Order.TotalQuantity;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_CONTRACT, rowIndex].Value = ContractDefinition.Tools.uniqueKey(orderMessage.Contract);// Utils.ContractToString(orderMessage.Contract);
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_SYMBOL, rowIndex].Value = orderMessage.Contract.Symbol;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_STATUS, rowIndex].Value = orderMessage.OrderState.Status;
            liveOrdersGrid[(int)GRIDORDER_VALS.GRIDORDER_CASHQTY, rowIndex].Value = (orderMessage.Order.CashQty != Double.MaxValue ? orderMessage.Order.CashQty.ToString() : "");
        }

        private void PopulateCompletedOrderRow(int rowIndex, CompletedOrderMessage completedOrderMessage)
        {
            completedOrdersGrid[0, rowIndex].Value = completedOrderMessage.Order.PermId;
            completedOrdersGrid[1, rowIndex].Value = Util.LongMaxString(completedOrderMessage.Order.ParentPermId);
            completedOrdersGrid[2, rowIndex].Value = completedOrderMessage.Order.Account;
            completedOrdersGrid[3, rowIndex].Value = completedOrderMessage.Order.Action;
            completedOrdersGrid[4, rowIndex].Value = completedOrderMessage.Order.TotalQuantity;
            completedOrdersGrid[5, rowIndex].Value = completedOrderMessage.Order.CashQty;
            completedOrdersGrid[6, rowIndex].Value = completedOrderMessage.Order.FilledQuantity;
            completedOrdersGrid[7, rowIndex].Value = completedOrderMessage.Order.LmtPrice;
            completedOrdersGrid[8, rowIndex].Value = completedOrderMessage.Order.AuxPrice;
            completedOrdersGrid[9, rowIndex].Value = completedOrderMessage.Order.TrailStopPrice;
            completedOrdersGrid[10, rowIndex].Value = Utils.ContractToString(completedOrderMessage.Contract);
            completedOrdersGrid[11, rowIndex].Value = completedOrderMessage.OrderState.Status;
            completedOrdersGrid[12, rowIndex].Value = completedOrderMessage.OrderState.CompletedTime;
            completedOrdersGrid[13, rowIndex].Value = completedOrderMessage.OrderState.CompletedStatus;
        }

    }
}
