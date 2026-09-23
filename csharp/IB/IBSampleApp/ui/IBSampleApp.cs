/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using IBSampleApp.messages;
using IBApi;
using IBSampleApp.ui;
using IBSampleApp.util;
using IBSampleApp.types;
using System.Threading;
using System.Threading.Tasks;
using System.IO;
using System.Xml;
using MHA;
using System.Windows.Forms.DataVisualization.Charting;

namespace IBSampleApp
{
    public partial class IBSampleAppDialog : Form
    {

        Thread getpositions = null;


        private MarketDataManager marketDataManager;
        private DeepBookManager deepBookManager;
        private HistoricalDataManager historicalDataManager;
        private RealTimeBarsManager realTimeBarManager;
        private ScannerManager scannerManager;
        private OrderManager orderManager;
        private AccountManager accountManager;
        private ContractManager contractManager;
        private AdvisorManager advisorManager;
        private OptionsManager optionsManager;
        private AcctPosMultiManager acctPosMultiManager;
        private SymbolSamplesManager symbolSamplesManagerData;
        private SymbolSamplesManager symbolSamplesManagerContractInfo;
        private NewsManager newsManager;

        private IBClient ibClient;

        private bool isConnected = false;

        private const int MAX_LINES_IN_MESSAGE_BOX = 200;
        private const int REDUCED_LINES_IN_MESSAGE_BOX = 100;
        private int numberOfLinesInMessageBox = 0;
        private List<string> linesInMessageBox = new List<string>(MAX_LINES_IN_MESSAGE_BOX);
        private List<string> bboExchangeList = new List<string>();

        private EReaderMonitorSignal signal;

        private DataTable pnldataTable = new DataTable(),
            pnlSingledataTable = new DataTable(),
            historicalTickTable = new DataTable(),
            historicalTickBidAskTable = new DataTable(),
            historicalTickLastTable = new DataTable(),
            tickByTickLastTable = new DataTable(),
            tickByTickAllLastTable = new DataTable(),
            tickByTickBidAskTable = new DataTable(),
            tickByTickMidPointTable = new DataTable();

      

        public IBSampleAppDialog()
        {
            signal = new EReaderMonitorSignal();
            ibClient = new IBClient(signal);
            Main_init();

        }

        public void Main_init()
        { 
            InitializeComponent();


          

                historicalChart.ChartAreas["ChartArea1"].AxisX.LabelStyle.Format = "MM-dd HH:mm:ss";
                historicalChart.ChartAreas["ChartArea1"].AxisX.LabelStyle.Enabled = true;
                historicalChart.ChartAreas["ChartArea1"].AxisX.ScaleView.Zoomable = true;
                historicalChart.ChartAreas["ChartArea1"].AxisY.Maximum = double.NaN;
                historicalChart.ChartAreas["ChartArea1"].AxisY.Minimum = double.NaN;

                //historicalChart.ChartAreas["ChartArea2"].AxisX.LabelStyle.Format = "MM-dd HH:mm:ss";
                historicalChart.ChartAreas["ChartArea2"].AxisX.LabelStyle.Enabled = false;
                // historicalChart.ChartAreas["ChartArea2"].AxisX.ScaleView.Zoomable = false;
                //historicalChart.ChartAreas["ChartArea2"].AxisY.Maximum = double.NaN;
                //historicalChart.ChartAreas["ChartArea2"].AxisY.Minimum = double.NaN;
            

            marketDataManager = new MarketDataManager(ibClient, marketDataGrid_MDT);


            deepBookManager = new DeepBookManager(ibClient, deepBookGrid, mktDepthExchangesGrid_MDT);
            historicalDataManager = new HistoricalDataManager(ibClient, historicalChart, barsGrid);
            realTimeBarManager = new RealTimeBarsManager(ibClient, rtBarsChart, rtBarsGrid);
            scannerManager = new ScannerManager(ibClient, scannerGrid, scannerParamsOutput);


            orderManager = new OrderManager(ibClient, liveOrdersGrid, completedOrdersGrid, tradeLogGrid, notifyIconSample);

            DataGridViewTextBoxColumn[] liveOrdersBoxColumns = new System.Windows.Forms.DataGridViewTextBoxColumn[orderManager.GRIDORDER.Length];

            for (int i = 0; i < orderManager.GRIDORDER.Length; i++)
            {
                liveOrdersBoxColumns[i] = new DataGridViewTextBoxColumn();
                liveOrdersBoxColumns[i].HeaderText = orderManager.GRIDORDER[i].Text;
                liveOrdersBoxColumns[i].Name = orderManager.GRIDORDER[i].Name;
                liveOrdersBoxColumns[i].ReadOnly = orderManager.GRIDORDER[i].isReadOnly;
                liveOrdersBoxColumns[i].Width = orderManager.GRIDORDER[i].Width;

                liveOrdersGrid.Columns.Add(liveOrdersBoxColumns[i]);
            }

            liveOrdersGrid.Sort(liveOrdersBoxColumns[1], ListSortDirection.Ascending);


            accountManager = new AccountManager(ibClient, accountSelector, accSummaryGrid, accountValuesGrid, accountPortfolioGrid, positionsGrid, familyCodesGrid);
            contractManager = new ContractManager(ibClient, fundamentalsOutput, contractDetailsGrid, bondContractDetailsGrid, comboBoxMarketRuleId, dataGridViewMarketRule, labelMarketRuleIdRes);
            advisorManager = new AdvisorManager(ibClient, advisorAliasesGrid, advisorGroupsGrid, advisorProfilesGrid);
            optionsManager = new OptionsManager(ibClient, optionChainCallGrid, optionChainPutGrid, optionPositionsGrid, listViewOptionParams);
            acctPosMultiManager = new AcctPosMultiManager(ibClient, positionsMultiGrid, accountUpdatesMultiGrid);
            symbolSamplesManagerData = new SymbolSamplesManager(ibClient, symbolSamplesDataGridData);
            symbolSamplesManagerContractInfo = new SymbolSamplesManager(ibClient, symbolSamplesDataGridContractInfo);
            newsManager = new NewsManager(ibClient, dataGridViewNewsTicks, dataGridViewNewsProviders, textBoxNewsArticle, dataGridViewHistoricalNews);
            pnlMgr = new PnLManager(ibClient);


            formOrderWatchlists = new List<FormOrderWatchlist>();

            CB_HistType.SelectedIndex = 1;


            pnldataTable.Columns.Add("Daily PnL");
            pnldataTable.Columns.Add("Unrealized PnL");
            pnldataTable.Columns.Add("Realized PnL");

            pnlSingledataTable.Columns.Add("Pos");
            pnlSingledataTable.Columns.Add("Daily PnL");
            pnlSingledataTable.Columns.Add("Unrealized PnL");
            pnlSingledataTable.Columns.Add("Realized PnL");
            pnlSingledataTable.Columns.Add("Value");

            Func<string, DataColumn> toDataColumn = i => new DataColumn() { ColumnName = i };

            historicalTickTable.Columns.AddRange(new[] { "Time", "Price", "Size" }.Select(toDataColumn).ToArray());
            historicalTickBidAskTable.Columns.AddRange(
                new[] { "Time", "Price bid", "Price ask", "Size bid", "Size ask", "Bid/Ask Tick Attribs" }.Select(toDataColumn).ToArray());
            historicalTickLastTable.Columns.AddRange(
                new[] { "Time", "Price", "Size", "Exchange", "Special Conditions", "Last Tick Attribs" }.Select(toDataColumn).ToArray());

            tickByTickLastTable.Columns.AddRange(new[] { "Time", "Price", "Size", "Exchange", "Special Conditions", "PastLimit" }.Select(toDataColumn).ToArray());
            tickByTickAllLastTable.Columns.AddRange(new[] { "Time", "Price", "Size", "Exchange", "Special Conditions", "PastLimit", "Unreported" }.Select(toDataColumn).ToArray());
            tickByTickBidAskTable.Columns.AddRange(new[] { "Time", "Bid Price", "Ask Price", "Bid Size", "Ask Size", "BidPastLow", "AskPastHigh" }.Select(toDataColumn).ToArray());
            tickByTickMidPointTable.Columns.AddRange(new[] { "Time", "Mid Point" }.Select(toDataColumn).ToArray());

            mdContractRight.Items.AddRange(ContractRight.GetAll());
            mdContractRight.SelectedIndex = 0;

            conDetRight.Items.AddRange(ContractRight.GetAll());
            conDetRight.SelectedIndex = 0;

            fundamentalsReportType.Items.AddRange(FundamentalsReport.GetAll());
            fundamentalsReportType.SelectedIndex = 0;

            comboBoxMarketDataType_CDT.Items.AddRange(MarketDataType.GetAll());
            comboBoxMarketDataType_CDT.SelectedIndex = 0;

            comboBoxMarketDataType_MDT.Items.AddRange(MarketDataType.GetAll());
            comboBoxMarketDataType_MDT.SelectedIndex = 0;

            this.groupMethod.DataSource = AllocationGroupMethod.GetAsData();
            this.groupMethod.ValueMember = "Value";
            this.groupMethod.DisplayMember = "Name";

            this.profileType.DataSource = AllocationProfileType.GetAsData();
            this.profileType.ValueMember = "Value";
            this.profileType.DisplayMember = "Name";

            hdRequest_EndTime.Text = "";// String.Concat(DateTime.Now.ToString("yyyyMMdd")," 20:00:00");
            bboExchange_comboBox.DataSource = bboExchangeList;

            DateTime execFilterDefault = DateTime.Now.AddHours(-1);
           // execFilterTime.Text = execFilterDefault.ToString("yyyyMMdd HH:mm:ss");

            DateTime endDateTime = DateTime.Now.AddDays(-3);
            textBoxHistoricalNewsEndDateTime.Text = endDateTime.ToString("yyyy-MM-dd HH:mm:ss.0");

            DateTime startDateTime = DateTime.Now.AddDays(-4);
            textBoxHistoricalNewsStartDateTime.Text = startDateTime.ToString("yyyy-MM-dd HH:mm:ss.0");

            textBoxNewsArticlePath.Text = Directory.GetCurrentDirectory();

            ibClient.Error += ibClient_Error;
            ibClient.ConnectionClosed += ibClient_ConnectionClosed;
            ibClient.CurrentTime += time => addTextToBox("Current Time: " + time + "\n");
            ibClient.TickPrice += ibClient_Tick;
            ibClient.TickSize += ibClient_Tick;
            // ibClient.TickString += (tickerId, tickType, value) => addTextToBox("Tick string. Ticker Id:" + tickerId + ", Type: " + TickType.getField(tickType) + ", Value: " + value + "\n");
            //  ibClient.TickGeneric += (tickerId, field, value) => addTextToBox("Tick Generic. Ticker Id:" + tickerId + ", Field: " + TickType.getField(field) + ", Value: " + value + "\n");
            ibClient.TickEFP += (tickerId, tickType, basisPoints, formattedBasisPoints, impliedFuture, holdDays, futureLastTradeDate, dividendImpact, dividendsToLastTradeDate) => addTextToBox("TickEFP. " + tickerId + ", Type: " + tickType + ", BasisPoints: " + basisPoints + ", FormattedBasisPoints: " + formattedBasisPoints + ", ImpliedFuture: " + impliedFuture + ", HoldDays: " + holdDays + ", FutureLastTradeDate: " + futureLastTradeDate + ", DividendImpact: " + dividendImpact + ", DividendsToLastTradeDate: " + dividendsToLastTradeDate + "\n");
            ibClient.TickSnapshotEnd += tickerId => addTextToBox("TickSnapshotEnd: " + tickerId + "\n");
            ibClient.NextValidId += UpdateUI;
            //  ibClient.DeltaNeutralValidation += (reqId, deltaNeutralContract) =>
            //      addTextToBox("DeltaNeutralValidation. " + reqId + ", ConId: " + deltaNeutralContract.ConId + ", Delta: " + deltaNeutralContract.Delta + ", Price: " + deltaNeutralContract.Price + "\n");

            ibClient.ManagedAccounts += UpdateUI;
            ibClient.TickOptionCommunication += HandleTickMessage;

            ibClient.AccountSummary += accountManager.HandleAccountSummary;
            ibClient.AccountSummaryEnd += UpdateUI;
            ibClient.UpdateAccountValue += accountManager.HandleAccountValue;
            ibClient.UpdatePortfolio += UpdateUI;
            
            ibClient.UpdateAccountTime += message => accUpdatesLastUpdateValue.Text = message.Timestamp;
            //ibClient.AccountDownloadEnd += (do nothing)
            ibClient.OrderStatus += orderManager.HandleOrderStatus;

            ibClient.OpenOrder += orderManager.handleOpenOrder;
            ibClient.OpenOrder += handleOpenOrder;
            //ibClient.OpenOrderEnd += (do nothing)

            ibClient.CommissionReport += commissionReport => orderManager.HandleCommissionMessage(new CommissionMessage(commissionReport));
            ibClient.FundamentalData += UpdateUI;

            ibClient.HistoricalData += historicalDataManager.AddHistoricalData;
            ibClient.HistoricalDataUpdate += historicalDataManager.UpdateHistoricalData;
            ibClient.HistoricalDataEnd += historicalDataManager.UpdateUI;

            ibClient.RealtimeBar += realTimeBarManager.UpdateUI;

            ibClient.ContractDetails += HandleContractDataMessage;
            ibClient.ContractDetailsEnd += reqId => UpdateUI(new ContractDetailsEndMessage());
            ibClient.ExecDetails += orderManager.HandleExecutionMessage;
            ibClient.ExecDetailsEnd += reqId => addTextToBox("ExecDetailsEnd. " + reqId + "\n");
            ibClient.HistoricalNews += newsManager.UpdateUI;
            ibClient.HistoricalNewsEnd += newsManager.UpdateUI;
            ibClient.SecurityDefinitionOptionParameter += optionsManager.UpdateUI;
            ibClient.MarketDataType += UpdateUI;
            ibClient.UpdateMktDepth += deepBookManager.UpdateUI;
            ibClient.UpdateMktDepthL2 += deepBookManager.UpdateUI;
            ibClient.UpdateNewsBulletin += (msgId, msgType, message, origExchange) =>
                addTextToBox("News Bulletins. " + msgId + " - Type: " + msgType + ", Message: " + message + ", Exchange of Origin: " + origExchange + "\n");

            ibClient.Position += accountManager.HandlePosition;
            ibClient.PositionEnd += () => addTextToBox("PositionEnd \n");

            ibClient.ScannerParameters += xml => scannerManager.UpdateUI(new ScannerParametersMessage(xml));
            ibClient.ScannerParameters += UpdateUi;
            ibClient.ScannerData += scannerManager.UpdateUI;

            ibClient.ScannerDataEnd += reqId => addTextToBox("ScannerDataEnd. " + reqId + "\r\n");
            ibClient.ReceiveFA += advisorManager.UpdateUI;
            ibClient.BondContractDetails += contractManager.HandleBondContractMessage;
            ibClient.VerifyMessageAPI += apiData => addTextToBox("verifyMessageAPI: " + apiData);
            ibClient.VerifyCompleted += (isSuccessful, errorText) => addTextToBox("verifyCompleted. IsSuccessfule: " + isSuccessful + " - Error: " + errorText);
            ibClient.VerifyAndAuthMessageAPI += (apiData, xyzChallenge) => addTextToBox("verifyAndAuthMessageAPI: " + apiData + " " + xyzChallenge);
            ibClient.VerifyAndAuthCompleted += (isSuccessful, errorText) => addTextToBox("verifyAndAuthCompleted. IsSuccessful: " + isSuccessful + " - Error: " + errorText);
            ibClient.DisplayGroupList += (reqId, groups) => addTextToBox("DisplayGroupList. Request: " + reqId + ", Groups" + groups);
            ibClient.DisplayGroupUpdated += (reqId, contractInfo) => addTextToBox("displayGroupUpdated. Request: " + reqId + ", ContractInfo: " + contractInfo);

            ibClient.PositionMulti += acctPosMultiManager.HandlePositionMulti;
            ibClient.PositionMultiEnd += reqId => acctPosMultiManager.HandlePositionMultiEnd(new PositionMultiEndMessage(reqId));
            ibClient.AccountUpdateMulti += acctPosMultiManager.HandleAccountUpdateMulti;
            ibClient.AccountUpdateMultiEnd += reqId => acctPosMultiManager.HandleAccountUpdateMultiEnd(new AccountUpdateMultiEndMessage(reqId));

            //ibClient.SecurityDefinitionOptionParameterEnd += (do nothing)
            ibClient.SoftDollarTiers += orderManager.HandleSoftDollarTiers;
            ibClient.FamilyCodes += (familyCodes) => accountManager.HandleFamilyCodes(new FamilyCodesMessage(familyCodes));
            ibClient.SymbolSamples += UpdateUI;
            ibClient.MktDepthExchanges += (depthMktDataDescriptions) => deepBookManager.HandleMktDepthExchangesMessage(new MktDepthExchangesMessage(depthMktDataDescriptions));
            ibClient.TickNews += newsManager.UpdateUI;
            ibClient.TickReqParams += UpdateUI;
            ibClient.SmartComponents += (reqId, theMap) => theMap.ToList().ForEach(i => dataGridViewSmartComponents.Rows.Add(new object[] { i.Key, i.Value.Key, i.Value.Value }));
            ibClient.NewsProviders += (newsProviders) => newsManager.HandleNewsProviders(new NewsProvidersMessage(newsProviders));
            ibClient.NewsArticle += newsManager.UpdateUI;

            ibClient.HeadTimestamp += UpdateUI;
            ibClient.HistogramData += UpdateUI;
            ibClient.RerouteMktDataReq += (reqId, conId, exchange) => addTextToBox("Re-route market data request. ReqId: " + reqId + ", ConId: " + conId + ", Exchange: " + exchange + "\n");
            ibClient.RerouteMktDepthReq += (reqId, conId, exchange) => addTextToBox("Re-route market depth request. ReqId: " + reqId + ", ConId: " + conId + ", Exchange: " + exchange + "\n");
            ibClient.MarketRule += contractManager.HandleMarketRuleMessage;
            ibClient.pnl += msg => pnldataTable.Rows.Add(msg.DailyPnL, msg.UnrealizedPnL, msg.RealizedPnL);
            ibClient.pnlSingle += msg => pnlSingledataTable.Rows.Add(msg.Pos, msg.DailyPnL, msg.UnrealizedPnL, msg.RealizedPnL, msg.Value);
            ibClient.historicalTick += UpdateUI;
            ibClient.historicalTickBidAsk += UpdateUI;
            ibClient.historicalTickLast += UpdateUI;
            ibClient.tickByTickAllLast += UpdateUI;
            ibClient.tickByTickBidAsk += UpdateUI;
            ibClient.tickByTickMidPoint += UpdateUI;
            ibClient.OrderBound += msg => addTextToBox("Order bound. OrderId: " + msg.OrderId + ", ApiClientId: " + msg.ApiClientId + ", ApiOrderId: " + msg.ApiOrderId);
            ibClient.CompletedOrder += orderManager.handleCompletedOrder;
            //ibClient.CompletedOrderEnd += (do nothing)

            TabControl.SelectedTab = tradingTab;
        }


        private void UpdateUi(string xml)
        {
            XmlDocument doc = new XmlDocument();

            doc.LoadXml(xml);

            var filters = doc.SelectNodes("//AbstractField/code").OfType<XmlNode>().ToList().Select(n => n.InnerText).ToArray();

            comboBoxFilterName.Items.AddRange(filters);
        }

        private void UpdateUI(TickByTickMidPointMessage msg)
        {
            dataGridViewTickByTick.DataSource = tickByTickMidPointTable;
            tickByTickMidPointTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.MidPoint);
        }

        public void handleOpenOrder(OpenOrderMessage openOrder)
        {
            if (CB_AutoMarket.Checked)
            {
                Contract c = openOrder.Contract.Copy();
                c.Exchange = "SMART";
                marketDataManager.AddRequest(c, "");

                //also add underlying for contracts
                Contract cstk = ContractDefinition.Tools.getGenericContract(c.Symbol);
                marketDataManager.AddRequest(cstk, "");
            }

            int gcnt =accountManager.positionsGrid.Rows.Count;
            for (int i = 0; i < gcnt - 1; i++)
            {
                string cs = ContractDefinition.Tools.uniqueKey(openOrder.Contract);
                if (( (double)positionsGrid[2, i].Value)== 0 || cs.Equals((string)positionsGrid[0, i].Value))
                {
                    positionsGrid[0, i].Style.BackColor = Color.LightGreen;
                }
            }
        }

    
        private void UpdateUI(TickByTickBidAskMessage msg)
        {
            dataGridViewTickByTick.DataSource = tickByTickBidAskTable;
            tickByTickBidAskTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.BidPrice, msg.AskPrice, msg.BidSize, msg.AskSize, msg.TickAttribBidAsk.BidPastLow, msg.TickAttribBidAsk.AskPastHigh);
        }

        private void UpdateUI(TickByTickAllLastMessage msg)
        {
            if (msg.TickType == 1)
            {
                dataGridViewTickByTick.DataSource = tickByTickLastTable;
                tickByTickLastTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.Price, msg.Size, msg.Exchange, msg.SpecialConditions, msg.TickAttribLast.PastLimit);
            }
            else if (msg.TickType == 2)
            {
                dataGridViewTickByTick.DataSource = tickByTickAllLastTable;
                tickByTickAllLastTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.Price, msg.Size, msg.Exchange, msg.SpecialConditions, msg.TickAttribLast.PastLimit, msg.TickAttribLast.Unreported);
            }
        }

        private void UpdateUI(HistoricalTickLastMessage msg)
        {
            dataGridViewHistoricalTicks.DataSource = historicalTickLastTable;

            historicalTickLastTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.Price, msg.Size, msg.Exchange, msg.SpecialConditions, msg.TickAttribLast.toString());
        }

        private void UpdateUI(HistoricalTickBidAskMessage msg)
        {
            dataGridViewHistoricalTicks.DataSource = historicalTickBidAskTable;

            historicalTickBidAskTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.PriceBid, msg.PriceAsk, msg.SizeBid, msg.SizeAsk, msg.TickAttribBidAsk.toString());
        }

        private void UpdateUI(HistoricalTickMessage msg)
        {
            dataGridViewHistoricalTicks.DataSource = historicalTickTable;

            historicalTickTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.Price, msg.Size);
        }

        private void UpdateUI(HistogramDataMessage obj)
        {
            if (histogramSubscriptionList.Contains(obj.ReqId))
                obj.Data.ToList().ForEach(i => histogramDataGridView.Rows.Add(new object[] { obj.ReqId, i.Price, i.Size }));
        }

        void ibClient_Tick(TickSizeMessage msg)
        {
            // addTextToBox("Tick Size. Ticker Id:" + msg.RequestId + ", Type: " + TickType.getField(msg.Field) + ", Size: " + msg.Size + "\n");

            if (msg.RequestId < OptionsManager.OPTIONS_ID_BASE)
            {
                if (marketDataManager.IsUIUpdateRequired(msg))
                    marketDataManager.UpdateUI(msg);
            }
            else
            {
                HandleTickMessage(msg);
            }
        }

        public void orderManagerEvaluateMarketData(TickPriceMessage dataMessage)
        {

            switch (dataMessage.Field)
            {

                case TickType.LAST:
                case TickType.DELAYED_LAST:

                    int nn = orderManager.openOrders.Count;
                    for (int n = 0; n < nn; n++)
                    {
                        OpenOrderMessage o = orderManager.openOrders[n];
                        // string symbol = o.Contract.Symbol;
                        Contract cstk = ContractDefinition.Tools.getGenericContract(o.Contract.Symbol);
                        if (marketDataManager.uniquesymbolreqids.ContainsKey(ContractDefinition.Tools.uniqueKey(cstk)))
                        {
                            if (marketDataManager.uniquesymbolreqids[ContractDefinition.Tools.uniqueKey(cstk)] == dataMessage.RequestId)
                            {
                                int orderid = o.OrderId;
                                bool foundgrid = false;
                                int r = 0;
                                for (r = 0; r < liveOrdersGrid.Rows.Count; r++)
                                {
                                    if ((int)liveOrdersGrid[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_ORDERID, r].Value == orderid)
                                    {
                                        foundgrid = true;
                                        break;
                                    }

                                }
                                if (foundgrid)
                                {

                                    {
                                        //LAST, DELAYED_LAST
                                        liveOrdersGrid[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_UNDERLYINGLAST, r].Value = dataMessage.Price.ToString();

                                        double thresh = 0.05;

                                        if (dataMessage.Price > 10)
                                            thresh = 0.1;
                                        if (dataMessage.Price > 50)
                                            thresh = 0.15;
                                        if (dataMessage.Price > 100)
                                            thresh = 0.25;
                                        if (dataMessage.Price > 300)
                                            thresh = 0.4;
                                        if (dataMessage.Price > 800)
                                            thresh = 0.5;



                                        //now check whether it is close
                                        bool somethingclose = false;
                                        if (Math.Abs(o.Order.LmtPrice - dataMessage.Price) < thresh)
                                        {
                                            liveOrdersGrid[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_LMTPRICE, r].Style.BackColor = Color.Pink;
                                            somethingclose = true;
                                        }
                                        else
                                        {
                                            liveOrdersGrid[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_LMTPRICE, r].Style.BackColor = Color.White;
                                        }

                                        if (Math.Abs(o.Order.AuxPrice - dataMessage.Price) < thresh)
                                        {
                                            liveOrdersGrid[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_AUXPRICE, r].Style.BackColor = Color.Pink;
                                            somethingclose = true;
                                        }
                                        else
                                        {
                                            liveOrdersGrid[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_AUXPRICE, r].Style.BackColor = Color.White;
                                        }

                                        if (Math.Abs(o.Order.TrailStopPrice - dataMessage.Price) < thresh)
                                        {
                                            liveOrdersGrid[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_TRAILSTOPPRICE, r].Style.BackColor = Color.Pink;
                                            somethingclose = true;
                                        }
                                        else
                                        {
                                            liveOrdersGrid[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_TRAILSTOPPRICE, r].Style.BackColor = Color.White;
                                        }

                                        double priceconditionprice = -500;
                                        int gridlocation = 0;
                                        for (int ci = 0; ci < o.Order.Conditions.Count; ci++)
                                        {
                                            if (o.Order.Conditions[ci].Type == OrderConditionType.Price)
                                            {
                                                priceconditionprice = (o.Order.Conditions[ci] as PriceCondition).Price;
                                                if (ci == 0) gridlocation = (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND1;
                                                if (ci == 1) gridlocation = (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND2;
                                                if (ci == 2) gridlocation = (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND3;
                                                if (ci == 3) gridlocation = (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND4;
                                                break;
                                            }
                                        }


                                        if (Math.Abs(priceconditionprice - dataMessage.Price) < thresh)
                                        {
                                            liveOrdersGrid[gridlocation, r].Style.BackColor = Color.Pink;
                                            somethingclose = true;
                                        }
                                        else
                                        {
                                            liveOrdersGrid[gridlocation, r].Style.BackColor = Color.White;
                                        }



                                    }

                                }
                            }
                        }




                    }
                    break;
            }
        }

        void ibClient_Tick(TickPriceMessage msg)
        {
            // addTextToBox("Tick Price. Ticker Id:" + msg.RequestId + ", Type: " + TickType.getField(msg.Field) + ", Price: " + msg.Price + ", Pre-Open: " + msg.Attribs.PreOpen + "\n");

            if (true)//msg.RequestId < OptionsManager.OPTIONS_ID_BASE)
            {
                foreach (FormOrderWatchlist orderWatchlist in formOrderWatchlists)
                {
                    if (orderWatchlist != null && !orderWatchlist.IsDisposed)
                    {
                        orderWatchlist.evaluateMarketData(msg);
                    }
                }

                orderManagerEvaluateMarketData(msg);

                if (marketDataManager.IsUIUpdateRequired(msg))
                    marketDataManager.UpdateUI(msg);
            }

            if (msg.RequestId >= OptionsManager.OPTIONS_ID_BASE)
            {
                HandleTickMessage(msg);
            }
        }

        void ibClient_ConnectionClosed()
        {
            IsConnected = false;
            UpdateUI(new ConnectionStatusMessage(false));
        }

        void ibClient_Error(int id, int errorCode, string str, Exception ex)
        {
            if (ex != null)
            {
                addTextToBox("Error: " + ex);

                return;
            }

            if (id == 0 || errorCode == 0)
            {
                addTextToBox("Error: " + str + "\n");

                return;
            }

            ErrorMessage error = new ErrorMessage(id, errorCode, str);

            HandleErrorMessage(error);
        }


        private void addTextToBox(string text)
        {
            HandleErrorMessage(new ErrorMessage(-1, -1, text));
        }


        public bool IsConnected
        {
            get { return isConnected; }
            set { isConnected = value; }
        }

        private delegate void StatusDelegate(string text);
        private void WriteStatusCtSafe(string text)
        {
            if (status_CT.InvokeRequired)
            {
                var d = new StatusDelegate(WriteStatusCtSafe);
                status_CT.Invoke(d, new object[] { text });
            }
            else
            {
                status_CT.Text = text;
            }
        }

        private delegate void StatusBDelegate(string text);
        private void WriteStatusBSafe(string text)
        {
            if (connectButton.InvokeRequired)
            {
                var d = new StatusDelegate(WriteStatusBSafe);
                connectButton.Invoke(d, new object[] { text });
            }
            else
            {
                connectButton.Text = text;
            }
        }

        private void UpdateUI(ConnectionStatusMessage statusMessage)
        {
            IsConnected = statusMessage.IsConnected;

            isConnectedUpdate(IsConnected);
        }

        private void isConnectedUpdate(bool IsConnected)
        {
            if (IsConnected)
            {
                //status_CT.Text = "Connected! Your client Id: " + ibClient.ClientId;
                //connectButton.Text = "Disconnect";
                WriteStatusCtSafe("Connected! Your client Id: " + ibClient.ClientId);
                WriteStatusBSafe("Disconnect");
            }
            else
            {
                //status_CT.Text = "Disconnected...";
                //connectButton.Text = "Connect";
                WriteStatusCtSafe("Disconnected...");
                WriteStatusBSafe("Connect");



                marketDataManager.uniquesymbolreqids.Clear();
            }
        }

        private void UpdateUI(ManagedAccountsMessage message)
        {
            orderManager.ManagedAccounts = message.ManagedAccounts;
            accountManager.ManagedAccounts = message.ManagedAccounts;
            exerciseAccount.Items.AddRange(message.ManagedAccounts.ToArray());
        }

        private void UpdateUI(AccountSummaryEndMessage message)
        {
            accSummaryRequest.Text = "Request";

            accountManager.HandleAccountSummaryEnd();
        }

        private void UpdateUI(UpdatePortfolioMessage message)
        {
            accountManager.HandlePortfolioValue(message);

            if (exerciseAccount.SelectedItem != null)
                optionsManager.HandlePosition(message);
        }

        private void UpdateUI(FundamentalsMessage message)
        {
            fundamentalsQueryButton.Enabled = true;

            contractManager.HandleFundamentalsData(message);
        }

        private void UpdateUI(ContractDetailsEndMessage message)
        {
            searchContractDetails.Enabled = true;

            contractManager.HandleContractDataEndMessage(message);
        }

        private void UpdateUI(MarketDataTypeMessage message)
        {
            if (marketDataManager.isActive())
            {
                marketDataManager.HandleMarketDataTypeMessage(message);
            }
        }

        private void UpdateUI(TickReqParamsMessage message)
        {
            bboExchange_comboBox.BindingContext[bboExchangeList].SuspendBinding();
            bboExchangeList.Add(((TickReqParamsMessage)message).BboExchange);
            bboExchange_comboBox.BindingContext[bboExchangeList].ResumeBinding();

            ReqSmartComponents_Button.Enabled = bboExchange_comboBox.Items.Count > 0;
        }

        private void UpdateUI(SymbolSamplesMessage message)
        {
            if (symbolSamplesManagerData.isActive())
            {
                symbolSamplesManagerData.UpdateUI(message);
            }
            if (symbolSamplesManagerContractInfo.isActive())
            {
                symbolSamplesManagerContractInfo.UpdateUI(message);
            }
        }

        private void HandleTickMessage(MarketDataMessage tickMessage)
        {
            if (!queryOptionChain.Enabled)
            {
                queryOptionChain.Enabled = true;
            }

            optionsManager.UpdateUI(tickMessage);
        }

        private void HandleContractDataMessage(ContractDetailsMessage message)
        {
            if (message.RequestId > ContractManager.CONTRACT_ID_BASE && message.RequestId < OptionsManager.OPTIONS_ID_BASE)
            {
                contractManager.UpdateUI(message);
            }
            else if (message.RequestId >= OptionsManager.OPTIONS_ID_BASE)
            {
                optionsManager.UpdateUI(message);
            }
        }

        private void HandleErrorMessage(ErrorMessage message)
        {

            ShowMessageOnPanel("Request " + message.RequestId + ", Code: " + message.ErrorCode + " - " + message.Message);

            if (message.RequestId > MarketDataManager.TICK_ID_BASE && message.RequestId < DeepBookManager.TICK_ID_BASE)
                marketDataManager.NotifyError(message.RequestId);
            else if (message.RequestId > DeepBookManager.TICK_ID_BASE && message.RequestId < HistoricalDataManager.HISTORICAL_ID_BASE)
            {
                if (message.ErrorCode != 2151)
                {
                    deepBookManager.NotifyError(message.RequestId);
                }
            }
            else if (message.RequestId == ContractManager.CONTRACT_DETAILS_ID)
            {
                contractManager.HandleRequestError(message.RequestId);
                searchContractDetails.Enabled = true;
            }
            else if (message.RequestId == ContractManager.FUNDAMENTALS_ID)
            {
                contractManager.HandleRequestError(message.RequestId);
                fundamentalsQueryButton.Enabled = true;
            }
            else if (message.RequestId == OptionsManager.OPTIONS_ID_BASE)
            {
                optionsManager.Clear();
                queryOptionChain.Enabled = true;
            }
            else if (message.RequestId > OptionsManager.OPTIONS_ID_BASE)
            {
                queryOptionChain.Enabled = true;
            }
            if (message.ErrorCode == 202)
            {
            }
        }

        private bool stopthreads = true;

        private class UpdateUiItems
        {
            public int res = 0;
        }

        private enum UpdateUiType
        {
            ClearPosition,
            Count
        }

        UpdateUiItems updateUiItem = new UpdateUiItems();


        delegate void UpdateUiDelegateCallback(UpdateUiType uitype, UpdateUiItems uiitem);
        private void UpdateUiDelegate(UpdateUiType uitype, UpdateUiItems uiitem)
        {
            if (this.IsDisposed) return;

            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (this.InvokeRequired)
            {
                try
                {
                    UpdateUiDelegateCallback d = new UpdateUiDelegateCallback(UpdateUiDelegate);
                    this.Invoke(d, new object[] { uitype, uiitem });
                }
                catch { }
            }
            else
            {
                if (uitype == UpdateUiType.ClearPosition)
                {
                    if (positionsGrid.IsDisposed) return;
                    positionsGrid.Rows.Clear();
                }

            }
        }


        private void asyncgetpositions()
        {
            while (stopthreads == false)
            {
                if (ibClient.ClientSocket.IsConnected())
                {
                    Thread.Sleep(1000);

                   // UpdateUiDelegate(UpdateUiType.ClearPosition, null);

                    foreach (FormOrderWatchlist orderWatchlist in formOrderWatchlists)
                    {
                        orderWatchlist.clearPositions();
                    }

                    //accountManager.positions.Clear();
                    ibClient.ClientSocket.reqPositions();
                    
                    Thread.Sleep(10000);

                }
            }
        }

        private void connectcontrol()
        {
            if (!IsConnected)
            {

                orderManager.openOrders.Clear();
                liveOrdersGrid.Rows.Clear();
                positionsGrid.Rows.Clear();
                accountManager.positions.Clear();

                int port;
                string host = this.host_CT.Text;

                if (host == null || host.Equals(""))
                    host = "127.0.0.1";
                try
                {
                    port = Int32.Parse(this.port_CT.Text);
                    ibClient.ClientId = Int32.Parse(this.clientid_CT.Text);
                    ibClient.ClientSocket.eConnect(host, port, ibClient.ClientId);

                    var reader = new EReader(ibClient.ClientSocket, signal);

                    reader.Start();

                    new Thread(() => { while (ibClient.ClientSocket.IsConnected()) { signal.waitForSignal(); reader.processMsgs(); } }) { IsBackground = true }.Start();

                    if (stopthreads)
                    {
                        stopthreads = false;
                        Thread getpositions = new Thread(asyncgetpositions);
                        getpositions.Start();
                    }

                }
                catch (Exception)
                {
                    HandleErrorMessage(new ErrorMessage(-1, -1, "Please check your connection attributes."));
                }
            }
            else
            {
                IsConnected = false;
                ibClient.ClientSocket.eDisconnect();

                marketDataManager.uniquesymbolreqids.Clear();
                stopthreads = true;

                try
                {
                    if (getpositions != null)
                        getpositions.Join(5000);
                }
                catch (Exception ex)
                {

                }
            }
        }


        private void connectButton_Click(object sender, EventArgs e)
        {
            connectcontrol();
        }

        private void marketData_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                Contract contract = GetMDContract();
                string genericTickList = this.genericTickList.Text;
                if (genericTickList == null)
                    genericTickList = "";
                marketDataManager.ForceRequest(contract, genericTickList, CB_Snapshot.Checked);
                ShowTab(marketData_MDT, topMarketDataTab_MDT);
            }
        }

        private void closeMketDataTab_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            marketDataManager.StopActiveRequests(true);
            this.marketData_MDT.TabPages.Remove(topMarketDataTab_MDT);
        }

        private void deepBook_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                Contract contract = GetMDContract();
                deepBookManager.AddRequest(contract, Int32.Parse(deepBookEntries.Text), cbSmartDepth.Checked);
                deepBookTab_MDT.Text = Utils.ContractToString(contract) + " (Book)";
                ShowTab(marketData_MDT, deepBookTab_MDT);
            }
        }

        private void closeDeepBookLink_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            deepBookManager.StopActiveRequests();
            deepBookTab_MDT.Text = "";
            this.marketData_MDT.TabPages.Remove(deepBookTab_MDT);
        }

        public void showHistoricaldata(Contract contract)
        {
            if (isConnected)
            {

                string endTime = hdRequest_EndTime.Text.Trim();
                string duration = hdRequest_Duration.Text.Trim() + " " + hdRequest_TimeUnit.Text.Trim();
                string barSize = hdRequest_BarSize.Text.Trim();
                string whatToShow = hdRequest_WhatToShow.Text.Trim();
                int outsideRTH = this.contractMDRTH.Checked ? 1 : 0;



                historicalDataManager.AddRequest(contract, endTime, duration, barSize, whatToShow, outsideRTH, 1, cbKeepUpToDate.Checked);
                historicalDataTab.Text = Utils.ContractToString(contract) + " (HD)";

                //ShowTab(marketData_MDT, historicalDataTab);
            }
        }

        private void histDataButton_Click(object sender, EventArgs e)
        {
            Contract contract = GetMDContract();



            handleHistoricalChart(contract);
        }

        private void histDataTabClose_MDT_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            this.marketData_MDT.TabPages.Remove(historicalDataTab);
        }

        private void realTime_Button_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                Contract contract = GetMDContract();
                string whatToShow = hdRequest_WhatToShow.Text.Trim(); //whattoshow could be "TRADES"
                realTimeBarManager.AddRequest(contract, whatToShow, true);
                rtBarsTab_MDT.Text = Utils.ContractToString(contract) + " (RTB)";
                ShowTab(marketData_MDT, rtBarsTab_MDT);
            }
        }

        private void rtBarsCloseLink_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            realTimeBarManager.Clear();
            this.marketData_MDT.TabPages.Remove(rtBarsTab_MDT);
        }

        private void scannerRequest_Button_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                ScannerSubscription subscription = new ScannerSubscription();
                subscription.ScanCode = scanCode.Text;
                subscription.Instrument = scanInstrument.Text;
                subscription.LocationCode = scanLocation.Text;
                subscription.StockTypeFilter = scanStockType.Text;
                subscription.NumberOfRows = Int32.Parse(scanNumRows.Text);
                List<TagValue> tagvalues = listViewFilterOptions.Items.OfType<ListViewItem>().Select(i => new TagValue(i.Text, i.SubItems[1].Text)).ToList();
                scannerManager.AddRequest(subscription, tagvalues);
                ShowTab(marketData_MDT, scannerTab);
            }
        }

        private void scannerParamsRequest_button_Click(object sender, EventArgs e)
        {
            scannerManager.RequestParameters();
            ShowTab(marketData_MDT, scannerParamsTab);
        }

        private void scannerTab_link_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            scannerManager.Clear();
            marketData_MDT.TabPages.Remove(scannerTab);
        }

        private double stringToDouble(string number)
        {
            if (number != null && !number.Equals(""))
                return Double.Parse(number);
            else
                return 0;
        }

        private Contract GetMDContract()
        {
            Contract contract = new Contract();
            contract.SecType = this.secType_TMD_MDT.Text;
            contract.Symbol = this.symbol_TMD_MDT.Text;
            contract.Exchange = this.exchange_TMD_MDT.Text;
            contract.Currency = this.currency_TMD_MDT.Text;
            contract.LastTradeDateOrContractMonth = this.lastTradeDateOrContractMonth_TMD_MDT.Text;
            contract.PrimaryExch = this.primaryExchange.Text;
            contract.IncludeExpired = includeExpired.Checked;

            if (!mdContractRight.Text.Equals("") && !mdContractRight.Text.Equals("None"))
                contract.Right = (string)((IBType)mdContractRight.SelectedItem).Value;

            contract.Strike = stringToDouble(this.strike_TMD_MDT.Text);
            contract.Multiplier = this.multiplier_TMD_MDT.Text;
            contract.LocalSymbol = this.localSymbol_TMD_MDT.Text;

            return contract;
        }

        private void messageBoxClear_link_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            numberOfLinesInMessageBox = 0;
            linesInMessageBox.Clear();
            messageBox.Clear();
        }

        private void ShowTab(TabControl tabControl, TabPage page)
        {
            if (!tabControl.Contains(page))
            {
                tabControl.TabPages.Add(page);
            }
            tabControl.SelectedTab = page;
        }

        private void newOrderLink_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            orderManager.OpenNewOrderDialog();
        }

        private void refreshOrdersButton_Click(object sender, EventArgs e)
        {
            orderManager.showMessages = false;
            orderManager.openOrders.Clear();
            liveOrdersGrid.Rows.Clear();

            OpenOrderMessage om;
            int cnt = orderManager.presubmitOrders.Count();
            int id = -1;
            for (int i = 0; i < cnt; i++)
            {
                OrderDefinition od = orderManager.presubmitOrders[i].orderWatchlists[0].orderDefinitions[0];
                Contract c = orderManager.presubmitOrders[i].orderWatchlists[0].contractDefinitions[0].contract;
                id = -i * 10;

                om = new OpenOrderMessage(id, c, od.order, new OrderState());
                orderManager.AddToOrderGrid(om);

                int cos = od.childOrderDefinitions.Count;
                for (int j = 0; j < cos; j++)
                {
                    Order co = od.childOrderDefinitions[j].order;
                    id = -i * 10 - j - 1;
                    om = new OpenOrderMessage(id, c, co, new OrderState());
                    orderManager.AddToOrderGrid(om);
                }
            }


            ibClient.ClientSocket.reqAllOpenOrders();
        }

        private void refreshExecutionsButton_Click(object sender, EventArgs e)
        {
            tradeLogGrid.Rows.Clear();

            ExecutionFilter execFilter = new ExecutionFilter();
            if (!execFilterClientId.Text.Equals(String.Empty))
                execFilter.ClientId = Int32.Parse(execFilterClientId.Text);
            execFilter.AcctCode = execFilterAccount.Text;
            execFilter.Time = execFilterTime.Text;
            execFilter.Symbol = execFilterSymbol.Text;
            execFilter.SecType = execFilterSecType.Text;
            execFilter.Exchange = execFilterExchange.Text;
            execFilter.Side = execFilterSide.Text;

            ibClient.ClientSocket.reqExecutions(1, execFilter);
        }

        private void bindOrdersButton_Click(object sender, EventArgs e)
        {
            ibClient.ClientSocket.reqAutoOpenOrders(true);
        }

        private void liveOrdersGrid_CellCoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            orderManager.EditOrder();
        }

        private void cancelOrdersButton_Click(object sender, EventArgs e)
        {
            OpenOrderMessage openOrder= orderManager.GetSelectedOrder();
            string ukey = ContractDefinition.Tools.uniqueKey(openOrder.Contract);
            if (accountManager.positions.ContainsKey(ukey))
            {
              DialogResult dr=  MessageBox.Show("Order has position. Still cancel?", "Warning", MessageBoxButtons.YesNo); ;
                if (dr== DialogResult.Yes)
                {

                    ibClient.ClientSocket.cancelOrder(openOrder.OrderId);
                }
            }
            else
            {
                ibClient.ClientSocket.cancelOrder(openOrder.OrderId);
            }

            //orderManager.openOrders.Clear();
           // orderManager.showMessages = false;
            //liveOrdersGrid.Rows.Clear();
            //ibClient.ClientSocket.reqAllOpenOrders();


        }

        private void clientOrdersButton_Click(object sender, EventArgs e)
        {
            orderManager.openOrders.Clear();
            liveOrdersGrid.Rows.Clear();
            orderManager.showMessages = false;
            ibClient.ClientSocket.reqOpenOrders();
        }

        private void globalCancelButton_Click(object sender, EventArgs e)
        {
            DialogResult dr = MessageBox.Show("ARE YOU SURE YOU WANT TO GLOBAL CANCEL?", "Warning", MessageBoxButtons.YesNo); ;
            if (dr == DialogResult.Yes)
            {
                dr = MessageBox.Show("THINK ABOUT IT ONE MORE TIME!", "Warning", MessageBoxButtons.YesNo); ;
                if (dr == DialogResult.Yes)
                {
                    ibClient.ClientSocket.reqGlobalCancel();
                }
            }
        }

        private void accSummaryRequest_Click(object sender, EventArgs e)
        {
            accSummaryRequest.Text = "Cancel";
            accountManager.RequestAccountSummary();
        }

        private void accUpdatesSubscribe_Click(object sender, EventArgs e)
        {
            if (accUpdatesSubscribe.Text.Equals("Subscribe"))
            {
                accUpdatesSubscribedAccount.Text = accountSelector.SelectedItem.ToString();
                accUpdatesSubscribe.Text = "Unsubscribe";
            }
            else
            {
                accUpdatesSubscribe.Text = "Subscribe";
            }
            accountManager.SubscribeAccountUpdates();
        }

        private void positionRequest_Click(object sender, EventArgs e)
        {
            accountManager.RequestPositions();
        }

        private void searchContractDetails_Click(object sender, EventArgs e)
        {
            Contract contract = GetConDetContract();
            if (contract.SecType.Equals("BOND"))
            {
                ShowTab(contractInfoTab, bondContractDetailsPage);
            }
            else
            {
                ShowTab(contractInfoTab, contractDetailsPage);
            }
            searchContractDetails.Enabled = false;
            contractManager.RequestContractDetails(contract);
        }

        private Contract GetConDetContract()
        {
            Contract contract = new Contract();
            contract.Symbol = this.conDetSymbol.Text;
            contract.SecType = this.conDetSecType.Text;
            contract.Exchange = this.conDetExchange.Text;
            contract.Currency = this.conDetCurrency.Text;
            contract.LastTradeDateOrContractMonth = this.conDetLastTradeDateOrContractMonth.Text;
            contract.Strike = stringToDouble(this.conDetStrike.Text);
            contract.Multiplier = this.conDetMultiplier.Text;
            contract.LocalSymbol = this.conDetLocalSymbol.Text;

            if (!conDetRight.Text.Equals("") && !conDetRight.Text.Equals("None"))
                contract.Right = (string)((IBType)conDetRight.SelectedItem).Value;

            return contract;
        }

        private void fundamentalsQueryButton_Click(object sender, EventArgs e)
        {
            ShowTab(contractInfoTab, fundamentalsPage);
            fundamentalsQueryButton.Enabled = false;
            Contract contract = GetConDetContract();
            string ftype = (string)((IBType)fundamentalsReportType.SelectedItem).Value;
            contractManager.RequestFundamentals(contract, ftype);
        }

        private void loadAliases_Click(object sender, EventArgs e)
        {
            advisorAliasesGrid.Rows.Clear();
            advisorManager.RequestFAData(FinancialAdvisorDataType.Aliases);
        }

        private void loadGroups_Click(object sender, EventArgs e)
        {
            advisorGroupsGrid.Rows.Clear();
            advisorManager.RequestFAData(FinancialAdvisorDataType.Groups);
        }

        private void loadProfiles_Click(object sender, EventArgs e)
        {
            advisorProfilesGrid.Rows.Clear();
            advisorManager.RequestFAData(FinancialAdvisorDataType.Profiles);
        }

        private void saveProfiles_Click(object sender, EventArgs e)
        {
            advisorManager.SaveProfiles();
        }

        private void saveGroups_Click(object sender, EventArgs e)
        {
            advisorManager.SaveGroups();
        }

        private void findComboContract_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            contractManager.IsComboLegRequest = true;
            contractManager.RequestContractDetails(GetComboContract());
        }

        private Contract GetComboContract()
        {
            Contract contract = new Contract();
            contract.Symbol = this.comboSymbol.Text;
            contract.SecType = this.comboSecType.Text;
            contract.Exchange = this.comboExchange.Text;
            contract.Currency = this.comboCurrency.Text;
            contract.LastTradeDateOrContractMonth = this.comboLastTradeDate.Text;
            contract.Strike = stringToDouble(this.comboStrike.Text);
            contract.Multiplier = this.comboMultiplier.Text;
            contract.LocalSymbol = this.comboLocalSymbol.Text;

            if (!comboRight.Text.Equals("") && !comboRight.Text.Equals("None"))
                contract.Right = (string)((IBType)comboRight.SelectedItem).Value;

            return contract;
        }

        private void queryOptionChain_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                queryOptionChain.Enabled = false;
                Contract underlying = GetConDetContract();
                underlying.SecType = "OPT";
                optionsManager.AddOptionChainRequest(underlying, this.optionChainExchange.Text, optionChainUseSnapshot.Checked);
                ShowTab(contractInfoTab, optionChainPage);

            }
        }

        private void exerciseAccount_SelectedIndexChanged(object sender, EventArgs e)
        {
            accountSelector.SelectedItem = exerciseAccount.SelectedItem;
            accountManager.SubscribeAccountUpdates();
        }

        private void ShowMessageOnPanel(string message)
        {
            try
            {
                message = ensureMessageHasNewline(message);

                if (numberOfLinesInMessageBox >= MAX_LINES_IN_MESSAGE_BOX)
                {
                    linesInMessageBox.RemoveRange(0, MAX_LINES_IN_MESSAGE_BOX - REDUCED_LINES_IN_MESSAGE_BOX);
                    messageBox.Lines = linesInMessageBox.ToArray();
                    numberOfLinesInMessageBox = REDUCED_LINES_IN_MESSAGE_BOX;
                }

                linesInMessageBox.Add(message);
                numberOfLinesInMessageBox += 1;
                this.messageBox.AppendText(message);
            }
            catch
            {
                Console.WriteLine("Error showing message.");
            }
        }

        private string ensureMessageHasNewline(string message)
        {
            if (message.Substring(message.Length - 1) != "\n")
            {
                return message + "\n";
            }
            else
            {
                return message;
            }
        }

        private void cancelMarketDataRequests_Click(object sender, EventArgs e)
        {
            marketDataManager.StopActiveRequests(false);
        }

        private void exerciseOption_Click(object sender, EventArgs e)
        {
            int ovrd = overrideOption.Checked == true ? 1 : 0;
            string exchange = optionExchange.Text;
            optionsManager.ExerciseOptions(ovrd, Int32.Parse(optionExerciseQuan.Text), exchange, 1);
        }

        private void lapseOption_Click(object sender, EventArgs e)
        {
            int ovrd = overrideOption.Checked == true ? 1 : 0;
            string exchange = optionExchange.Text;
            optionsManager.ExerciseOptions(ovrd, Int32.Parse(optionExerciseQuan.Text), exchange, 2);
        }

        private void optionsTab_Click(object sender, EventArgs e)
        {

        }

        private void buttonRequestPositionsMulti_Click(object sender, EventArgs e)
        {
            string account = this.textAccount.Text;
            string modelCode = this.textModelCode.Text;
            acctPosMultiManager.RequestPositionsMulti(account, modelCode);
        }

        private void buttonRequestAccountUpdatesMulti_Click(object sender, EventArgs e)
        {
            string account = this.textAccount.Text;
            string modelCode = this.textModelCode.Text;
            Boolean ledgerAndNLV = this.cbLedgerAndNLV.Checked;
            acctPosMultiManager.RequestAccountUpdatesMulti(account, modelCode, ledgerAndNLV);
        }

        private void buttonCancelPositionsMulti_Click(object sender, EventArgs e)
        {
            acctPosMultiManager.CancelPositionsMulti();
        }

        private void buttonCancelAccountUpdatesMulti_Click(object sender, EventArgs e)
        {
            acctPosMultiManager.CancelAccountUpdatesMulti();
        }

        private void clearPositionsMulti_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            acctPosMultiManager.ClearPositionsMulti();
        }

        private void clearAccountUpdatesMulti_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            acctPosMultiManager.ClearAccountUpdatesMulti();
        }

        private void queryOptionParams_Click(object sender, EventArgs e)
        {
            string symbol = conDetSymbol.Text;
            string exchange = conDetExchange.Text;
            string secType = conDetSecType.SelectedItem + "";
            int conId = string.IsNullOrWhiteSpace(underlyingConId.Text) ? int.MaxValue : int.Parse(underlyingConId.Text);

            optionsManager.SecurityDefinitionOptionParametersRequest(symbol, exchange, secType, conId);
            ShowTab(contractInfoTab, optionParametersPage);
        }

        private void requestFamilyCodes_Click(object sender, EventArgs e)
        {
            accountManager.RequestFamilyCodes();
        }

        private void clearFamilyCodes_Click(object sender, EventArgs e)
        {
            accountManager.ClearFamilyCodes();
        }

        private void requestMatchingSymbolsContractInfo_Click(object sender, EventArgs e)
        {
            symbolSamplesManagerData.unsetActive();
            symbolSamplesManagerContractInfo.setActive();
            symbolSamplesManagerData.Clear();
            symbolSamplesManagerContractInfo.AddRequest(conDetSymbol.Text);
            ShowTab(contractInfoTab, symbolSamplesTabContractInfo);
        }

        private void requestMatchingSymbolsData_Click(object sender, EventArgs e)
        {
            symbolSamplesManagerContractInfo.unsetActive();
            symbolSamplesManagerData.setActive();
            symbolSamplesManagerContractInfo.Clear();
            symbolSamplesManagerData.AddRequest(symbol_TMD_MDT.Text);
            ShowTab(marketData_MDT, symbolSamplesTabData);
        }

        private void clearSymbolSamplesContractInfo_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            symbolSamplesManagerContractInfo.Clear();
        }

        private void clearSymbolSamplesMarketData_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            symbolSamplesManagerData.Clear();
        }

        private void ReqMktDepthExchanges_Button_Click(object sender, EventArgs e)
        {
            deepBookManager.ReqMktDepthExchanges();
            ShowTab(marketData_MDT, mktDepthExchanges_MDT);
        }

        private void ClearMktDepthExchanges_Button_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            deepBookManager.ClearMktDepthExchanges();
        }

        private void comboBoxMarketDataType_CDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            marketDataManager.unsetActive();
            int marketDataType = (int)((IBType)comboBoxMarketDataType_CDT.SelectedItem).Value;
            marketDataManager.RequestMarketDataType(marketDataType);
            showMarketDataTypeSelectMessage(marketDataType);
        }

        private void comboBoxMarketDataType_MDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            marketDataManager.setActive();
            int marketDataType = (int)((IBType)comboBoxMarketDataType_MDT.SelectedItem).Value;
            marketDataManager.RequestMarketDataType(marketDataType);
            showMarketDataTypeSelectMessage(marketDataType);
        }

        private void showMarketDataTypeSelectMessage(int marketDataType)
        {
            if (isConnected)
            {
                if (marketDataType == (int)MarketDataType.Real_Time.Value)
                {
                    ShowMessageOnPanel("Frozen, Delayed and Delayed-Frozen market data types are disabled");
                }
                else if (marketDataType == (int)MarketDataType.Frozen.Value)
                {
                    ShowMessageOnPanel("Frozen market data type is enabled");
                }
                else if (marketDataType == (int)MarketDataType.Delayed.Value)
                {
                    ShowMessageOnPanel("Delayed market data type is enabled, Delayed-Frozen market data type is disabled");
                }
                else if (marketDataType == (int)MarketDataType.Delayed_Frozen.Value)
                {
                    ShowMessageOnPanel("Delayed and Delayed-Frozen market data types are enabled");
                }
                else
                {
                    ShowMessageOnPanel("Unknown market data type");
                }
            }
        }

        private void buttonReqNewsTicks_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                Contract contract = new Contract();
                contract.Symbol = this.textBoxNewsTicksSymbol.Text;
                contract.SecType = this.comboBoxNewsTicksSecType.Text;
                contract.Currency = this.textBoxNewsTicksCurrency.Text;
                contract.Exchange = this.textBoxNewsTicksExchange.Text;
                contract.PrimaryExch = this.textBoxNewsTicksPrimExchange.Text;

                newsManager.RequestNewsTicks(contract);

                ShowTab(tabControlNewsResults, tabPageTickNewsResults);
            }
        }

        private void linkLabelNewsTicksClear_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            newsManager.ClearTickNews();
        }

        private void buttonCancelNewsTicks_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                newsManager.CancelTickNews();
            }
        }

        private void dataGridViewNewsTicks_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            DataGridView dataGridView = (DataGridView)sender;
            if (e.RowIndex > -1)
            {
                DataGridViewRow dataGridViewRow = dataGridView.Rows[e.RowIndex];
                if (dataGridViewRow.Cells[dataGridViewNewsTicksProviderCode.Index].Value != null && dataGridViewRow.Cells[dataGridViewNewsTicksArticleId.Index].Value != null)
                {
                    textBoxNewsArticleProviderCode.Text = (String)dataGridViewRow.Cells[dataGridViewNewsTicksProviderCode.Index].Value;
                    textBoxNewsArticleArticleId.Text = (String)dataGridViewRow.Cells[dataGridViewNewsTicksArticleId.Index].Value;
                    ShowTab(tabControlNews, tabPageNewsArticle);
                }
            }
        }

        private void ReqSmartComponents_Button_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                ibClient.ClientSocket.reqSmartComponents(new Random(DateTime.Now.Millisecond).Next(), bboExchange_comboBox.SelectedItem + "");
                ShowTab(marketData_MDT, smartComponentsTabPage);
            }
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            this.dataGridViewSmartComponents.Rows.Clear();
        }

        private void buttonReqNewsProviders_Click(object sender, EventArgs e)
        {
            ShowTab(tabControlNewsResults, tabPageNewsProvidersResults);
            newsManager.RequestNewsProviders();
        }

        private void linkLabelClearNewsProviders_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            newsManager.ClearNewsProviders();
        }

        private void buttonRequestNewsArticle_Click(object sender, EventArgs e)
        {
            ShowTab(tabControlNewsResults, tabPageNewsArticleResults);
            newsManager.RequestNewsArticle(textBoxNewsArticleProviderCode.Text, textBoxNewsArticleArticleId.Text, textBoxNewsArticlePath.Text);
        }

        private void linkLabelClearNewsArticle_LinkClicked_1(object sender, LinkLabelLinkClickedEventArgs e)
        {
            newsManager.ClearArticleText();
        }


        private void buttonRequestHistoricalNews_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                int conId = string.IsNullOrWhiteSpace(textBoxHistoricalNewsContractId.Text) ? int.MaxValue : int.Parse(textBoxHistoricalNewsContractId.Text);
                string providerCodes = textBoxHistoricalNewsProviderCodes.Text;
                string startDateTime = textBoxHistoricalNewsStartDateTime.Text;
                string endDateTime = textBoxHistoricalNewsEndDateTime.Text;
                int totalResults = string.IsNullOrWhiteSpace(textBoxHistoricalNewsTotalResults.Text) ? 1 : int.Parse(textBoxHistoricalNewsTotalResults.Text);

                newsManager.RequestHistoricalNews(conId, providerCodes, startDateTime, endDateTime, totalResults);

                ShowTab(tabControlNewsResults, tabPageHistoricalNewsResults);
            }
        }

        private void linkLabelClearHistoricalNews_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            newsManager.ClearHistoricalNews();

        }

        private void dataGridViewHistoricalNews_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            DataGridView dataGridView = (DataGridView)sender;
            if (e.RowIndex > -1)
            {
                DataGridViewRow dataGridViewRow = dataGridView.Rows[e.RowIndex];

                if (dataGridViewRow.Cells[dataGridViewTextBoxProviderCode.Index].Value != null && dataGridViewRow.Cells[dataGridViewTextBoxArticleId.Index].Value != null)
                {
                    textBoxNewsArticleProviderCode.Text = (String)dataGridViewRow.Cells[dataGridViewTextBoxProviderCode.Index].Value;
                    textBoxNewsArticleArticleId.Text = (String)dataGridViewRow.Cells[dataGridViewTextBoxArticleId.Index].Value;
                    ShowTab(tabControlNews, tabPageNewsArticle);
                }
            }
        }

        private void headTimestamp_button_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                Contract contract = GetMDContract();
                string whatToShow = hdRequest_WhatToShow.Text.Trim();
                var reqId = new Random(DateTime.Now.Millisecond).Next();

                ibClient.ClientSocket.reqHeadTimestamp(reqId, contract, whatToShow, 1, 1);
                ShowTab(marketData_MDT, headTimestampTabPage);

                var iRow = headTimestampDataGridView.Rows.Add();

                headTimestampDataGridView[0, iRow].Value = reqId;
                headTimestampDataGridView[2, iRow].Value = contract.ConId;
                headTimestampDataGridView[3, iRow].Value = contract.Symbol;
                headTimestampDataGridView[4, iRow].Value = contract.SecType;
                headTimestampDataGridView[5, iRow].Value = contract.LastTradeDateOrContractMonth;
                headTimestampDataGridView[6, iRow].Value = contract.Strike;
                headTimestampDataGridView[7, iRow].Value = contract.Right;
                headTimestampDataGridView[8, iRow].Value = contract.Multiplier;
                headTimestampDataGridView[9, iRow].Value = contract.Exchange;
                headTimestampDataGridView[10, iRow].Value = contract.PrimaryExch;
                headTimestampDataGridView[11, iRow].Value = contract.Currency;
                headTimestampDataGridView[12, iRow].Value = contract.LocalSymbol;
                headTimestampDataGridView[13, iRow].Value = contract.TradingClass;
                headTimestampDataGridView[14, iRow].Value = contract.IncludeExpired;
                headTimestampDataGridView[15, iRow].Value = whatToShow;
            }
        }

        private void clearHeadTimestampGridViewlinkLabel_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            headTimestampDataGridView.Rows.Clear();
        }

        private void UpdateUI(HeadTimestampMessage obj)
        {
            var row = headTimestampDataGridView.Rows.OfType<DataGridViewRow>().FirstOrDefault(r => ((int)r.Cells[0].Value) == obj.ReqId);

            if (row != null)
                row.Cells[1].Value = obj.HeadTimestamp;
        }

        private void histogram_button_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                Contract contract = GetMDContract();
                string whatToShow = hdRequest_WhatToShow.Text.Trim();
                string duration = hdRequest_Duration.Text.Trim() + " " + hdRequest_TimeUnit.Text.Trim();
                var reqId = new Random(DateTime.Now.Millisecond).Next();

                histogramSubscriptionList.Add(reqId);
                ibClient.ClientSocket.reqHistogramData(reqId, contract, true, duration);
                ShowTab(marketData_MDT, histogramTabPage);
            }
        }

        private HashSet<int> histogramSubscriptionList = new HashSet<int>();

        private void histogramClearLinkLabel_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            if (histogramDataGridView.Rows.Count == 0)
                return;

            var reqId = (int)histogramDataGridView.Rows[0].Cells[0].Value;

            histogramSubscriptionList.Remove(reqId);
            ibClient.ClientSocket.cancelHistogramData(reqId);
            histogramDataGridView.Rows.Clear();
        }

        private void buttonReqMarketRule_Click(object sender, EventArgs e)
        {
            if (isConnected)
            {
                int marketRuleId = 0;
                Int32.TryParse(comboBoxMarketRuleId.Text, out marketRuleId);
                ibClient.ClientSocket.reqMarketRule(marketRuleId);
                ShowTab(contractInfoTab, marketRulePage);
            }
        }

        PnLManager pnlMgr;

        private void btnReqPnL_Click(object sender, EventArgs e)
        {
            if (!IsConnected)
                return;

            ShowTab(tabControl1, pnlTab);
            pnlMgr.CancelPnLSingle();
            pnldataTable.Clear();

            dataGridViewPnL.DataSource = pnldataTable;

            pnlMgr.ReqPnL(accountSelector.SelectedItem + "", tbModelCode.Text);
        }

        private void btnReqPnLSingle_Click(object sender, EventArgs e)
        {
            if (!IsConnected)
                return;

            ShowTab(tabControl1, pnlTab);
            pnlMgr.CancelPnL();
            pnlSingledataTable.Clear();

            dataGridViewPnL.DataSource = pnlSingledataTable;

            var conId = 0;

            if (int.TryParse(tbConId.Text, out conId))
            {
                pnlMgr.ReqPnLSingle(accountSelector.SelectedItem + "", tbModelCode.Text, conId);
            }
        }

        private void btnCancelPnL_Click(object sender, EventArgs e)
        {
            pnlMgr.CancelPnL();
        }

        private void btnCancelPnLSingle_Click(object sender, EventArgs e)
        {
            pnlMgr.CancelPnLSingle();
        }

        private void MDT_Selected(object sender, TabControlEventArgs e)
        {
            var page = e.TabPage;

            if (page.Name == historicalTicks_MDT.Name || page.Name == topMktData_MDT.Name)
            {
                page.Controls.Add(groupBox2);
            }
        }

        private void btnRequestHistoricalTicks_Click(object sender, EventArgs e)
        {
            if (!IsConnected)
                return;

            Contract contract = GetMDContract();
            int reqId = new Random(DateTime.Now.Millisecond).Next(), numOfTicks;

            if (!int.TryParse(tbNumOfTicks.Text, out numOfTicks))
                return;

            clearHistoricalTicksDataSources();
            ShowTab(marketData_MDT, historicalTicksTabPage);
            ibClient.ClientSocket.reqHistoricalTicks(reqId, contract, tbStartDate.Text, tbEndDate.Text, numOfTicks, cbWhatToShow.Text,
                cbRthOnly.Checked ? 1 : 0, cbIgnoreSize.Checked, new List<TagValue>());
        }

        private void clearHistoricalTicksDataSources()
        {
            new[] { historicalTickTable, historicalTickBidAskTable, historicalTickLastTable }.ToList().ForEach(i => i.Clear());
        }

        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            clearHistoricalTicksDataSources();
        }

        List<FormOrderWatchlist> formOrderWatchlists;

        private void B_watchlist_Click(object sender, EventArgs e)
        {
            FormOrderWatchlist ow = new FormOrderWatchlist(ibClient, orderManager, marketDataManager);


            formOrderWatchlists.Add(ow);


            ibClient.Position += ow.HandlePosition;

            ow.Show();
        }

        private void marketDataGrid_MDT_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void B_CancelRequests_Click(object sender, EventArgs e)
        {
            optionsManager.Clear();

        }

        private void liveOrdersGrid_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void liveOrdersGrid_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            int r = e.RowIndex;
            int c = e.ColumnIndex;

            orderManager.modifyOrder(r, c);

            // liveOrdersGrid.Rows.Clear();
            // ibClient.ClientSocket.reqOpenOrders();
        }

        private void positionsGrid_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.ColumnIndex == 4)
            {
                //flatten the position
                int r = e.RowIndex;
                PositionMessage pm = accountManager.positions.ElementAt(r).Value;
                Order o = null;
               double t0 = DateTime.Now.TimeOfDay.TotalHours;

                if (pm.Position > 0)
                {
                    if (t0 <= 9.5 || t0 > 16)
                    {
                        o = OrderDefinition.Tools.generateOrder("SELL", "SNAP MKT", 0, 0, pm.Position);
                    }
                    else
                    {
                        o = OrderDefinition.Tools.generateOrder("SELL", "MKT", 0, 0, pm.Position);
                        OrderDefinition.Tools.FillAdaptiveParams(o, "Urgent");
                    }
                }
                else if (pm.Position < 0)
                {
                    if (t0 <= 9.55 || t0 > 15.95)
                    {
                        o = OrderDefinition.Tools.generateOrder("BUY", "SNAP MKT", 0, 0, pm.Position);
                    }
                    else
                    {
                        o = OrderDefinition.Tools.generateOrder("BUY", "MKT", 0, 0, -pm.Position);
                        OrderDefinition.Tools.FillAdaptiveParams(o, "Urgent");
                    }
                }

                if (o != null)
                {
                    Contract c = pm.Contract.Copy();
                    c.Exchange = "SMART";
                    o.OrderId = 0;
                    //ibClient.ClientSocket.placeOrder(0, c, o);
                    ibClient.ClientSocket.placeOrder(ibClient.NextOrderId, c, o);
                    ibClient.NextOrderId++;
                }
            }
            if (e.ColumnIndex == 5)
            {
                //preview data
                int r = e.RowIndex;
                PositionMessage pm = accountManager.positions.ElementAt(r).Value;
                TabControl.SelectedTab = tradingTab;


                /*
                Contract c = new Contract();
                c.Symbol = pm.Contract.Symbol;
                //c.LocalSymbol = pm.Contract.LocalSymbol;
                c.Strike = pm.Contract.Strike;
                c.LastTradeDateOrContractMonth = pm.Contract.LastTradeDateOrContractMonth;
                //c.Multiplier = pm.Contract.Multiplier;
                c.Right = pm.Contract.Right;
                c.SecType = pm.Contract.SecType;
                c.Exchange = pm.Contract.Exchange;
                c.PrimaryExch = pm.Contract.PrimaryExch;
                */

                Contract contract = pm.Contract.Copy();
                contract.Exchange = "SMART";

                handleHistoricalChart(contract);
            }
        }

        private void IBSampleAppDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            IsConnected = false;
            ibClient.ClientSocket.eDisconnect();


            stopthreads = true;

            Thread.Sleep(500);

            try
            {
                if (getpositions != null)
                    getpositions.Join(5000);
            }
            catch (Exception ex)
            {

            }
        }

        private void cbKeepUpToDate_CheckedChanged(object sender, EventArgs e)
        {

        }

        private OpenOrderMessage findOrder(int orderid)
        {
            // int foundorder = -1;

            for (int i = 0; i < orderManager.openOrders.Count; i++)
            {
                if (orderManager.openOrders[i].OrderId == orderid)
                {
                    //foundorder = i;
                    return orderManager.openOrders[i];
                }
            }

            OpenOrderMessage om;
            int cnt = orderManager.presubmitOrders.Count;
            int id = 0;
            for (int i = 0; i < cnt; i++)
            {
                OrderDefinition od = orderManager.presubmitOrders[i].orderWatchlists[0].orderDefinitions[0];
                Contract c = orderManager.presubmitOrders[i].orderWatchlists[0].contractDefinitions[0].contract;
                id = -i * 10;
                if (id == orderid)
                {
                    om = new OpenOrderMessage(id, c, od.order, new OrderState());
                    return om;
                }
                int cos = od.childOrderDefinitions.Count;
                for (int j = 0; j < cos; j++)
                {
                    Order co = od.childOrderDefinitions[j].order;
                    id = -i * 10 - j - 1;
                    if (id == orderid)
                    {
                        om = new OpenOrderMessage(id, c, co, new OrderState());
                        return om;
                    }
                }
            }


            return null;
        }

        public class annotationinfo
        {
            public enum From
            {
                cond1,
                cond2,
                cond3,
                cond4,
                lmtprice,
                auxprice,
                trailstopprice,
                trailstoplimitoffset,
                count
            };

            public int orderid;
            public From from;


        }

        Dictionary<HorizontalLineAnnotation, TextAnnotation> attachedText = new Dictionary<HorizontalLineAnnotation, TextAnnotation>();

        private string textFromFrom(Order o, annotationinfo.From from)
        {
            string text = "";
            if (from == annotationinfo.From.cond1 || from == annotationinfo.From.cond2 || from == annotationinfo.From.cond3 || from == annotationinfo.From.cond4)
            {
                PriceCondition pc = null;
                if (from == annotationinfo.From.cond1)
                {
                    pc = (o.Conditions[0] as PriceCondition);

                }
                else if (from == annotationinfo.From.cond2)
                {
                    pc = (o.Conditions[1] as PriceCondition);

                }
                else if (from == annotationinfo.From.cond3)
                {
                    pc = (o.Conditions[2] as PriceCondition);

                }
                else if (from == annotationinfo.From.cond4)
                {
                    pc = (o.Conditions[3] as PriceCondition);

                }
                String symbol = "";

                /*
                      var task = IBClient.ResolveContractAsync(pc.ConId, pc.Exchange);
                      Contract value;
                      task.ContinueWith(t =>
                      {
                          value = t.Result;
                          //contractSearchDlg = new ContractSearchDialog(value, IBClient);
                          symbol = value != null ? value.Symbol : "";
                      },
                      TaskScheduler.FromCurrentSynchronizationContext());
                      Application.DoEvents();
                      Thread.Sleep(500);
                      */

                text = String.Concat(symbol, " ", TradeExtension.Conditions.PriceConditionText(pc));

            }
            else if (from == annotationinfo.From.lmtprice)
            {
                // if (o.ParentId == 0 && o.Action.Contains("B")) { text = "entry long"; }
                // if (o.ParentId == 0 && o.Action.Contains("S")) { text = "entry short"; }
                // if (o.ParentId > 0 && o.OrderType.Contains("LMT")) { text = "target"; }
                text = String.Concat(o.Action, " ", o.OrderType, " LMT=");
            }
            else if (from == annotationinfo.From.auxprice)
            {
                // if (o.ParentId == 0 && o.Action.Contains("B")) { text = "entry long"; }
                // if (o.ParentId == 0 && o.Action.Contains("S")) { text = "entry short"; }
                // if (o.ParentId > 0 && o.OrderType.Contains("STP")) { text = "stop"; }
                if (o.OrderType.Equals("STP") || o.OrderType.Equals("STP LMT"))
                {
                    text = String.Concat(o.Action, " ", o.OrderType, " STP=");
                }
                else
                {
                    text = String.Concat(o.Action, " ", o.OrderType, " AUX=");
                }
            }
            else if(from== annotationinfo.From.trailstoplimitoffset)
            {
                text = string.Concat(o.Action, " ", o.OrderType, " LMT=");
            }
            else if (from == annotationinfo.From.trailstopprice)
            {
                text = string.Concat(o.Action, " ", o.OrderType, " STP=");
            }
            else
            {
                text = String.Concat(o.Action, " ", o.OrderType);
            }

            return text;
        }


        private void addAnnotation(Order o, annotationinfo.From from, double line, string text, bool updateScale,bool allowmoving,ChartDashStyle chartdashstyle)
        {
            if (updateScale)
            {
                Console.Write("Updating scale.");
                historicalDataManager.chartMin = Math.Min(historicalDataManager.chartMin, line);
                historicalDataManager.chartMax = Math.Max(historicalDataManager.chartMax, line);
            }
            //AnnotationGroup ag = (historicalChart.Annotations[1] as AnnotationGroup);

            HorizontalLineAnnotation a = new HorizontalLineAnnotation();
            historicalChart.Annotations.Add(a);

            TextAnnotation t = new TextAnnotation();
            historicalChart.Annotations.Add(t);


            attachedText.Add(a, t);

            //find limiting factor



            annotationinfo tag = new annotationinfo();
            tag.orderid = o.OrderId;
            tag.from = from;

            a.Y = line;
            a.IsInfinitive = true;
            a.AxisX = historicalChart.ChartAreas["ChartArea1"].AxisX;
            a.AxisY = historicalChart.ChartAreas["ChartArea1"].AxisY;
            a.LineColor = o.Action.Contains("B") ? Color.Green : Color.Red;
            a.LineDashStyle = chartdashstyle;
            // a.AllowAnchorMoving = true;
            a.AllowMoving = allowmoving;
            a.Tag = tag;
            //a.AllowSelecting = true;
            // a.AllowTextEditing = true;



            t.Y = line;
            t.X = 0;
            t.Alignment = ContentAlignment.BottomLeft;

            if (o.OrderType.Equals("STP LMT") && from == annotationinfo.From.lmtprice)
            {
                // t.Alignment = ContentAlignment.TopLeft;
                // t.Y = line + 23;
            }


            t.Text = text;
            t.AxisX = historicalChart.ChartAreas["ChartArea1"].AxisX;
            t.AxisY = historicalChart.ChartAreas["ChartArea1"].AxisY;
            t.LineColor = o.Action.Contains("B") ? Color.Green : Color.Red;
            // a.AllowAnchorMoving = true;
            // a.AllowMoving = true;
            // a.AllowSelecting = true;
            a.AllowTextEditing = true;
            a.Tag = tag;
        }

        private void genOrderAnnotations(Contract cc)
        {
            TB_chartSymbol.Text = ContractDefinition.Tools.getLocalSymbol(cc);
            historicalChart.Annotations.Clear();
            attachedText.Clear();
            for (int i = 0; i < orderManager.openOrders.Count; i++)
            {
                if (orderManager.openOrders[i].Contract.Symbol.Equals(cc.Symbol))
                {
                    Order o = orderManager.openOrders[i].Order;
                    double line = 0;
                    string text = "";

                    annotationinfo.From from = annotationinfo.From.cond1;
                    for (int oci = 0; oci < o.Conditions.Count; oci++)
                    {
                        if (o.Conditions[oci].Type == OrderConditionType.Price)
                        {
                            PriceCondition pc = (o.Conditions[oci] as PriceCondition);
                            line = pc.Price;

                            String symbol = "";

                            /*
                     var task = IBClient.ResolveContractAsync(pc.ConId, pc.Exchange);
                     Contract value;
                     task.ContinueWith(t =>
                     {
                         value = t.Result;
                         //contractSearchDlg = new ContractSearchDialog(value, IBClient);
                         symbol = value != null ? value.Symbol : "";
                     },
                     TaskScheduler.FromCurrentSynchronizationContext());
                     Application.DoEvents();
                     Thread.Sleep(500);
                     */



                            text = String.Concat(symbol, " ", TradeExtension.Conditions.PriceConditionText(pc));
                            if (oci == 0) from = annotationinfo.From.cond1;
                            if (oci == 1) from = annotationinfo.From.cond2;
                            if (oci == 2) from = annotationinfo.From.cond3;
                            if (oci == 3) from = annotationinfo.From.cond4;
                            text = String.Concat(text, " ", line);
                            addAnnotation(o, from, line, text, true,true,ChartDashStyle.DashDotDot);
                        }


                    }
                    if (o.LmtPrice > 0 && o.LmtPrice<100000)
                    {
                        bool scale = o.OrderType.Contains("LMT") && !cc.SecType.Equals("OPT");
                        line = o.LmtPrice;
                        from = annotationinfo.From.lmtprice;
                        text = textFromFrom(o, from);
                        text = String.Concat(text, " ", line);
                        addAnnotation(o, from, line, text, scale,true,ChartDashStyle.Solid);

                    }
                    if (o.TrailStopPrice > 0 && o.TrailStopPrice < 100000 && (int)(o.TrailStopPrice*100) != (int)(o.AuxPrice*100) && o.OrderType.Contains("TRAIL"))
                    {
                        bool scale = !o.OrderType.Contains("MKT") && !cc.SecType.Equals("OPT");
                        line = o.TrailStopPrice;
                        from = annotationinfo.From.trailstopprice;
                        text = textFromFrom(o, from);
                        text = String.Concat(text, " ", line);
                        addAnnotation(o, from, line, text, scale, false, ChartDashStyle.Dash);
                    }
                    if (o.AuxPrice > 0 && o.AuxPrice < 100000 && !o.OrderType.Contains("TRAIL") && !o.OrderType.Contains("SNAP"))
                    {
                        bool scale = !o.OrderType.Contains("MKT") && !cc.SecType.Equals("OPT") && !cc.SecType.Equals("TRAIL");
                        line = o.AuxPrice;
                        from = annotationinfo.From.auxprice;
                        text = textFromFrom(o, from);
                        text = String.Concat(text, " ", line);
                        addAnnotation(o, from, line, text, scale,true,ChartDashStyle.Dash);
                    }
                    if (o.LmtPrice==0 & o.LmtPriceOffset>0 & o.OrderType.Equals("TRAIL LIMIT"))
                    {
                        bool scale = true;
                        line = o.TrailStopPrice - o.LmtPriceOffset;
                        from = annotationinfo.From.trailstoplimitoffset;
                        text = textFromFrom(o, from);
                        text = string.Concat(text, " ", line);
                        addAnnotation(o, from, line, text, scale, false, ChartDashStyle.Solid);
                    }
                  

                }
            }
        }

        private void liveOrdersGrid_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            int r = e.RowIndex;
            int c = e.ColumnIndex;
            if (r < 0) return;
            if (c < 0) return;
            int orderid = (int)(liveOrdersGrid[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_ORDERID, r].Value);
            // int foundorder = findOrder(orderid);
            OpenOrderMessage oom = findOrder(orderid);
            if (oom != null)
            {
                if (c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_CONTRACT || c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_SYMBOL)
                {


                   // marketDataManager.StopActiveRequests(true);
                    Contract contract = null;
                    if (c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_CONTRACT)
                    {
                        contract = oom.Contract.Copy();
                        contract.Exchange = "SMART";
                    }
                    if (c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_SYMBOL)
                    {

                        contract = ContractDefinition.Tools.getGenericContract(oom.Contract.Symbol);


                    }



                    handleHistoricalChart(contract);
                    //TabControl.SelectedTab = marketDataTab;
                }

                if (c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND1 || c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND2 || c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND3 || c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND4)
                {
                    int condindex = 0;
                    if (c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND1)
                    {
                        condindex = 0;

                    }

                    if (c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND2)
                    {
                        condindex = 1;

                    }

                    if (c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND3)
                    {
                        condindex = 2;

                    }

                    if (c == (int)OrderManager.GRIDORDER_VALS.GRIDORDER_COND3)
                    {
                        condindex = 3;

                    }

                    if (oom.Order.Conditions.Count > condindex)
                    {
                        OrderCondition oc = oom.Order.Conditions[condindex];

                        ConditionDialog cd = new ConditionDialog(oc, ibClient);

                        Thread.Sleep(250);

                        cd.ShowDialog();

                        if (cd.DialogResult == DialogResult.OK)
                        {
                            //orderManager.openOrders[foundorder].Order.Conditions[condindex]=   cd.Condition.Copy();
                            ibClient.ClientSocket.placeOrder(orderid, oom.Contract, oom.Order);

                        }
                    }
                }
            }
        }

        private void historicalChart_Click(object sender, EventArgs e)
        {

        }

        private void historicalChart_MouseDoubleClick(object sender, MouseEventArgs e)
        {

        }

        private void historicalChart_MouseDown(object sender, MouseEventArgs e)
        {
            //  double x = historicalChart.ChartAreas["ChartArea0"].AxisX.PixelPositionToValue(e.X);
            // double y = historicalChart.ChartAreas["ChartArea0"].AxisY.PixelPositionToValue(e.Y);
            //   for (int i=0;i<historicalChart.anno)
        }

        private void historicalChart_AnnotationPositionChanged(object sender, EventArgs e)
        {
            if (lastannotation != null)
            {

                Console.WriteLine("anno x,y:{0},{1}", lastannotation.X, lastannotation.Y);
                annotationinfo tag = lastannotation.Tag as annotationinfo;
                OpenOrderMessage oom = findOrder(tag.orderid);
                double newprice = Math.Floor(lastannotation.Y * 100) / 100;

                historicalDataManager.chartMin = Math.Min(historicalDataManager.chartMin, newprice);
                historicalDataManager.chartMax = Math.Max(historicalDataManager.chartMax, newprice);

                if (oom != null)
                {
                    if (tag.from == annotationinfo.From.auxprice)
                    {

                        oom.Order.AuxPrice = newprice;
                        orderManager.PlaceOrder(oom.Contract, oom.Order);


                    }
                    if (tag.from == annotationinfo.From.lmtprice)
                    {

                        oom.Order.LmtPrice = newprice;
                        orderManager.PlaceOrder(oom.Contract, oom.Order);


                    }
                    if (tag.from == annotationinfo.From.cond1)
                    {
                        try
                        {
                            OrderCondition oc = oom.Order.Conditions[0];
                            if (oc.Type == OrderConditionType.Price)
                            {
                                PriceCondition pc = oc as PriceCondition;

                                pc.Price = newprice;
                                orderManager.PlaceOrder(oom.Contract, oom.Order);
                            }

                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.Message);
                        }
                    }

                    try
                    {
                        TextAnnotation t = attachedText[lastannotation as HorizontalLineAnnotation];
                        if (t != null)
                        {
                            string text = textFromFrom(oom.Order, tag.from);
                            t.Y = newprice;
                            text = String.Concat(text, " ", newprice);
                            t.Text = text;
                        }
                    }
                    catch { }
                }

            }
            lastannotation = null;
        }

        Annotation lastannotation = null;

        private void historicalChart_AnnotationPositionChanging(object sender, AnnotationPositionChangingEventArgs e)
        {
            lastannotation = e.Annotation;
        }

        private void TB_chartSymbol_TextChanged(object sender, EventArgs e)
        {

        }

        private void handleHistoricalChart(Contract contract)
        {
            showHistoricaldata(contract);
            genOrderAnnotations(contract);
            historicalChart.ChartAreas[0].RecalculateAxesScale();
        }

        private void TB_chartSymbol_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                TB_chartSymbol.Text = TB_chartSymbol.Text.ToUpper();
                Contract contract = ContractDefinition.Tools.getGenericContract(TB_chartSymbol.Text,comboBox2.Text,textBox5.Text.ToUpper(),primaryExchange.Text,currency_TMD_MDT.Text);
                handleHistoricalChart(contract);
                //also add the ticker

                marketDataManager.AddRequest(contract, "");

            }
        }

        private void historicalChart_MouseHover(object sender, EventArgs e)
        {

        }
        ToolTip tpx = new ToolTip();
        ToolTip tpy = new ToolTip();
        ToolTip[] tps = new ToolTip[] { new ToolTip(), new ToolTip(), new ToolTip(), new ToolTip()};
        //ToolTip tpl = new ToolTip();
        Point prevpoint = new Point();
        private void historicalChart_MouseMove(object sender, MouseEventArgs e)
        {
            try
            {
                if (prevpoint.X== e.X && prevpoint.Y == e.Y) return;

                try
                {
                    prevpoint.X = e.X;
                    prevpoint.Y = e.Y;
                    Chart chart = sender as Chart;
                    PointF mousePoint = new PointF(e.X, e.Y);
                    int tpscnt = 0;
                    for (int chartarea = 0; chartarea < 2; chartarea++)
                    {

                        chart.ChartAreas[chartarea].CursorX.SetCursorPixelPosition(mousePoint, false);
                        chart.ChartAreas[chartarea].CursorY.SetCursorPixelPosition(mousePoint, false);
                        Series s = chart.Series[chartarea];

                        //  HitTestResult r = chart.HitTest(e.X, e.Y, ChartElementType.DataPoint);
                        double valx = chart.ChartAreas[chartarea].AxisX.PixelPositionToValue(e.X);
                        double valy = chart.ChartAreas[chartarea].AxisY.PixelPositionToValue(e.Y);
                        // Console.WriteLine(valx);
                        // int ix = s.Points.Select((x, i) => new { delta = Math.Abs(x.XValue - valx), i }).OrderBy(x => x.delta).First().i;
                        int ix = (int)valx;
                        int iy = (int)valy;

                        bool yminrange = Double.IsNaN(chart.ChartAreas[chartarea].AxisY.Minimum) ? true : (iy > chart.ChartAreas[chartarea].AxisY.Minimum);
                        bool ymaxrange = Double.IsNaN(chart.ChartAreas[chartarea].AxisY.Maximum) ? true : (iy < chart.ChartAreas[chartarea].AxisY.Maximum);
                        bool xminrange = Double.IsNaN(chart.ChartAreas[chartarea].AxisX.Minimum) ? true : (ix > chart.ChartAreas[chartarea].AxisX.Minimum);
                        bool xmaxrange = Double.IsNaN(chart.ChartAreas[chartarea].AxisX.Maximum) ? true : (ix < chart.ChartAreas[chartarea].AxisX.Maximum);

                      

                        if (yminrange && ymaxrange && xminrange && xmaxrange)
                        {
                            if (chartarea == 1)
                            {
                                Console.WriteLine("vol");
                            }
                            DataPoint dp = s.Points[ix];

                            //  DataPoint dp = chart.Series[0].Points[r.PointIndex];
                            foreach (double y in dp.YValues)
                            {
                             
                                int hy = (int)chart.ChartAreas[chartarea].AxisY.ValueToPixelPosition(y);
                                tps[tpscnt].ShowAlways = true;
                                tps[tpscnt].Show(String.Format("{0:G5}", y), chart, 0, hy);
                                tpscnt++;
                            }


                            //tpx.Hide(chart);
                            tpx.ShowAlways = true;
                            tpx.Show(String.Format("{0}", DateTime.FromOADate( dp.XValue)), chart, e.X, 0);

                            // tpy.Hide(chart);
                            tpy.ShowAlways = true;
                            tpy.Show(String.Format("{0:G5}", valy), chart, 0, e.Y);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private void historicalChart_MouseLeave(object sender, EventArgs e)
        {
            /*
            tpx.Hide(sender as Chart);
            tpy.Hide(sender as Chart);
            for (int i=0;i<tps.Length;i++)
            tphs[i].Hide(sender as Chart);
            */
        }



        private void BT_SaveOrders_Click(object sender, EventArgs e)
        {


            SaveFileDialog sfd = new SaveFileDialog();
            sfd.AddExtension = true;
            sfd.Filter = "csv Files (*.csv)|*.csv|xml Files (*.xml)|*.xml";
            sfd.DefaultExt = "csv";

            DialogResult dr = sfd.ShowDialog();
            if (dr == DialogResult.OK)
            {
                if (!String.IsNullOrEmpty(sfd.FileName))
                {
                    if (sfd.FilterIndex == 1)
                    {
                        try
                        {
                            using (StreamWriter writer = File.CreateText(sfd.FileName))
                            {
                                
                                writer.WriteLine(OrderDefinition.Tools.MessageOrderDescription(null,null,null));
                                foreach (OpenOrderMessage msg in orderManager.openOrders)
                                {
                                    try
                                    {

                                        writer.WriteLine(OrderDefinition.Tools.MessageOrderDescription(msg.Contract,msg.Order,msg.OrderState));
                                    }
                                    catch (Exception ex)
                                    {

                                    }

                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show(ex.Message);
                        }
                    }
                    if (sfd.FilterIndex == 2)
                    {
                        IBControlDefinition od = new IBControlDefinition();

                        int watchlistindex = -1;
                        foreach (OpenOrderMessage msg in orderManager.openOrders)
                        {
                            od.orderWatchlists.Add(new IBControlDefinition.OrderWatchlist());
                            watchlistindex++;
                            od.orderWatchlists[watchlistindex].contractDefinitions.Add(new ContractDefinition());
                            od.orderWatchlists[watchlistindex].orderDefinitions.Add(new OrderDefinition());
                            od.orderWatchlists[watchlistindex].contractDefinitions[0].contract = msg.Contract;
                            od.orderWatchlists[watchlistindex].orderDefinitions[0].order = msg.Order;
                        }
                       
                        od.saveXML(sfd.FileName);
                        
                    }

                }

            }

        }

        private void IBSampleAppDialog_Load(object sender, EventArgs e)
        {
            notifyIconSample.ShowBalloonTip(2000);
        }

        private void liveOrdersGrid_CellContentClick_1(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void TB_Filter_TextChanged(object sender, EventArgs e)
        {

            foreach (DataGridViewRow row in liveOrdersGrid.Rows)
            {
                if (row.Cells[(int)OrderManager.GRIDORDER_VALS.GRIDORDER_SYMBOL].Value.ToString().Contains(TB_Filter.Text.ToUpper()))
                {
                    row.Visible = true;
                }
                else
                {
                    row.Visible = false;
                }
            }

        }

        private void B_CleanUpHistoricalData_Click(object sender, EventArgs e)
        {
            foreach(int req in historicalDataManager.historicalDataDefinition.historicalDataMap.Values)
            {
                ibClient.ClientSocket.cancelHistoricalData(req);
            }
            historicalDataManager.historicalDataDefinition.historicalDataMap.Clear();
            historicalDataManager.historicalDataDefinition.historicalDataMessageManagers.Clear();

        }

        private void button3_Click(object sender, EventArgs e)
        {
            DialogResult dr = MessageBox.Show("Are you sure you want to mass cancel zero positions?", "Warning", MessageBoxButtons.YesNo); ;
            if (dr == DialogResult.Yes)
            {

                int nOrders = orderManager.openOrders.Count;

                for (int i = 0; i < nOrders; i++)
                {
                    OpenOrderMessage o = orderManager.openOrders[i];
                    string symbol = o.Contract.Symbol;
                    bool inpos = false;
                    foreach (PositionMessage msg in accountManager.positions.Values)
                    {
                        if (msg.Contract.Symbol.Equals(symbol))
                        {
                            inpos = true;
                            break;
                        }
                    }

                    if (!inpos)
                    {
                        //delete
                        ibClient.ClientSocket.cancelOrder(o.OrderId);
                        Thread.Sleep(15);
                        Application.DoEvents();
                    }
                    else
                    {
                        Console.WriteLine("Keeping order id {0} {1}-{2} for {3}-{4}", o.OrderId, o.Order.OrderType, o.Order.Action, o.Contract.Symbol, o.Contract.LocalSymbol);
                    }

                }
            }
        }

        private void completedOrdersButton_Click_1(object sender, EventArgs e)
        {
            completedOrdersGrid.Rows.Clear();
            orderManager.completedOrders.Clear();
            ibClient.ClientSocket.reqCompletedOrders(false);
        }

        private void refreshExecutionsButton_Click_1(object sender, EventArgs e)
        {
            tradeLogGrid.Rows.Clear();

            ExecutionFilter execFilter = new ExecutionFilter();
            if (!execFilterClientId.Text.Equals(String.Empty))
                execFilter.ClientId = Int32.Parse(execFilterClientId.Text);
            execFilter.AcctCode = execFilterAccount.Text;
            execFilter.Time = execFilterTime.Text;
            execFilter.Symbol = execFilterSymbol.Text;
            execFilter.SecType = execFilterSecType.Text;
            execFilter.Exchange = execFilterExchange.Text;
            execFilter.Side = execFilterSide.Text;

            ibClient.ClientSocket.reqExecutions(1, execFilter);
        }

        private void CB_HistType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (CB_HistType.SelectedIndex==0)
            {
                hdRequest_BarSize.Text = "1 min";
                hdRequest_Duration.Text = "1";
                hdRequest_TimeUnit.Text = "D";
                B_CleanUpHistoricalData_Click(null, null);
            }
            if (CB_HistType.SelectedIndex == 1)
            {
                hdRequest_BarSize.Text = "1 day";
                hdRequest_Duration.Text = "30";
                hdRequest_TimeUnit.Text = "D";
                B_CleanUpHistoricalData_Click(null, null);
            }
            if (CB_HistType.SelectedIndex == 2)
            {
                hdRequest_BarSize.Text = "1 day";
                hdRequest_Duration.Text = "300";
                hdRequest_TimeUnit.Text = "D";
                B_CleanUpHistoricalData_Click(null, null);
            }
        }

        public event Action<OpenOrderMessage> MimickOpenOrder;
        private void B_loadOrders_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            DialogResult dr = ofd.ShowDialog();
            if (dr == DialogResult.OK && !String.IsNullOrEmpty(ofd.FileName))
            {
                string[] fns = ofd.FileName.Split(new char[] { '\\' });
                this.Text = fns[fns.Count() - 1];

                IBControlDefinition IBCD = new IBControlDefinition();
                IBCD.loadXML(ofd.FileName);
                if (IBCD == null) return;
                if (IBCD.orderWatchlists.Count() > 0)
                {
                    //add delegates
                    MimickOpenOrder += orderManager.handleOpenOrder;
                    //add to open orders
                    int oid = 1;
                    int pid = 1; OpenOrderMessage msg;

                    foreach (IBControlDefinition.OrderWatchlist ow in IBCD.orderWatchlists)
                    {
                        OrderState os = new OrderState();
                        Contract c = ow.contractDefinitions[0].contract;
                        foreach (OrderDefinition od in ow.orderDefinitions)
                        {
                            Order o = od.order;
                            o.OrderId = oid++;
                            o.PermId = pid++;
                            o.ClientId = 9999;
                           msg = new OpenOrderMessage(oid, c, o, os);
                            MimickOpenOrder?.Invoke(msg);
                            foreach(OrderDefinition cod in od.childOrderDefinitions)
                            {
                                Order co = cod.order;
                                co.OrderId = oid++;
                                co.PermId = pid++;
                                co.ClientId = 9999;
                                co.ParentId = o.OrderId;
                                msg = new OpenOrderMessage(oid, c, co, os);
                                MimickOpenOrder?.Invoke(msg);
                            }
                        }
                    }

                    //remove delegates
                    MimickOpenOrder -= orderManager.handleOpenOrder;
                }
            }
        }

        private void CB_ShowPos1_CheckedChanged(object sender, EventArgs e)
        {
            accountManager.showpos1 = CB_ShowPos1.Checked;
        }

        private void buttonRequestTickByTick_Click(object sender, EventArgs e)
        {
            if (!IsConnected)
                return;

            Contract contract = GetMDContract();

            ShowTab(marketData_MDT, tabPageTickByTick);

            String tickType = comboBoxTickByTickType.GetItemText(comboBoxTickByTickType.SelectedItem);
            int numberOfTicks;
            if (!int.TryParse(tbNumOfTicks.Text, out numberOfTicks))
                return;

            labelTickByTick.Text = "Tick-By-Tick: " + tickType;
            ibClient.ClientSocket.reqTickByTickData(0, contract, tickType, numberOfTicks, cbIgnoreSize.Checked);
        }

        private void buttonCancelTickByTick_Click(object sender, EventArgs e)
        {
            ibClient.ClientSocket.cancelTickByTickData(0);
        }

        private void linkLabelClearTickByTick_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            ibClient.ClientSocket.cancelTickByTickData(0);
            labelTickByTick.Text = "Tick-By-Tick: ";
            new[] { tickByTickLastTable, tickByTickAllLastTable, tickByTickBidAskTable, tickByTickMidPointTable }.ToList().ForEach(i => i.Clear());
        }

        private void buttonPdfPathDialog_Click(object sender, EventArgs e)
        {
            var fbd = new FolderBrowserDialog() { SelectedPath = textBoxNewsArticlePath.Text };

            if (fbd.ShowDialog() != System.Windows.Forms.DialogResult.OK)
                return;

            textBoxNewsArticlePath.Text = fbd.SelectedPath;
        }

        private void buttonAttachOrder_Click(object sender, EventArgs e)
        {
            orderManager.AttachOrder();
        }

        private void FilterOptionAdd_button_Click(object sender, EventArgs e)
        {
            listViewFilterOptions.Items.Add(new ListViewItem(new[] { comboBoxFilterName.Text, textBoxFilterValue.Text }));
        }

        private void FilterOptionRemove_button_Click(object sender, EventArgs e)
        {
            listViewFilterOptions.SelectedItems.OfType<ListViewItem>().ToList().ForEach(i => listViewFilterOptions.Items.Remove(i));
        }

        private void completedOrdersButton_Click(object sender, EventArgs e)
        {
            completedOrdersGrid.Rows.Clear();
            ibClient.ClientSocket.reqCompletedOrders(false);
        }
    }
}
