/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using IBSampleApp.types;
using IBSampleApp.ui;
namespace IBSampleApp
{
    partial class OrderDialog
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(OrderDialog));
            this.contractSymbol = new System.Windows.Forms.TextBox();
            this.conditionsTab = new System.Windows.Forms.TabControl();
            this.orderContractTab = new System.Windows.Forms.TabPage();
            this.baseGroup = new System.Windows.Forms.GroupBox();
            this.label24 = new System.Windows.Forms.Label();
            this.usePriceMgmtAlgo = new System.Windows.Forms.CheckBox();
            this.cashQty = new System.Windows.Forms.TextBox();
            this.cashQtyLabel = new System.Windows.Forms.Label();
            this.modelCode = new System.Windows.Forms.TextBox();
            this.modelCodeLabel = new System.Windows.Forms.Label();
            this.timeInForce = new System.Windows.Forms.ComboBox();
            this.auxPrice = new System.Windows.Forms.TextBox();
            this.lmtPrice = new System.Windows.Forms.TextBox();
            this.orderType = new System.Windows.Forms.ComboBox();
            this.displaySize = new System.Windows.Forms.TextBox();
            this.quantity = new System.Windows.Forms.TextBox();
            this.action = new System.Windows.Forms.ComboBox();
            this.timeInForceLabel = new System.Windows.Forms.Label();
            this.auxPriceLabel = new System.Windows.Forms.Label();
            this.account = new System.Windows.Forms.ComboBox();
            this.limitPriceLabel = new System.Windows.Forms.Label();
            this.orderTypeLabel = new System.Windows.Forms.Label();
            this.displaySizeLabel = new System.Windows.Forms.Label();
            this.quantityLabel = new System.Windows.Forms.Label();
            this.actionLabel = new System.Windows.Forms.Label();
            this.accountLabel = new System.Windows.Forms.Label();
            this.contractGroup = new System.Windows.Forms.GroupBox();
            this.orderPrimExchLabel = new System.Windows.Forms.Label();
            this.contractPrimaryExch = new System.Windows.Forms.TextBox();
            this.orderLocalSymbol = new System.Windows.Forms.Label();
            this.orderCurrencyLabel = new System.Windows.Forms.Label();
            this.orderExchangeLabel = new System.Windows.Forms.Label();
            this.orderSymbolLabel = new System.Windows.Forms.Label();
            this.orderMultiplierLabel = new System.Windows.Forms.Label();
            this.orderRightLabel = new System.Windows.Forms.Label();
            this.contractSecType = new System.Windows.Forms.ComboBox();
            this.orderStrikeLabel = new System.Windows.Forms.Label();
            this.contractLastTradeDateOrContractMonth = new System.Windows.Forms.TextBox();
            this.orderLastTradeDateOrContractMonthLabel = new System.Windows.Forms.Label();
            this.contractStrike = new System.Windows.Forms.TextBox();
            this.orderSecTypeLabel = new System.Windows.Forms.Label();
            this.contractRight = new System.Windows.Forms.ComboBox();
            this.contractLocalSymbol = new System.Windows.Forms.TextBox();
            this.contractMultiplier = new System.Windows.Forms.TextBox();
            this.contractCurrency = new System.Windows.Forms.TextBox();
            this.contractExchange = new System.Windows.Forms.TextBox();
            this.extendedOrderTab = new System.Windows.Forms.TabPage();
            this.relativeDiscretionary = new System.Windows.Forms.CheckBox();
            this.omsContainer = new System.Windows.Forms.CheckBox();
            this.dontUseAutoPriceForHedge = new System.Windows.Forms.CheckBox();
            this.label22 = new System.Windows.Forms.Label();
            this.mifid2ExecutionAlgo = new System.Windows.Forms.TextBox();
            this.label23 = new System.Windows.Forms.Label();
            this.mifid2ExecutionTrader = new System.Windows.Forms.TextBox();
            this.label18 = new System.Windows.Forms.Label();
            this.mifid2DecisionAlgo = new System.Windows.Forms.TextBox();
            this.label19 = new System.Windows.Forms.Label();
            this.mifid2DecisionMaker = new System.Windows.Forms.TextBox();
            this.label17 = new System.Windows.Forms.Label();
            this.softDollarTier = new System.Windows.Forms.ComboBox();
            this.nbboPriceCapLabel = new System.Windows.Forms.Label();
            this.trailingPercentLabel = new System.Windows.Forms.Label();
            this.transmit = new System.Windows.Forms.CheckBox();
            this.firmQuote = new System.Windows.Forms.CheckBox();
            this.overrideConstraints = new System.Windows.Forms.CheckBox();
            this.label5 = new System.Windows.Forms.Label();
            this.eTrade = new System.Windows.Forms.CheckBox();
            this.optOutSmart = new System.Windows.Forms.CheckBox();
            this.nbboPriceCap = new System.Windows.Forms.TextBox();
            this.trailingPercent = new System.Windows.Forms.TextBox();
            this.discretionaryAmount = new System.Windows.Forms.TextBox();
            this.hidden = new System.Windows.Forms.CheckBox();
            this.outsideRTH = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.allOrNone = new System.Windows.Forms.CheckBox();
            this.label2 = new System.Windows.Forms.Label();
            this.notHeld = new System.Windows.Forms.CheckBox();
            this.block = new System.Windows.Forms.CheckBox();
            this.label1 = new System.Windows.Forms.Label();
            this.sweepToFill = new System.Windows.Forms.CheckBox();
            this.percentOffsetLabel = new System.Windows.Forms.Label();
            this.tiggerMethodLabel = new System.Windows.Forms.Label();
            this.rule80ALabel = new System.Windows.Forms.Label();
            this.goodUntilLabel = new System.Windows.Forms.Label();
            this.goodAfterLabel = new System.Windows.Forms.Label();
            this.ocaGroup = new System.Windows.Forms.TextBox();
            this.hedgeParam = new System.Windows.Forms.TextBox();
            this.ocaType = new System.Windows.Forms.ComboBox();
            this.hedgeType = new System.Windows.Forms.ComboBox();
            this.orderMinQtyLabel = new System.Windows.Forms.Label();
            this.orderRefLabel = new System.Windows.Forms.Label();
            this.trailStopPrice = new System.Windows.Forms.TextBox();
            this.percentOffset = new System.Windows.Forms.TextBox();
            this.triggerMethod = new System.Windows.Forms.ComboBox();
            this.rule80A = new System.Windows.Forms.ComboBox();
            this.goodUntil = new System.Windows.Forms.TextBox();
            this.goodAfter = new System.Windows.Forms.TextBox();
            this.minQty = new System.Windows.Forms.TextBox();
            this.orderReference = new System.Windows.Forms.TextBox();
            this.advisorTab = new System.Windows.Forms.TabPage();
            this.faPercentage = new System.Windows.Forms.TextBox();
            this.faProfile = new System.Windows.Forms.TextBox();
            this.faMethod = new System.Windows.Forms.ComboBox();
            this.faGroup = new System.Windows.Forms.TextBox();
            this.profileLabel = new System.Windows.Forms.Label();
            this.orLabel = new System.Windows.Forms.Label();
            this.percentageLabel = new System.Windows.Forms.Label();
            this.methodLabel = new System.Windows.Forms.Label();
            this.groupLabel = new System.Windows.Forms.Label();
            this.volatilityTab = new System.Windows.Forms.TabPage();
            this.stockRangeLower = new System.Windows.Forms.TextBox();
            this.stockRangeUpper = new System.Windows.Forms.TextBox();
            this.deltaNeutralConId = new System.Windows.Forms.TextBox();
            this.deltaNeutralAuxPrice = new System.Windows.Forms.TextBox();
            this.deltaNeutralOrderType = new System.Windows.Forms.ComboBox();
            this.optionReferencePrice = new System.Windows.Forms.ComboBox();
            this.volatilityType = new System.Windows.Forms.ComboBox();
            this.volatility = new System.Windows.Forms.TextBox();
            this.continuousUpdate = new System.Windows.Forms.CheckBox();
            this.stockRangeLowerLabel = new System.Windows.Forms.Label();
            this.sockRangeUpperLabel = new System.Windows.Forms.Label();
            this.hedgeContractConIdLabel = new System.Windows.Forms.Label();
            this.hedgeOrderAuxPriceLabel = new System.Windows.Forms.Label();
            this.hedgeOrderTypeLabel = new System.Windows.Forms.Label();
            this.optionReferencePriceLabel = new System.Windows.Forms.Label();
            this.volatilityLabel = new System.Windows.Forms.Label();
            this.scaleTab = new System.Windows.Forms.TabPage();
            this.priceAdjustInterval = new System.Windows.Forms.TextBox();
            this.priceAdjustValue = new System.Windows.Forms.TextBox();
            this.initialFillQuantity = new System.Windows.Forms.TextBox();
            this.initialPosition = new System.Windows.Forms.TextBox();
            this.priceIncrement = new System.Windows.Forms.TextBox();
            this.profitOffset = new System.Windows.Forms.TextBox();
            this.subsequentLevelSize = new System.Windows.Forms.TextBox();
            this.initialLevelSize = new System.Windows.Forms.TextBox();
            this.autoReset = new System.Windows.Forms.CheckBox();
            this.randomiseSize = new System.Windows.Forms.CheckBox();
            this.secondsLabel = new System.Windows.Forms.Label();
            this.initialPositionLabel = new System.Windows.Forms.Label();
            this.initialFillQuantityLabel = new System.Windows.Forms.Label();
            this.everyLabel = new System.Windows.Forms.Label();
            this.priceAdjustValueLabel = new System.Windows.Forms.Label();
            this.subsequentLevelSizeLabel = new System.Windows.Forms.Label();
            this.profitOffsetLabel = new System.Windows.Forms.Label();
            this.priceIncrementLabel = new System.Windows.Forms.Label();
            this.initialLevelSizeLabel = new System.Windows.Forms.Label();
            this.algoTab = new System.Windows.Forms.TabPage();
            this.useOddLots = new System.Windows.Forms.TextBox();
            this.noTradeAhead = new System.Windows.Forms.TextBox();
            this.getDone = new System.Windows.Forms.TextBox();
            this.displaySizeAlgo = new System.Windows.Forms.TextBox();
            this.forceCompletion = new System.Windows.Forms.TextBox();
            this.riskAversion = new System.Windows.Forms.TextBox();
            this.noTakeLiq = new System.Windows.Forms.TextBox();
            this.strategyType = new System.Windows.Forms.TextBox();
            this.pctVol = new System.Windows.Forms.TextBox();
            this.maxPctVol = new System.Windows.Forms.TextBox();
            this.allowPastEndTime = new System.Windows.Forms.TextBox();
            this.endTime = new System.Windows.Forms.TextBox();
            this.startTime = new System.Windows.Forms.TextBox();
            this.useOddLotsLabel = new System.Windows.Forms.Label();
            this.noTradeAheadLabel = new System.Windows.Forms.Label();
            this.getDoneLabel = new System.Windows.Forms.Label();
            this.displaySizeAlgoLabel = new System.Windows.Forms.Label();
            this.forceCompletionLabel = new System.Windows.Forms.Label();
            this.riskAversionLabel = new System.Windows.Forms.Label();
            this.noTakeLiqLabel = new System.Windows.Forms.Label();
            this.strategyTypeLabel = new System.Windows.Forms.Label();
            this.pctVolLabel = new System.Windows.Forms.Label();
            this.maxPctVolLabel = new System.Windows.Forms.Label();
            this.allowPastEndTimeLabel = new System.Windows.Forms.Label();
            this.endTimeLabel = new System.Windows.Forms.Label();
            this.startTimeLabel = new System.Windows.Forms.Label();
            this.algoStrategy = new System.Windows.Forms.ComboBox();
            this.algoStrategyLabel = new System.Windows.Forms.Label();
            this.peg2benchTab = new System.Windows.Forms.TabPage();
            this.pgdStockRangeLower = new System.Windows.Forms.TextBox();
            this.pgdStockRangeUpper = new System.Windows.Forms.TextBox();
            this.label20 = new System.Windows.Forms.Label();
            this.label21 = new System.Windows.Forms.Label();
            this.cbPeggedChangeType = new System.Windows.Forms.ComboBox();
            this.tbReferenceChangeAmount = new System.Windows.Forms.TextBox();
            this.tbPeggedChangeAmount = new System.Windows.Forms.TextBox();
            this.tbStartingReferencePrice = new System.Windows.Forms.TextBox();
            this.label10 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.tbStartingPrice = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.adjustStopTab = new System.Windows.Forms.TabPage();
            this.label16 = new System.Windows.Forms.Label();
            this.cbAdjustedTrailingAmntUnit = new System.Windows.Forms.ComboBox();
            this.tbAdjustedTrailingAmnt = new System.Windows.Forms.TextBox();
            this.label15 = new System.Windows.Forms.Label();
            this.tbAdjustedStopLimitPrice = new System.Windows.Forms.TextBox();
            this.label14 = new System.Windows.Forms.Label();
            this.tbAdjustedStopPrice = new System.Windows.Forms.TextBox();
            this.label13 = new System.Windows.Forms.Label();
            this.tbTriggerPrice = new System.Windows.Forms.TextBox();
            this.label12 = new System.Windows.Forms.Label();
            this.cbAdjustedOrderType = new System.Windows.Forms.ComboBox();
            this.label11 = new System.Windows.Forms.Label();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.ignoreRth = new System.Windows.Forms.CheckBox();
            this.cancelOrder = new System.Windows.Forms.ComboBox();
            this.conditionList = new System.Windows.Forms.DataGridView();
            this.Description = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Logic = new System.Windows.Forms.DataGridViewComboBoxColumn();
            this.lbAddCondition = new System.Windows.Forms.LinkLabel();
            this.lbRemoveCondition = new System.Windows.Forms.LinkLabel();
            this.sendOrderButton = new System.Windows.Forms.Button();
            this.textBox6 = new System.Windows.Forms.TextBox();
            this.textBox7 = new System.Windows.Forms.TextBox();
            this.textBox8 = new System.Windows.Forms.TextBox();
            this.checkMarginButton = new System.Windows.Forms.Button();
            this.closeOrderDialogButton = new System.Windows.Forms.Button();
            this.contractSearchControl1 = new IBSampleApp.ui.ContractSearchControl();
            this.B_SaveOrder = new System.Windows.Forms.Button();
            this.conditionsTab.SuspendLayout();
            this.orderContractTab.SuspendLayout();
            this.baseGroup.SuspendLayout();
            this.contractGroup.SuspendLayout();
            this.extendedOrderTab.SuspendLayout();
            this.advisorTab.SuspendLayout();
            this.volatilityTab.SuspendLayout();
            this.scaleTab.SuspendLayout();
            this.algoTab.SuspendLayout();
            this.peg2benchTab.SuspendLayout();
            this.adjustStopTab.SuspendLayout();
            this.tabPage1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.conditionList)).BeginInit();
            this.SuspendLayout();
            // 
            // contractSymbol
            // 
            this.contractSymbol.Location = new System.Drawing.Point(109, 30);
            this.contractSymbol.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractSymbol.Name = "contractSymbol";
            this.contractSymbol.Size = new System.Drawing.Size(93, 22);
            this.contractSymbol.TabIndex = 0;
            this.contractSymbol.Text = "AAPL";
            this.contractSymbol.TextChanged += new System.EventHandler(this.ContractSymbol_TextChanged);
            // 
            // conditionsTab
            // 
            this.conditionsTab.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.conditionsTab.Controls.Add(this.orderContractTab);
            this.conditionsTab.Controls.Add(this.extendedOrderTab);
            this.conditionsTab.Controls.Add(this.advisorTab);
            this.conditionsTab.Controls.Add(this.volatilityTab);
            this.conditionsTab.Controls.Add(this.scaleTab);
            this.conditionsTab.Controls.Add(this.algoTab);
            this.conditionsTab.Controls.Add(this.peg2benchTab);
            this.conditionsTab.Controls.Add(this.adjustStopTab);
            this.conditionsTab.Controls.Add(this.tabPage1);
            this.conditionsTab.Location = new System.Drawing.Point(1, 1);
            this.conditionsTab.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.conditionsTab.Name = "conditionsTab";
            this.conditionsTab.SelectedIndex = 0;
            this.conditionsTab.Size = new System.Drawing.Size(844, 447);
            this.conditionsTab.TabIndex = 1;
            // 
            // orderContractTab
            // 
            this.orderContractTab.BackColor = System.Drawing.Color.LightGray;
            this.orderContractTab.Controls.Add(this.baseGroup);
            this.orderContractTab.Controls.Add(this.contractGroup);
            this.orderContractTab.Location = new System.Drawing.Point(4, 25);
            this.orderContractTab.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.orderContractTab.Name = "orderContractTab";
            this.orderContractTab.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.orderContractTab.Size = new System.Drawing.Size(836, 418);
            this.orderContractTab.TabIndex = 0;
            this.orderContractTab.Text = "Basic Order";
            // 
            // baseGroup
            // 
            this.baseGroup.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.baseGroup.Controls.Add(this.label24);
            this.baseGroup.Controls.Add(this.usePriceMgmtAlgo);
            this.baseGroup.Controls.Add(this.cashQty);
            this.baseGroup.Controls.Add(this.cashQtyLabel);
            this.baseGroup.Controls.Add(this.modelCode);
            this.baseGroup.Controls.Add(this.modelCodeLabel);
            this.baseGroup.Controls.Add(this.timeInForce);
            this.baseGroup.Controls.Add(this.auxPrice);
            this.baseGroup.Controls.Add(this.lmtPrice);
            this.baseGroup.Controls.Add(this.orderType);
            this.baseGroup.Controls.Add(this.displaySize);
            this.baseGroup.Controls.Add(this.quantity);
            this.baseGroup.Controls.Add(this.action);
            this.baseGroup.Controls.Add(this.timeInForceLabel);
            this.baseGroup.Controls.Add(this.auxPriceLabel);
            this.baseGroup.Controls.Add(this.account);
            this.baseGroup.Controls.Add(this.limitPriceLabel);
            this.baseGroup.Controls.Add(this.orderTypeLabel);
            this.baseGroup.Controls.Add(this.displaySizeLabel);
            this.baseGroup.Controls.Add(this.quantityLabel);
            this.baseGroup.Controls.Add(this.actionLabel);
            this.baseGroup.Controls.Add(this.accountLabel);
            this.baseGroup.Location = new System.Drawing.Point(483, 7);
            this.baseGroup.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.baseGroup.Name = "baseGroup";
            this.baseGroup.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.baseGroup.Size = new System.Drawing.Size(323, 400);
            this.baseGroup.TabIndex = 0;
            this.baseGroup.TabStop = false;
            this.baseGroup.Text = "Order Base Attributes";
            // 
            // label24
            // 
            this.label24.AutoSize = true;
            this.label24.Location = new System.Drawing.Point(17, 363);
            this.label24.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label24.Name = "label24";
            this.label24.Size = new System.Drawing.Size(187, 17);
            this.label24.TabIndex = 25;
            this.label24.Text = "Use Price Management Algo";
            // 
            // usePriceMgmtAlgo
            // 
            this.usePriceMgmtAlgo.AutoSize = true;
            this.usePriceMgmtAlgo.Checked = true;
            this.usePriceMgmtAlgo.CheckState = System.Windows.Forms.CheckState.Indeterminate;
            this.usePriceMgmtAlgo.Location = new System.Drawing.Point(256, 363);
            this.usePriceMgmtAlgo.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.usePriceMgmtAlgo.Name = "usePriceMgmtAlgo";
            this.usePriceMgmtAlgo.Size = new System.Drawing.Size(18, 17);
            this.usePriceMgmtAlgo.TabIndex = 24;
            this.usePriceMgmtAlgo.UseVisualStyleBackColor = true;
            // 
            // cashQty
            // 
            this.cashQty.Location = new System.Drawing.Point(161, 331);
            this.cashQty.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.cashQty.Name = "cashQty";
            this.cashQty.Size = new System.Drawing.Size(117, 22);
            this.cashQty.TabIndex = 23;
            // 
            // cashQtyLabel
            // 
            this.cashQtyLabel.AutoSize = true;
            this.cashQtyLabel.Location = new System.Drawing.Point(19, 335);
            this.cashQtyLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.cashQtyLabel.Name = "cashQtyLabel";
            this.cashQtyLabel.Size = new System.Drawing.Size(66, 17);
            this.cashQtyLabel.TabIndex = 22;
            this.cashQtyLabel.Text = "Cash Qty";
            // 
            // modelCode
            // 
            this.modelCode.Location = new System.Drawing.Point(161, 66);
            this.modelCode.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.modelCode.Name = "modelCode";
            this.modelCode.Size = new System.Drawing.Size(117, 22);
            this.modelCode.TabIndex = 3;
            // 
            // modelCodeLabel
            // 
            this.modelCodeLabel.AutoSize = true;
            this.modelCodeLabel.Location = new System.Drawing.Point(17, 75);
            this.modelCodeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.modelCodeLabel.Name = "modelCodeLabel";
            this.modelCodeLabel.Size = new System.Drawing.Size(83, 17);
            this.modelCodeLabel.TabIndex = 2;
            this.modelCodeLabel.Text = "Model Code";
            // 
            // timeInForce
            // 
            this.timeInForce.FormattingEnabled = true;
            this.timeInForce.Items.AddRange(new object[] {
            "DAY",
            "GTC",
            "OPG",
            "IOC",
            "GTD",
            "GTT",
            "AUC",
            "FOK",
            "GTX",
            "DTC"});
            this.timeInForce.Location = new System.Drawing.Point(161, 298);
            this.timeInForce.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.timeInForce.Name = "timeInForce";
            this.timeInForce.Size = new System.Drawing.Size(117, 24);
            this.timeInForce.TabIndex = 15;
            this.timeInForce.Text = "DAY";
            // 
            // auxPrice
            // 
            this.auxPrice.Location = new System.Drawing.Point(161, 266);
            this.auxPrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.auxPrice.Name = "auxPrice";
            this.auxPrice.Size = new System.Drawing.Size(117, 22);
            this.auxPrice.TabIndex = 14;
            this.auxPrice.Text = "0";
            // 
            // lmtPrice
            // 
            this.lmtPrice.Location = new System.Drawing.Point(161, 234);
            this.lmtPrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.lmtPrice.Name = "lmtPrice";
            this.lmtPrice.Size = new System.Drawing.Size(117, 22);
            this.lmtPrice.TabIndex = 13;
            // 
            // orderType
            // 
            this.orderType.FormattingEnabled = true;
            this.orderType.Items.AddRange(new object[] {
            "MKT",
            "LMT",
            "STP",
            "STP LMT",
            "REL",
            "TRAIL",
            "BOX TOP",
            "FIX PEGGED",
            "LIT",
            "LMT + MKT",
            "LOC",
            "MIT",
            "MKT PRT",
            "MOC",
            "MTL",
            "PASSV REL",
            "PEG BENCH",
            "PEG MID",
            "PEG MKT",
            "PEG PRIM",
            "PEG STK",
            "REL +LMT",
            "REL + MKT",
            "STP PRT",
            "TRAIL LIMIT",
            "TRAIL LMT + MKT",
            "TRAIL LIT",
            "TRAIL REL + MKT",
            "TRAIL MIT",
            "TRAIL REL + MKT",
            "VOL",
            "VWAP"});
            this.orderType.Location = new System.Drawing.Point(161, 201);
            this.orderType.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.orderType.Name = "orderType";
            this.orderType.Size = new System.Drawing.Size(152, 24);
            this.orderType.TabIndex = 11;
            this.orderType.Text = "SNAP MID";
            // 
            // displaySize
            // 
            this.displaySize.Location = new System.Drawing.Point(161, 169);
            this.displaySize.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.displaySize.Name = "displaySize";
            this.displaySize.Size = new System.Drawing.Size(117, 22);
            this.displaySize.TabIndex = 9;
            // 
            // quantity
            // 
            this.quantity.Location = new System.Drawing.Point(161, 137);
            this.quantity.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.quantity.Name = "quantity";
            this.quantity.Size = new System.Drawing.Size(117, 22);
            this.quantity.TabIndex = 7;
            this.quantity.Text = "1";
            // 
            // action
            // 
            this.action.FormattingEnabled = true;
            this.action.Items.AddRange(new object[] {
            "BUY",
            "SELL",
            "SSHORT"});
            this.action.Location = new System.Drawing.Point(161, 100);
            this.action.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.action.Name = "action";
            this.action.Size = new System.Drawing.Size(117, 24);
            this.action.TabIndex = 5;
            this.action.Text = "BUY";
            // 
            // timeInForceLabel
            // 
            this.timeInForceLabel.AutoSize = true;
            this.timeInForceLabel.Location = new System.Drawing.Point(17, 302);
            this.timeInForceLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.timeInForceLabel.Name = "timeInForceLabel";
            this.timeInForceLabel.Size = new System.Drawing.Size(92, 17);
            this.timeInForceLabel.TabIndex = 8;
            this.timeInForceLabel.Text = "Time-in-force";
            // 
            // auxPriceLabel
            // 
            this.auxPriceLabel.AutoSize = true;
            this.auxPriceLabel.Location = new System.Drawing.Point(17, 270);
            this.auxPriceLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.auxPriceLabel.Name = "auxPriceLabel";
            this.auxPriceLabel.Size = new System.Drawing.Size(71, 17);
            this.auxPriceLabel.TabIndex = 7;
            this.auxPriceLabel.Text = "Aux. Price";
            // 
            // account
            // 
            this.account.FormattingEnabled = true;
            this.account.Location = new System.Drawing.Point(161, 31);
            this.account.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.account.Name = "account";
            this.account.Size = new System.Drawing.Size(117, 24);
            this.account.TabIndex = 1;
            // 
            // limitPriceLabel
            // 
            this.limitPriceLabel.AutoSize = true;
            this.limitPriceLabel.Location = new System.Drawing.Point(17, 235);
            this.limitPriceLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.limitPriceLabel.Name = "limitPriceLabel";
            this.limitPriceLabel.Size = new System.Drawing.Size(73, 17);
            this.limitPriceLabel.TabIndex = 5;
            this.limitPriceLabel.Text = "Limit Price";
            // 
            // orderTypeLabel
            // 
            this.orderTypeLabel.AutoSize = true;
            this.orderTypeLabel.Location = new System.Drawing.Point(17, 204);
            this.orderTypeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderTypeLabel.Name = "orderTypeLabel";
            this.orderTypeLabel.Size = new System.Drawing.Size(81, 17);
            this.orderTypeLabel.TabIndex = 10;
            this.orderTypeLabel.Text = "Order Type";
            // 
            // displaySizeLabel
            // 
            this.displaySizeLabel.AutoSize = true;
            this.displaySizeLabel.Location = new System.Drawing.Point(17, 172);
            this.displaySizeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.displaySizeLabel.Name = "displaySizeLabel";
            this.displaySizeLabel.Size = new System.Drawing.Size(85, 17);
            this.displaySizeLabel.TabIndex = 8;
            this.displaySizeLabel.Text = "Display Size";
            // 
            // quantityLabel
            // 
            this.quantityLabel.AutoSize = true;
            this.quantityLabel.Location = new System.Drawing.Point(17, 140);
            this.quantityLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.quantityLabel.Name = "quantityLabel";
            this.quantityLabel.Size = new System.Drawing.Size(61, 17);
            this.quantityLabel.TabIndex = 6;
            this.quantityLabel.Text = "Quantity";
            // 
            // actionLabel
            // 
            this.actionLabel.AutoSize = true;
            this.actionLabel.Location = new System.Drawing.Point(17, 111);
            this.actionLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.actionLabel.Name = "actionLabel";
            this.actionLabel.Size = new System.Drawing.Size(47, 17);
            this.actionLabel.TabIndex = 4;
            this.actionLabel.Text = "Action";
            // 
            // accountLabel
            // 
            this.accountLabel.AutoSize = true;
            this.accountLabel.Location = new System.Drawing.Point(17, 41);
            this.accountLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.accountLabel.Name = "accountLabel";
            this.accountLabel.Size = new System.Drawing.Size(59, 17);
            this.accountLabel.TabIndex = 0;
            this.accountLabel.Text = "Account";
            // 
            // contractGroup
            // 
            this.contractGroup.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.contractGroup.Controls.Add(this.orderPrimExchLabel);
            this.contractGroup.Controls.Add(this.contractPrimaryExch);
            this.contractGroup.Controls.Add(this.orderLocalSymbol);
            this.contractGroup.Controls.Add(this.orderCurrencyLabel);
            this.contractGroup.Controls.Add(this.orderExchangeLabel);
            this.contractGroup.Controls.Add(this.orderSymbolLabel);
            this.contractGroup.Controls.Add(this.orderMultiplierLabel);
            this.contractGroup.Controls.Add(this.contractSymbol);
            this.contractGroup.Controls.Add(this.orderRightLabel);
            this.contractGroup.Controls.Add(this.contractSecType);
            this.contractGroup.Controls.Add(this.orderStrikeLabel);
            this.contractGroup.Controls.Add(this.contractLastTradeDateOrContractMonth);
            this.contractGroup.Controls.Add(this.orderLastTradeDateOrContractMonthLabel);
            this.contractGroup.Controls.Add(this.contractStrike);
            this.contractGroup.Controls.Add(this.orderSecTypeLabel);
            this.contractGroup.Controls.Add(this.contractRight);
            this.contractGroup.Controls.Add(this.contractLocalSymbol);
            this.contractGroup.Controls.Add(this.contractMultiplier);
            this.contractGroup.Controls.Add(this.contractCurrency);
            this.contractGroup.Controls.Add(this.contractExchange);
            this.contractGroup.Location = new System.Drawing.Point(8, 7);
            this.contractGroup.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractGroup.Name = "contractGroup";
            this.contractGroup.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractGroup.Size = new System.Drawing.Size(467, 372);
            this.contractGroup.TabIndex = 14;
            this.contractGroup.TabStop = false;
            this.contractGroup.Text = "Contract";
            // 
            // orderPrimExchLabel
            // 
            this.orderPrimExchLabel.AutoSize = true;
            this.orderPrimExchLabel.Location = new System.Drawing.Point(7, 201);
            this.orderPrimExchLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderPrimExchLabel.Name = "orderPrimExchLabel";
            this.orderPrimExchLabel.Size = new System.Drawing.Size(94, 17);
            this.orderPrimExchLabel.TabIndex = 18;
            this.orderPrimExchLabel.Text = "Primary Exch.";
            // 
            // contractPrimaryExch
            // 
            this.contractPrimaryExch.Location = new System.Drawing.Point(109, 197);
            this.contractPrimaryExch.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractPrimaryExch.Name = "contractPrimaryExch";
            this.contractPrimaryExch.Size = new System.Drawing.Size(93, 22);
            this.contractPrimaryExch.TabIndex = 17;
            // 
            // orderLocalSymbol
            // 
            this.orderLocalSymbol.AutoSize = true;
            this.orderLocalSymbol.Location = new System.Drawing.Point(9, 164);
            this.orderLocalSymbol.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderLocalSymbol.Name = "orderLocalSymbol";
            this.orderLocalSymbol.Size = new System.Drawing.Size(92, 17);
            this.orderLocalSymbol.TabIndex = 16;
            this.orderLocalSymbol.Text = "Local Symbol";
            // 
            // orderCurrencyLabel
            // 
            this.orderCurrencyLabel.AutoSize = true;
            this.orderCurrencyLabel.Location = new System.Drawing.Point(36, 130);
            this.orderCurrencyLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderCurrencyLabel.Name = "orderCurrencyLabel";
            this.orderCurrencyLabel.Size = new System.Drawing.Size(65, 17);
            this.orderCurrencyLabel.TabIndex = 15;
            this.orderCurrencyLabel.Text = "Currency";
            // 
            // orderExchangeLabel
            // 
            this.orderExchangeLabel.AutoSize = true;
            this.orderExchangeLabel.Location = new System.Drawing.Point(28, 98);
            this.orderExchangeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderExchangeLabel.Name = "orderExchangeLabel";
            this.orderExchangeLabel.Size = new System.Drawing.Size(70, 17);
            this.orderExchangeLabel.TabIndex = 14;
            this.orderExchangeLabel.Text = "Exchange";
            // 
            // orderSymbolLabel
            // 
            this.orderSymbolLabel.AutoSize = true;
            this.orderSymbolLabel.Location = new System.Drawing.Point(47, 33);
            this.orderSymbolLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderSymbolLabel.Name = "orderSymbolLabel";
            this.orderSymbolLabel.Size = new System.Drawing.Size(54, 17);
            this.orderSymbolLabel.TabIndex = 0;
            this.orderSymbolLabel.Text = "Symbol";
            // 
            // orderMultiplierLabel
            // 
            this.orderMultiplierLabel.AutoSize = true;
            this.orderMultiplierLabel.Location = new System.Drawing.Point(292, 138);
            this.orderMultiplierLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderMultiplierLabel.Name = "orderMultiplierLabel";
            this.orderMultiplierLabel.Size = new System.Drawing.Size(64, 17);
            this.orderMultiplierLabel.TabIndex = 13;
            this.orderMultiplierLabel.Text = "Multiplier";
            // 
            // orderRightLabel
            // 
            this.orderRightLabel.AutoSize = true;
            this.orderRightLabel.Location = new System.Drawing.Point(296, 105);
            this.orderRightLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderRightLabel.Name = "orderRightLabel";
            this.orderRightLabel.Size = new System.Drawing.Size(56, 17);
            this.orderRightLabel.TabIndex = 12;
            this.orderRightLabel.Text = "Put/Call";
            // 
            // contractSecType
            // 
            this.contractSecType.FormattingEnabled = true;
            this.contractSecType.Items.AddRange(new object[] {
            "STK",
            "OPT",
            "FUT",
            "CASH",
            "BOND",
            "CFD",
            "FOP",
            "WAR",
            "IOPT",
            "FWD",
            "BAG",
            "IND",
            "BILL",
            "FUND",
            "FIXED",
            "SLB",
            "NEWS",
            "CMDTY",
            "BSK",
            "ICU",
            "ICS"});
            this.contractSecType.Location = new System.Drawing.Point(109, 62);
            this.contractSecType.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractSecType.Name = "contractSecType";
            this.contractSecType.Size = new System.Drawing.Size(93, 24);
            this.contractSecType.TabIndex = 1;
            this.contractSecType.Text = "OPT";
            // 
            // orderStrikeLabel
            // 
            this.orderStrikeLabel.AutoSize = true;
            this.orderStrikeLabel.Location = new System.Drawing.Point(311, 70);
            this.orderStrikeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderStrikeLabel.Name = "orderStrikeLabel";
            this.orderStrikeLabel.Size = new System.Drawing.Size(44, 17);
            this.orderStrikeLabel.TabIndex = 11;
            this.orderStrikeLabel.Text = "Strike";
            // 
            // contractLastTradeDateOrContractMonth
            // 
            this.contractLastTradeDateOrContractMonth.Location = new System.Drawing.Point(364, 27);
            this.contractLastTradeDateOrContractMonth.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractLastTradeDateOrContractMonth.Name = "contractLastTradeDateOrContractMonth";
            this.contractLastTradeDateOrContractMonth.Size = new System.Drawing.Size(93, 22);
            this.contractLastTradeDateOrContractMonth.TabIndex = 2;
            this.contractLastTradeDateOrContractMonth.Text = "20200612";
            // 
            // orderLastTradeDateOrContractMonthLabel
            // 
            this.orderLastTradeDateOrContractMonthLabel.Location = new System.Drawing.Point(237, 27);
            this.orderLastTradeDateOrContractMonthLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderLastTradeDateOrContractMonthLabel.Name = "orderLastTradeDateOrContractMonthLabel";
            this.orderLastTradeDateOrContractMonthLabel.Size = new System.Drawing.Size(119, 34);
            this.orderLastTradeDateOrContractMonthLabel.TabIndex = 10;
            this.orderLastTradeDateOrContractMonthLabel.Text = "Last trade date / contract month";
            // 
            // contractStrike
            // 
            this.contractStrike.Location = new System.Drawing.Point(364, 66);
            this.contractStrike.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractStrike.Name = "contractStrike";
            this.contractStrike.Size = new System.Drawing.Size(93, 22);
            this.contractStrike.TabIndex = 3;
            this.contractStrike.Text = "330";
            // 
            // orderSecTypeLabel
            // 
            this.orderSecTypeLabel.AutoSize = true;
            this.orderSecTypeLabel.Location = new System.Drawing.Point(35, 68);
            this.orderSecTypeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderSecTypeLabel.Name = "orderSecTypeLabel";
            this.orderSecTypeLabel.Size = new System.Drawing.Size(64, 17);
            this.orderSecTypeLabel.TabIndex = 9;
            this.orderSecTypeLabel.Text = "SecType";
            // 
            // contractRight
            // 
            this.contractRight.FormattingEnabled = true;
            this.contractRight.Location = new System.Drawing.Point(364, 101);
            this.contractRight.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractRight.Name = "contractRight";
            this.contractRight.Size = new System.Drawing.Size(93, 24);
            this.contractRight.TabIndex = 4;
            this.contractRight.Text = "CALL";
            // 
            // contractLocalSymbol
            // 
            this.contractLocalSymbol.Location = new System.Drawing.Point(109, 160);
            this.contractLocalSymbol.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractLocalSymbol.Name = "contractLocalSymbol";
            this.contractLocalSymbol.Size = new System.Drawing.Size(93, 22);
            this.contractLocalSymbol.TabIndex = 8;
            // 
            // contractMultiplier
            // 
            this.contractMultiplier.Location = new System.Drawing.Point(364, 134);
            this.contractMultiplier.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractMultiplier.Name = "contractMultiplier";
            this.contractMultiplier.Size = new System.Drawing.Size(93, 22);
            this.contractMultiplier.TabIndex = 5;
            this.contractMultiplier.Text = "1";
            // 
            // contractCurrency
            // 
            this.contractCurrency.Location = new System.Drawing.Point(109, 127);
            this.contractCurrency.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractCurrency.Name = "contractCurrency";
            this.contractCurrency.Size = new System.Drawing.Size(93, 22);
            this.contractCurrency.TabIndex = 7;
            this.contractCurrency.Text = "USD";
            // 
            // contractExchange
            // 
            this.contractExchange.Location = new System.Drawing.Point(109, 95);
            this.contractExchange.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.contractExchange.Name = "contractExchange";
            this.contractExchange.Size = new System.Drawing.Size(93, 22);
            this.contractExchange.TabIndex = 6;
            this.contractExchange.Text = "SMART";
            // 
            // extendedOrderTab
            // 
            this.extendedOrderTab.BackColor = System.Drawing.Color.LightGray;
            this.extendedOrderTab.Controls.Add(this.relativeDiscretionary);
            this.extendedOrderTab.Controls.Add(this.omsContainer);
            this.extendedOrderTab.Controls.Add(this.dontUseAutoPriceForHedge);
            this.extendedOrderTab.Controls.Add(this.label22);
            this.extendedOrderTab.Controls.Add(this.mifid2ExecutionAlgo);
            this.extendedOrderTab.Controls.Add(this.label23);
            this.extendedOrderTab.Controls.Add(this.mifid2ExecutionTrader);
            this.extendedOrderTab.Controls.Add(this.label18);
            this.extendedOrderTab.Controls.Add(this.mifid2DecisionAlgo);
            this.extendedOrderTab.Controls.Add(this.label19);
            this.extendedOrderTab.Controls.Add(this.mifid2DecisionMaker);
            this.extendedOrderTab.Controls.Add(this.label17);
            this.extendedOrderTab.Controls.Add(this.softDollarTier);
            this.extendedOrderTab.Controls.Add(this.nbboPriceCapLabel);
            this.extendedOrderTab.Controls.Add(this.trailingPercentLabel);
            this.extendedOrderTab.Controls.Add(this.transmit);
            this.extendedOrderTab.Controls.Add(this.firmQuote);
            this.extendedOrderTab.Controls.Add(this.overrideConstraints);
            this.extendedOrderTab.Controls.Add(this.label5);
            this.extendedOrderTab.Controls.Add(this.eTrade);
            this.extendedOrderTab.Controls.Add(this.optOutSmart);
            this.extendedOrderTab.Controls.Add(this.nbboPriceCap);
            this.extendedOrderTab.Controls.Add(this.trailingPercent);
            this.extendedOrderTab.Controls.Add(this.discretionaryAmount);
            this.extendedOrderTab.Controls.Add(this.hidden);
            this.extendedOrderTab.Controls.Add(this.outsideRTH);
            this.extendedOrderTab.Controls.Add(this.label3);
            this.extendedOrderTab.Controls.Add(this.allOrNone);
            this.extendedOrderTab.Controls.Add(this.label2);
            this.extendedOrderTab.Controls.Add(this.notHeld);
            this.extendedOrderTab.Controls.Add(this.block);
            this.extendedOrderTab.Controls.Add(this.label1);
            this.extendedOrderTab.Controls.Add(this.sweepToFill);
            this.extendedOrderTab.Controls.Add(this.percentOffsetLabel);
            this.extendedOrderTab.Controls.Add(this.tiggerMethodLabel);
            this.extendedOrderTab.Controls.Add(this.rule80ALabel);
            this.extendedOrderTab.Controls.Add(this.goodUntilLabel);
            this.extendedOrderTab.Controls.Add(this.goodAfterLabel);
            this.extendedOrderTab.Controls.Add(this.ocaGroup);
            this.extendedOrderTab.Controls.Add(this.hedgeParam);
            this.extendedOrderTab.Controls.Add(this.ocaType);
            this.extendedOrderTab.Controls.Add(this.hedgeType);
            this.extendedOrderTab.Controls.Add(this.orderMinQtyLabel);
            this.extendedOrderTab.Controls.Add(this.orderRefLabel);
            this.extendedOrderTab.Controls.Add(this.trailStopPrice);
            this.extendedOrderTab.Controls.Add(this.percentOffset);
            this.extendedOrderTab.Controls.Add(this.triggerMethod);
            this.extendedOrderTab.Controls.Add(this.rule80A);
            this.extendedOrderTab.Controls.Add(this.goodUntil);
            this.extendedOrderTab.Controls.Add(this.goodAfter);
            this.extendedOrderTab.Controls.Add(this.minQty);
            this.extendedOrderTab.Controls.Add(this.orderReference);
            this.extendedOrderTab.Location = new System.Drawing.Point(4, 25);
            this.extendedOrderTab.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.extendedOrderTab.Name = "extendedOrderTab";
            this.extendedOrderTab.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.extendedOrderTab.Size = new System.Drawing.Size(836, 418);
            this.extendedOrderTab.TabIndex = 1;
            this.extendedOrderTab.Text = "Extended Attributes";
            // 
            // relativeDiscretionary
            // 
            this.relativeDiscretionary.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.relativeDiscretionary.AutoSize = true;
            this.relativeDiscretionary.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.relativeDiscretionary.Location = new System.Drawing.Point(554, 336);
            this.relativeDiscretionary.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.relativeDiscretionary.Name = "relativeDiscretionary";
            this.relativeDiscretionary.Size = new System.Drawing.Size(166, 21);
            this.relativeDiscretionary.TabIndex = 51;
            this.relativeDiscretionary.Text = "Relative discretionary";
            this.relativeDiscretionary.UseVisualStyleBackColor = true;
            // 
            // omsContainer
            // 
            this.omsContainer.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.omsContainer.AutoSize = true;
            this.omsContainer.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.omsContainer.Location = new System.Drawing.Point(594, 313);
            this.omsContainer.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.omsContainer.Name = "omsContainer";
            this.omsContainer.Size = new System.Drawing.Size(126, 21);
            this.omsContainer.TabIndex = 50;
            this.omsContainer.Text = "OMS Container";
            this.omsContainer.UseVisualStyleBackColor = true;
            // 
            // dontUseAutoPriceForHedge
            // 
            this.dontUseAutoPriceForHedge.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.dontUseAutoPriceForHedge.AutoSize = true;
            this.dontUseAutoPriceForHedge.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.dontUseAutoPriceForHedge.Location = new System.Drawing.Point(498, 284);
            this.dontUseAutoPriceForHedge.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.dontUseAutoPriceForHedge.Name = "dontUseAutoPriceForHedge";
            this.dontUseAutoPriceForHedge.Size = new System.Drawing.Size(222, 21);
            this.dontUseAutoPriceForHedge.TabIndex = 45;
            this.dontUseAutoPriceForHedge.Text = "Don\'t use auto price for hedge";
            this.dontUseAutoPriceForHedge.UseVisualStyleBackColor = true;
            // 
            // label22
            // 
            this.label22.AutoSize = true;
            this.label22.Location = new System.Drawing.Point(273, 372);
            this.label22.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label22.Name = "label22";
            this.label22.Size = new System.Drawing.Size(150, 17);
            this.label22.TabIndex = 48;
            this.label22.Text = "MiFID II Execution Algo";
            // 
            // mifid2ExecutionAlgo
            // 
            this.mifid2ExecutionAlgo.Location = new System.Drawing.Point(452, 368);
            this.mifid2ExecutionAlgo.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.mifid2ExecutionAlgo.Name = "mifid2ExecutionAlgo";
            this.mifid2ExecutionAlgo.Size = new System.Drawing.Size(92, 22);
            this.mifid2ExecutionAlgo.TabIndex = 49;
            // 
            // label23
            // 
            this.label23.AutoSize = true;
            this.label23.Location = new System.Drawing.Point(273, 340);
            this.label23.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label23.Name = "label23";
            this.label23.Size = new System.Drawing.Size(165, 17);
            this.label23.TabIndex = 46;
            this.label23.Text = "MiFID II Execution Trader";
            // 
            // mifid2ExecutionTrader
            // 
            this.mifid2ExecutionTrader.Location = new System.Drawing.Point(452, 336);
            this.mifid2ExecutionTrader.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.mifid2ExecutionTrader.Name = "mifid2ExecutionTrader";
            this.mifid2ExecutionTrader.Size = new System.Drawing.Size(92, 22);
            this.mifid2ExecutionTrader.TabIndex = 47;
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Location = new System.Drawing.Point(9, 372);
            this.label18.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(143, 17);
            this.label18.TabIndex = 22;
            this.label18.Text = "MiFID II Decision Algo";
            // 
            // mifid2DecisionAlgo
            // 
            this.mifid2DecisionAlgo.Location = new System.Drawing.Point(167, 368);
            this.mifid2DecisionAlgo.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.mifid2DecisionAlgo.Name = "mifid2DecisionAlgo";
            this.mifid2DecisionAlgo.Size = new System.Drawing.Size(92, 22);
            this.mifid2DecisionAlgo.TabIndex = 23;
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Location = new System.Drawing.Point(4, 340);
            this.label19.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(154, 17);
            this.label19.TabIndex = 20;
            this.label19.Text = "MiFID II Decision Maker";
            // 
            // mifid2DecisionMaker
            // 
            this.mifid2DecisionMaker.Location = new System.Drawing.Point(167, 336);
            this.mifid2DecisionMaker.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.mifid2DecisionMaker.Name = "mifid2DecisionMaker";
            this.mifid2DecisionMaker.Size = new System.Drawing.Size(92, 22);
            this.mifid2DecisionMaker.TabIndex = 21;
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Location = new System.Drawing.Point(64, 306);
            this.label17.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(96, 17);
            this.label17.TabIndex = 18;
            this.label17.Text = "Soft dollar tier";
            // 
            // softDollarTier
            // 
            this.softDollarTier.FormattingEnabled = true;
            this.softDollarTier.Location = new System.Drawing.Point(167, 303);
            this.softDollarTier.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.softDollarTier.Name = "softDollarTier";
            this.softDollarTier.Size = new System.Drawing.Size(145, 24);
            this.softDollarTier.TabIndex = 19;
            // 
            // nbboPriceCapLabel
            // 
            this.nbboPriceCapLabel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.nbboPriceCapLabel.AutoSize = true;
            this.nbboPriceCapLabel.Location = new System.Drawing.Point(417, 114);
            this.nbboPriceCapLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.nbboPriceCapLabel.Name = "nbboPriceCapLabel";
            this.nbboPriceCapLabel.Size = new System.Drawing.Size(109, 17);
            this.nbboPriceCapLabel.TabIndex = 32;
            this.nbboPriceCapLabel.Text = "NBBO price cap";
            // 
            // trailingPercentLabel
            // 
            this.trailingPercentLabel.AutoSize = true;
            this.trailingPercentLabel.Location = new System.Drawing.Point(52, 276);
            this.trailingPercentLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.trailingPercentLabel.Name = "trailingPercentLabel";
            this.trailingPercentLabel.Size = new System.Drawing.Size(107, 17);
            this.trailingPercentLabel.TabIndex = 16;
            this.trailingPercentLabel.Text = "Trailing percent";
            // 
            // transmit
            // 
            this.transmit.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.transmit.AutoSize = true;
            this.transmit.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.transmit.Checked = true;
            this.transmit.CheckState = System.Windows.Forms.CheckState.Checked;
            this.transmit.Location = new System.Drawing.Point(735, 145);
            this.transmit.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.transmit.Name = "transmit";
            this.transmit.Size = new System.Drawing.Size(85, 21);
            this.transmit.TabIndex = 36;
            this.transmit.Text = "Transmit";
            this.transmit.UseVisualStyleBackColor = true;
            // 
            // firmQuote
            // 
            this.firmQuote.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.firmQuote.AutoSize = true;
            this.firmQuote.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.firmQuote.Location = new System.Drawing.Point(593, 228);
            this.firmQuote.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.firmQuote.Name = "firmQuote";
            this.firmQuote.Size = new System.Drawing.Size(127, 21);
            this.firmQuote.TabIndex = 42;
            this.firmQuote.Text = "Firm quote only";
            this.firmQuote.UseVisualStyleBackColor = true;
            // 
            // overrideConstraints
            // 
            this.overrideConstraints.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.overrideConstraints.AutoSize = true;
            this.overrideConstraints.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.overrideConstraints.Location = new System.Drawing.Point(562, 174);
            this.overrideConstraints.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.overrideConstraints.Name = "overrideConstraints";
            this.overrideConstraints.Size = new System.Drawing.Size(158, 21);
            this.overrideConstraints.TabIndex = 38;
            this.overrideConstraints.Text = "Override constraints";
            this.overrideConstraints.UseVisualStyleBackColor = true;
            // 
            // label5
            // 
            this.label5.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(388, 82);
            this.label5.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(142, 17);
            this.label5.TabIndex = 30;
            this.label5.Text = "Discretionary amount";
            // 
            // eTrade
            // 
            this.eTrade.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.eTrade.AutoSize = true;
            this.eTrade.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.eTrade.Location = new System.Drawing.Point(613, 202);
            this.eTrade.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.eTrade.Name = "eTrade";
            this.eTrade.Size = new System.Drawing.Size(107, 21);
            this.eTrade.TabIndex = 40;
            this.eTrade.Text = "E-trade only";
            this.eTrade.UseVisualStyleBackColor = true;
            // 
            // optOutSmart
            // 
            this.optOutSmart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.optOutSmart.AutoSize = true;
            this.optOutSmart.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.optOutSmart.Location = new System.Drawing.Point(543, 256);
            this.optOutSmart.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.optOutSmart.Name = "optOutSmart";
            this.optOutSmart.Size = new System.Drawing.Size(177, 21);
            this.optOutSmart.TabIndex = 44;
            this.optOutSmart.Text = "Opt out SMART routing";
            this.optOutSmart.UseVisualStyleBackColor = true;
            // 
            // nbboPriceCap
            // 
            this.nbboPriceCap.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.nbboPriceCap.Location = new System.Drawing.Point(537, 111);
            this.nbboPriceCap.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.nbboPriceCap.Name = "nbboPriceCap";
            this.nbboPriceCap.Size = new System.Drawing.Size(92, 22);
            this.nbboPriceCap.TabIndex = 33;
            // 
            // trailingPercent
            // 
            this.trailingPercent.Location = new System.Drawing.Point(167, 271);
            this.trailingPercent.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.trailingPercent.Name = "trailingPercent";
            this.trailingPercent.Size = new System.Drawing.Size(92, 22);
            this.trailingPercent.TabIndex = 17;
            // 
            // discretionaryAmount
            // 
            this.discretionaryAmount.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.discretionaryAmount.Location = new System.Drawing.Point(537, 79);
            this.discretionaryAmount.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.discretionaryAmount.Name = "discretionaryAmount";
            this.discretionaryAmount.Size = new System.Drawing.Size(92, 22);
            this.discretionaryAmount.TabIndex = 31;
            // 
            // hidden
            // 
            this.hidden.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.hidden.AutoSize = true;
            this.hidden.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.hidden.Location = new System.Drawing.Point(454, 228);
            this.hidden.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.hidden.Name = "hidden";
            this.hidden.Size = new System.Drawing.Size(75, 21);
            this.hidden.TabIndex = 41;
            this.hidden.Text = "Hidden";
            this.hidden.UseVisualStyleBackColor = true;
            // 
            // outsideRTH
            // 
            this.outsideRTH.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.outsideRTH.AutoSize = true;
            this.outsideRTH.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.outsideRTH.Location = new System.Drawing.Point(399, 256);
            this.outsideRTH.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.outsideRTH.Name = "outsideRTH";
            this.outsideRTH.Size = new System.Drawing.Size(130, 21);
            this.outsideRTH.TabIndex = 43;
            this.outsideRTH.Text = "Fill outside RTH";
            this.outsideRTH.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(376, 52);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(153, 17);
            this.label3.TabIndex = 27;
            this.label3.Text = "Hedge type and param";
            // 
            // allOrNone
            // 
            this.allOrNone.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.allOrNone.AutoSize = true;
            this.allOrNone.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.allOrNone.Location = new System.Drawing.Point(622, 145);
            this.allOrNone.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.allOrNone.Name = "allOrNone";
            this.allOrNone.Size = new System.Drawing.Size(98, 21);
            this.allOrNone.TabIndex = 35;
            this.allOrNone.Text = "All or none";
            this.allOrNone.UseVisualStyleBackColor = true;
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(392, 18);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(137, 17);
            this.label2.TabIndex = 24;
            this.label2.Text = "OCA group and type";
            // 
            // notHeld
            // 
            this.notHeld.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.notHeld.AutoSize = true;
            this.notHeld.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.notHeld.Location = new System.Drawing.Point(447, 145);
            this.notHeld.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.notHeld.Name = "notHeld";
            this.notHeld.Size = new System.Drawing.Size(83, 21);
            this.notHeld.TabIndex = 34;
            this.notHeld.Text = "Not held";
            this.notHeld.UseVisualStyleBackColor = true;
            // 
            // block
            // 
            this.block.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.block.AutoSize = true;
            this.block.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.block.Location = new System.Drawing.Point(427, 174);
            this.block.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.block.Name = "block";
            this.block.Size = new System.Drawing.Size(102, 21);
            this.block.TabIndex = 37;
            this.block.Text = "Block order";
            this.block.UseVisualStyleBackColor = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(21, 244);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(140, 17);
            this.label1.TabIndex = 14;
            this.label1.Text = "Trail order stop price";
            // 
            // sweepToFill
            // 
            this.sweepToFill.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.sweepToFill.AutoSize = true;
            this.sweepToFill.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.sweepToFill.Location = new System.Drawing.Point(424, 202);
            this.sweepToFill.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.sweepToFill.Name = "sweepToFill";
            this.sweepToFill.Size = new System.Drawing.Size(105, 21);
            this.sweepToFill.TabIndex = 39;
            this.sweepToFill.Text = "Sweep to fill";
            this.sweepToFill.UseVisualStyleBackColor = true;
            // 
            // percentOffsetLabel
            // 
            this.percentOffsetLabel.AutoSize = true;
            this.percentOffsetLabel.Location = new System.Drawing.Point(59, 212);
            this.percentOffsetLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.percentOffsetLabel.Name = "percentOffsetLabel";
            this.percentOffsetLabel.Size = new System.Drawing.Size(99, 17);
            this.percentOffsetLabel.TabIndex = 12;
            this.percentOffsetLabel.Text = "Percent Offset";
            // 
            // tiggerMethodLabel
            // 
            this.tiggerMethodLabel.AutoSize = true;
            this.tiggerMethodLabel.Location = new System.Drawing.Point(53, 180);
            this.tiggerMethodLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.tiggerMethodLabel.Name = "tiggerMethodLabel";
            this.tiggerMethodLabel.Size = new System.Drawing.Size(105, 17);
            this.tiggerMethodLabel.TabIndex = 10;
            this.tiggerMethodLabel.Text = "Trigger Method";
            // 
            // rule80ALabel
            // 
            this.rule80ALabel.AutoSize = true;
            this.rule80ALabel.Location = new System.Drawing.Point(91, 148);
            this.rule80ALabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.rule80ALabel.Name = "rule80ALabel";
            this.rule80ALabel.Size = new System.Drawing.Size(66, 17);
            this.rule80ALabel.TabIndex = 8;
            this.rule80ALabel.Text = "Rule 80A";
            // 
            // goodUntilLabel
            // 
            this.goodUntilLabel.AutoSize = true;
            this.goodUntilLabel.Location = new System.Drawing.Point(85, 116);
            this.goodUntilLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.goodUntilLabel.Name = "goodUntilLabel";
            this.goodUntilLabel.Size = new System.Drawing.Size(73, 17);
            this.goodUntilLabel.TabIndex = 6;
            this.goodUntilLabel.Text = "Good until";
            // 
            // goodAfterLabel
            // 
            this.goodAfterLabel.AutoSize = true;
            this.goodAfterLabel.Location = new System.Drawing.Point(83, 84);
            this.goodAfterLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.goodAfterLabel.Name = "goodAfterLabel";
            this.goodAfterLabel.Size = new System.Drawing.Size(76, 17);
            this.goodAfterLabel.TabIndex = 4;
            this.goodAfterLabel.Text = "Good after";
            // 
            // ocaGroup
            // 
            this.ocaGroup.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.ocaGroup.Location = new System.Drawing.Point(537, 15);
            this.ocaGroup.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.ocaGroup.Name = "ocaGroup";
            this.ocaGroup.Size = new System.Drawing.Size(92, 22);
            this.ocaGroup.TabIndex = 25;
            // 
            // hedgeParam
            // 
            this.hedgeParam.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.hedgeParam.Location = new System.Drawing.Point(639, 48);
            this.hedgeParam.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.hedgeParam.Name = "hedgeParam";
            this.hedgeParam.Size = new System.Drawing.Size(69, 22);
            this.hedgeParam.TabIndex = 29;
            // 
            // ocaType
            // 
            this.ocaType.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.ocaType.FormattingEnabled = true;
            this.ocaType.Location = new System.Drawing.Point(639, 15);
            this.ocaType.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.ocaType.Name = "ocaType";
            this.ocaType.Size = new System.Drawing.Size(185, 24);
            this.ocaType.TabIndex = 26;
            // 
            // hedgeType
            // 
            this.hedgeType.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.hedgeType.FormattingEnabled = true;
            this.hedgeType.Location = new System.Drawing.Point(537, 47);
            this.hedgeType.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.hedgeType.Name = "hedgeType";
            this.hedgeType.Size = new System.Drawing.Size(92, 24);
            this.hedgeType.TabIndex = 28;
            // 
            // orderMinQtyLabel
            // 
            this.orderMinQtyLabel.AutoSize = true;
            this.orderMinQtyLabel.Location = new System.Drawing.Point(93, 53);
            this.orderMinQtyLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderMinQtyLabel.Name = "orderMinQtyLabel";
            this.orderMinQtyLabel.Size = new System.Drawing.Size(64, 17);
            this.orderMinQtyLabel.TabIndex = 2;
            this.orderMinQtyLabel.Text = "Min. Qty.";
            // 
            // orderRefLabel
            // 
            this.orderRefLabel.AutoSize = true;
            this.orderRefLabel.Location = new System.Drawing.Point(84, 20);
            this.orderRefLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orderRefLabel.Name = "orderRefLabel";
            this.orderRefLabel.Size = new System.Drawing.Size(75, 17);
            this.orderRefLabel.TabIndex = 0;
            this.orderRefLabel.Text = "Order Ref.";
            // 
            // trailStopPrice
            // 
            this.trailStopPrice.Location = new System.Drawing.Point(167, 239);
            this.trailStopPrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.trailStopPrice.Name = "trailStopPrice";
            this.trailStopPrice.Size = new System.Drawing.Size(92, 22);
            this.trailStopPrice.TabIndex = 15;
            // 
            // percentOffset
            // 
            this.percentOffset.Location = new System.Drawing.Point(167, 208);
            this.percentOffset.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.percentOffset.Name = "percentOffset";
            this.percentOffset.Size = new System.Drawing.Size(92, 22);
            this.percentOffset.TabIndex = 13;
            // 
            // triggerMethod
            // 
            this.triggerMethod.FormattingEnabled = true;
            this.triggerMethod.Location = new System.Drawing.Point(167, 175);
            this.triggerMethod.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.triggerMethod.Name = "triggerMethod";
            this.triggerMethod.Size = new System.Drawing.Size(145, 24);
            this.triggerMethod.TabIndex = 11;
            // 
            // rule80A
            // 
            this.rule80A.FormattingEnabled = true;
            this.rule80A.Location = new System.Drawing.Point(167, 142);
            this.rule80A.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.rule80A.Name = "rule80A";
            this.rule80A.Size = new System.Drawing.Size(145, 24);
            this.rule80A.TabIndex = 9;
            // 
            // goodUntil
            // 
            this.goodUntil.Location = new System.Drawing.Point(167, 112);
            this.goodUntil.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.goodUntil.Name = "goodUntil";
            this.goodUntil.Size = new System.Drawing.Size(92, 22);
            this.goodUntil.TabIndex = 7;
            // 
            // goodAfter
            // 
            this.goodAfter.Location = new System.Drawing.Point(167, 80);
            this.goodAfter.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.goodAfter.Name = "goodAfter";
            this.goodAfter.Size = new System.Drawing.Size(92, 22);
            this.goodAfter.TabIndex = 5;
            // 
            // minQty
            // 
            this.minQty.Location = new System.Drawing.Point(167, 48);
            this.minQty.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.minQty.Name = "minQty";
            this.minQty.Size = new System.Drawing.Size(92, 22);
            this.minQty.TabIndex = 3;
            // 
            // orderReference
            // 
            this.orderReference.Location = new System.Drawing.Point(167, 16);
            this.orderReference.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.orderReference.Name = "orderReference";
            this.orderReference.Size = new System.Drawing.Size(92, 22);
            this.orderReference.TabIndex = 1;
            // 
            // advisorTab
            // 
            this.advisorTab.BackColor = System.Drawing.Color.LightGray;
            this.advisorTab.Controls.Add(this.faPercentage);
            this.advisorTab.Controls.Add(this.faProfile);
            this.advisorTab.Controls.Add(this.faMethod);
            this.advisorTab.Controls.Add(this.faGroup);
            this.advisorTab.Controls.Add(this.profileLabel);
            this.advisorTab.Controls.Add(this.orLabel);
            this.advisorTab.Controls.Add(this.percentageLabel);
            this.advisorTab.Controls.Add(this.methodLabel);
            this.advisorTab.Controls.Add(this.groupLabel);
            this.advisorTab.Location = new System.Drawing.Point(4, 25);
            this.advisorTab.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.advisorTab.Name = "advisorTab";
            this.advisorTab.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.advisorTab.Size = new System.Drawing.Size(836, 418);
            this.advisorTab.TabIndex = 2;
            this.advisorTab.Text = "Advisor";
            // 
            // faPercentage
            // 
            this.faPercentage.Location = new System.Drawing.Point(101, 80);
            this.faPercentage.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.faPercentage.Name = "faPercentage";
            this.faPercentage.Size = new System.Drawing.Size(93, 22);
            this.faPercentage.TabIndex = 8;
            // 
            // faProfile
            // 
            this.faProfile.Location = new System.Drawing.Point(101, 144);
            this.faProfile.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.faProfile.Name = "faProfile";
            this.faProfile.Size = new System.Drawing.Size(93, 22);
            this.faProfile.TabIndex = 7;
            // 
            // faMethod
            // 
            this.faMethod.FormattingEnabled = true;
            this.faMethod.Location = new System.Drawing.Point(101, 47);
            this.faMethod.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.faMethod.Name = "faMethod";
            this.faMethod.Size = new System.Drawing.Size(127, 24);
            this.faMethod.TabIndex = 6;
            // 
            // faGroup
            // 
            this.faGroup.Location = new System.Drawing.Point(101, 15);
            this.faGroup.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.faGroup.Name = "faGroup";
            this.faGroup.Size = new System.Drawing.Size(93, 22);
            this.faGroup.TabIndex = 5;
            // 
            // profileLabel
            // 
            this.profileLabel.AutoSize = true;
            this.profileLabel.Location = new System.Drawing.Point(45, 144);
            this.profileLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.profileLabel.Name = "profileLabel";
            this.profileLabel.Size = new System.Drawing.Size(48, 17);
            this.profileLabel.TabIndex = 4;
            this.profileLabel.Text = "Profile";
            // 
            // orLabel
            // 
            this.orLabel.AutoSize = true;
            this.orLabel.Location = new System.Drawing.Point(56, 116);
            this.orLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.orLabel.Name = "orLabel";
            this.orLabel.Size = new System.Drawing.Size(41, 17);
            this.orLabel.TabIndex = 3;
            this.orLabel.Text = "--or--";
            // 
            // percentageLabel
            // 
            this.percentageLabel.AutoSize = true;
            this.percentageLabel.Location = new System.Drawing.Point(11, 84);
            this.percentageLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.percentageLabel.Name = "percentageLabel";
            this.percentageLabel.Size = new System.Drawing.Size(81, 17);
            this.percentageLabel.TabIndex = 2;
            this.percentageLabel.Text = "Percentage";
            // 
            // methodLabel
            // 
            this.methodLabel.AutoSize = true;
            this.methodLabel.Location = new System.Drawing.Point(36, 50);
            this.methodLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.methodLabel.Name = "methodLabel";
            this.methodLabel.Size = new System.Drawing.Size(55, 17);
            this.methodLabel.TabIndex = 1;
            this.methodLabel.Text = "Method";
            // 
            // groupLabel
            // 
            this.groupLabel.AutoSize = true;
            this.groupLabel.Location = new System.Drawing.Point(45, 18);
            this.groupLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.groupLabel.Name = "groupLabel";
            this.groupLabel.Size = new System.Drawing.Size(48, 17);
            this.groupLabel.TabIndex = 0;
            this.groupLabel.Text = "Group";
            // 
            // volatilityTab
            // 
            this.volatilityTab.BackColor = System.Drawing.Color.LightGray;
            this.volatilityTab.Controls.Add(this.stockRangeLower);
            this.volatilityTab.Controls.Add(this.stockRangeUpper);
            this.volatilityTab.Controls.Add(this.deltaNeutralConId);
            this.volatilityTab.Controls.Add(this.deltaNeutralAuxPrice);
            this.volatilityTab.Controls.Add(this.deltaNeutralOrderType);
            this.volatilityTab.Controls.Add(this.optionReferencePrice);
            this.volatilityTab.Controls.Add(this.volatilityType);
            this.volatilityTab.Controls.Add(this.volatility);
            this.volatilityTab.Controls.Add(this.continuousUpdate);
            this.volatilityTab.Controls.Add(this.stockRangeLowerLabel);
            this.volatilityTab.Controls.Add(this.sockRangeUpperLabel);
            this.volatilityTab.Controls.Add(this.hedgeContractConIdLabel);
            this.volatilityTab.Controls.Add(this.hedgeOrderAuxPriceLabel);
            this.volatilityTab.Controls.Add(this.hedgeOrderTypeLabel);
            this.volatilityTab.Controls.Add(this.optionReferencePriceLabel);
            this.volatilityTab.Controls.Add(this.volatilityLabel);
            this.volatilityTab.Location = new System.Drawing.Point(4, 25);
            this.volatilityTab.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.volatilityTab.Name = "volatilityTab";
            this.volatilityTab.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.volatilityTab.Size = new System.Drawing.Size(836, 418);
            this.volatilityTab.TabIndex = 3;
            this.volatilityTab.Text = "Volatility";
            // 
            // stockRangeLower
            // 
            this.stockRangeLower.Location = new System.Drawing.Point(215, 235);
            this.stockRangeLower.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.stockRangeLower.Name = "stockRangeLower";
            this.stockRangeLower.Size = new System.Drawing.Size(93, 22);
            this.stockRangeLower.TabIndex = 16;
            // 
            // stockRangeUpper
            // 
            this.stockRangeUpper.Location = new System.Drawing.Point(215, 203);
            this.stockRangeUpper.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.stockRangeUpper.Name = "stockRangeUpper";
            this.stockRangeUpper.Size = new System.Drawing.Size(93, 22);
            this.stockRangeUpper.TabIndex = 15;
            // 
            // deltaNeutralConId
            // 
            this.deltaNeutralConId.Location = new System.Drawing.Point(215, 171);
            this.deltaNeutralConId.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.deltaNeutralConId.Name = "deltaNeutralConId";
            this.deltaNeutralConId.Size = new System.Drawing.Size(93, 22);
            this.deltaNeutralConId.TabIndex = 14;
            // 
            // deltaNeutralAuxPrice
            // 
            this.deltaNeutralAuxPrice.Location = new System.Drawing.Point(215, 139);
            this.deltaNeutralAuxPrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.deltaNeutralAuxPrice.Name = "deltaNeutralAuxPrice";
            this.deltaNeutralAuxPrice.Size = new System.Drawing.Size(93, 22);
            this.deltaNeutralAuxPrice.TabIndex = 13;
            // 
            // deltaNeutralOrderType
            // 
            this.deltaNeutralOrderType.FormattingEnabled = true;
            this.deltaNeutralOrderType.Items.AddRange(new object[] {
            "None",
            "MKT",
            "LMT",
            "STP",
            "STP LMT",
            "REL",
            "TRAIL",
            "BOX TOP",
            "FIX PEGGED",
            "LIT",
            "LMT + MKT",
            "LOC",
            "MIT",
            "MKT PRT",
            "MOC",
            "MTL",
            "PASSV REL",
            "PEG BENCH",
            "PEG MID",
            "PEG MKT",
            "PEG PRIM",
            "PEG STK",
            "REL +LMT",
            "REL + MKT",
            "STP PRT",
            "TRAIL LIMIT",
            "TRAIL LMT + MKT",
            "TRAIL LIT",
            "TRAIL REL + MKT",
            "TRAIL MIT",
            "TRAIL REL + MKT",
            "VOL",
            "VWAP"});
            this.deltaNeutralOrderType.Location = new System.Drawing.Point(215, 106);
            this.deltaNeutralOrderType.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.deltaNeutralOrderType.Name = "deltaNeutralOrderType";
            this.deltaNeutralOrderType.Size = new System.Drawing.Size(152, 24);
            this.deltaNeutralOrderType.TabIndex = 12;
            this.deltaNeutralOrderType.Text = "None";
            // 
            // optionReferencePrice
            // 
            this.optionReferencePrice.FormattingEnabled = true;
            this.optionReferencePrice.Location = new System.Drawing.Point(215, 73);
            this.optionReferencePrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.optionReferencePrice.Name = "optionReferencePrice";
            this.optionReferencePrice.Size = new System.Drawing.Size(93, 24);
            this.optionReferencePrice.TabIndex = 11;
            // 
            // volatilityType
            // 
            this.volatilityType.FormattingEnabled = true;
            this.volatilityType.Location = new System.Drawing.Point(317, 12);
            this.volatilityType.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.volatilityType.Name = "volatilityType";
            this.volatilityType.Size = new System.Drawing.Size(93, 24);
            this.volatilityType.TabIndex = 10;
            // 
            // volatility
            // 
            this.volatility.Location = new System.Drawing.Point(215, 12);
            this.volatility.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.volatility.Name = "volatility";
            this.volatility.Size = new System.Drawing.Size(93, 22);
            this.volatility.TabIndex = 9;
            // 
            // continuousUpdate
            // 
            this.continuousUpdate.AutoSize = true;
            this.continuousUpdate.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.continuousUpdate.Location = new System.Drawing.Point(36, 44);
            this.continuousUpdate.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.continuousUpdate.Name = "continuousUpdate";
            this.continuousUpdate.Size = new System.Drawing.Size(194, 21);
            this.continuousUpdate.TabIndex = 8;
            this.continuousUpdate.Text = "Continuously update price";
            this.continuousUpdate.UseVisualStyleBackColor = true;
            // 
            // stockRangeLowerLabel
            // 
            this.stockRangeLowerLabel.AutoSize = true;
            this.stockRangeLowerLabel.Location = new System.Drawing.Point(75, 239);
            this.stockRangeLowerLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.stockRangeLowerLabel.Name = "stockRangeLowerLabel";
            this.stockRangeLowerLabel.Size = new System.Drawing.Size(130, 17);
            this.stockRangeLowerLabel.TabIndex = 7;
            this.stockRangeLowerLabel.Text = "Stock range - lower";
            // 
            // sockRangeUpperLabel
            // 
            this.sockRangeUpperLabel.AutoSize = true;
            this.sockRangeUpperLabel.Location = new System.Drawing.Point(72, 207);
            this.sockRangeUpperLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.sockRangeUpperLabel.Name = "sockRangeUpperLabel";
            this.sockRangeUpperLabel.Size = new System.Drawing.Size(134, 17);
            this.sockRangeUpperLabel.TabIndex = 6;
            this.sockRangeUpperLabel.Text = "Stock range - upper";
            // 
            // hedgeContractConIdLabel
            // 
            this.hedgeContractConIdLabel.AutoSize = true;
            this.hedgeContractConIdLabel.Location = new System.Drawing.Point(77, 175);
            this.hedgeContractConIdLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.hedgeContractConIdLabel.Name = "hedgeContractConIdLabel";
            this.hedgeContractConIdLabel.Size = new System.Drawing.Size(127, 17);
            this.hedgeContractConIdLabel.TabIndex = 5;
            this.hedgeContractConIdLabel.Text = "Delta neutral conId";
            // 
            // hedgeOrderAuxPriceLabel
            // 
            this.hedgeOrderAuxPriceLabel.AutoSize = true;
            this.hedgeOrderAuxPriceLabel.Location = new System.Drawing.Point(56, 143);
            this.hedgeOrderAuxPriceLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.hedgeOrderAuxPriceLabel.Name = "hedgeOrderAuxPriceLabel";
            this.hedgeOrderAuxPriceLabel.Size = new System.Drawing.Size(150, 17);
            this.hedgeOrderAuxPriceLabel.TabIndex = 4;
            this.hedgeOrderAuxPriceLabel.Text = "Delta neutral aux price";
            // 
            // hedgeOrderTypeLabel
            // 
            this.hedgeOrderTypeLabel.AutoSize = true;
            this.hedgeOrderTypeLabel.Location = new System.Drawing.Point(51, 110);
            this.hedgeOrderTypeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.hedgeOrderTypeLabel.Name = "hedgeOrderTypeLabel";
            this.hedgeOrderTypeLabel.Size = new System.Drawing.Size(158, 17);
            this.hedgeOrderTypeLabel.TabIndex = 3;
            this.hedgeOrderTypeLabel.Text = "Delta neutral order type";
            // 
            // optionReferencePriceLabel
            // 
            this.optionReferencePriceLabel.AutoSize = true;
            this.optionReferencePriceLabel.Location = new System.Drawing.Point(57, 76);
            this.optionReferencePriceLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.optionReferencePriceLabel.Name = "optionReferencePriceLabel";
            this.optionReferencePriceLabel.Size = new System.Drawing.Size(150, 17);
            this.optionReferencePriceLabel.TabIndex = 2;
            this.optionReferencePriceLabel.Text = "Option reference price";
            // 
            // volatilityLabel
            // 
            this.volatilityLabel.AutoSize = true;
            this.volatilityLabel.Location = new System.Drawing.Point(147, 16);
            this.volatilityLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.volatilityLabel.Name = "volatilityLabel";
            this.volatilityLabel.Size = new System.Drawing.Size(60, 17);
            this.volatilityLabel.TabIndex = 0;
            this.volatilityLabel.Text = "Volatility";
            // 
            // scaleTab
            // 
            this.scaleTab.BackColor = System.Drawing.Color.LightGray;
            this.scaleTab.Controls.Add(this.priceAdjustInterval);
            this.scaleTab.Controls.Add(this.priceAdjustValue);
            this.scaleTab.Controls.Add(this.initialFillQuantity);
            this.scaleTab.Controls.Add(this.initialPosition);
            this.scaleTab.Controls.Add(this.priceIncrement);
            this.scaleTab.Controls.Add(this.profitOffset);
            this.scaleTab.Controls.Add(this.subsequentLevelSize);
            this.scaleTab.Controls.Add(this.initialLevelSize);
            this.scaleTab.Controls.Add(this.autoReset);
            this.scaleTab.Controls.Add(this.randomiseSize);
            this.scaleTab.Controls.Add(this.secondsLabel);
            this.scaleTab.Controls.Add(this.initialPositionLabel);
            this.scaleTab.Controls.Add(this.initialFillQuantityLabel);
            this.scaleTab.Controls.Add(this.everyLabel);
            this.scaleTab.Controls.Add(this.priceAdjustValueLabel);
            this.scaleTab.Controls.Add(this.subsequentLevelSizeLabel);
            this.scaleTab.Controls.Add(this.profitOffsetLabel);
            this.scaleTab.Controls.Add(this.priceIncrementLabel);
            this.scaleTab.Controls.Add(this.initialLevelSizeLabel);
            this.scaleTab.Location = new System.Drawing.Point(4, 25);
            this.scaleTab.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.scaleTab.Name = "scaleTab";
            this.scaleTab.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.scaleTab.Size = new System.Drawing.Size(836, 418);
            this.scaleTab.TabIndex = 4;
            this.scaleTab.Text = "Scale";
            // 
            // priceAdjustInterval
            // 
            this.priceAdjustInterval.Location = new System.Drawing.Point(325, 263);
            this.priceAdjustInterval.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.priceAdjustInterval.Name = "priceAdjustInterval";
            this.priceAdjustInterval.Size = new System.Drawing.Size(92, 22);
            this.priceAdjustInterval.TabIndex = 18;
            // 
            // priceAdjustValue
            // 
            this.priceAdjustValue.Location = new System.Drawing.Point(172, 263);
            this.priceAdjustValue.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.priceAdjustValue.Name = "priceAdjustValue";
            this.priceAdjustValue.Size = new System.Drawing.Size(92, 22);
            this.priceAdjustValue.TabIndex = 17;
            // 
            // initialFillQuantity
            // 
            this.initialFillQuantity.Location = new System.Drawing.Point(172, 231);
            this.initialFillQuantity.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.initialFillQuantity.Name = "initialFillQuantity";
            this.initialFillQuantity.Size = new System.Drawing.Size(92, 22);
            this.initialFillQuantity.TabIndex = 16;
            // 
            // initialPosition
            // 
            this.initialPosition.Location = new System.Drawing.Point(172, 199);
            this.initialPosition.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.initialPosition.Name = "initialPosition";
            this.initialPosition.Size = new System.Drawing.Size(92, 22);
            this.initialPosition.TabIndex = 15;
            // 
            // priceIncrement
            // 
            this.priceIncrement.Location = new System.Drawing.Point(172, 107);
            this.priceIncrement.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.priceIncrement.Name = "priceIncrement";
            this.priceIncrement.Size = new System.Drawing.Size(92, 22);
            this.priceIncrement.TabIndex = 14;
            // 
            // profitOffset
            // 
            this.profitOffset.Location = new System.Drawing.Point(172, 139);
            this.profitOffset.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.profitOffset.Name = "profitOffset";
            this.profitOffset.Size = new System.Drawing.Size(92, 22);
            this.profitOffset.TabIndex = 13;
            // 
            // subsequentLevelSize
            // 
            this.subsequentLevelSize.Location = new System.Drawing.Point(172, 47);
            this.subsequentLevelSize.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.subsequentLevelSize.Name = "subsequentLevelSize";
            this.subsequentLevelSize.Size = new System.Drawing.Size(92, 22);
            this.subsequentLevelSize.TabIndex = 12;
            // 
            // initialLevelSize
            // 
            this.initialLevelSize.Location = new System.Drawing.Point(172, 15);
            this.initialLevelSize.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.initialLevelSize.Name = "initialLevelSize";
            this.initialLevelSize.Size = new System.Drawing.Size(92, 22);
            this.initialLevelSize.TabIndex = 11;
            // 
            // autoReset
            // 
            this.autoReset.AutoSize = true;
            this.autoReset.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.autoReset.Location = new System.Drawing.Point(91, 171);
            this.autoReset.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.autoReset.Name = "autoReset";
            this.autoReset.Size = new System.Drawing.Size(96, 21);
            this.autoReset.TabIndex = 10;
            this.autoReset.Text = "Auto-reset";
            this.autoReset.UseVisualStyleBackColor = true;
            // 
            // randomiseSize
            // 
            this.randomiseSize.AutoSize = true;
            this.randomiseSize.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.randomiseSize.Location = new System.Drawing.Point(56, 79);
            this.randomiseSize.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.randomiseSize.Name = "randomiseSize";
            this.randomiseSize.Size = new System.Drawing.Size(130, 21);
            this.randomiseSize.TabIndex = 9;
            this.randomiseSize.Text = "Randomise size";
            this.randomiseSize.UseVisualStyleBackColor = true;
            // 
            // secondsLabel
            // 
            this.secondsLabel.AutoSize = true;
            this.secondsLabel.Location = new System.Drawing.Point(427, 267);
            this.secondsLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.secondsLabel.Name = "secondsLabel";
            this.secondsLabel.Size = new System.Drawing.Size(61, 17);
            this.secondsLabel.TabIndex = 8;
            this.secondsLabel.Text = "seconds";
            // 
            // initialPositionLabel
            // 
            this.initialPositionLabel.AutoSize = true;
            this.initialPositionLabel.Location = new System.Drawing.Point(71, 203);
            this.initialPositionLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.initialPositionLabel.Name = "initialPositionLabel";
            this.initialPositionLabel.Size = new System.Drawing.Size(93, 17);
            this.initialPositionLabel.TabIndex = 7;
            this.initialPositionLabel.Text = "Initial position";
            // 
            // initialFillQuantityLabel
            // 
            this.initialFillQuantityLabel.AutoSize = true;
            this.initialFillQuantityLabel.Location = new System.Drawing.Point(53, 235);
            this.initialFillQuantityLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.initialFillQuantityLabel.Name = "initialFillQuantityLabel";
            this.initialFillQuantityLabel.Size = new System.Drawing.Size(111, 17);
            this.initialFillQuantityLabel.TabIndex = 6;
            this.initialFillQuantityLabel.Text = "Initial fill quantity";
            // 
            // everyLabel
            // 
            this.everyLabel.AutoSize = true;
            this.everyLabel.Location = new System.Drawing.Point(273, 267);
            this.everyLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.everyLabel.Name = "everyLabel";
            this.everyLabel.Size = new System.Drawing.Size(43, 17);
            this.everyLabel.TabIndex = 5;
            this.everyLabel.Text = "every";
            // 
            // priceAdjustValueLabel
            // 
            this.priceAdjustValueLabel.AutoSize = true;
            this.priceAdjustValueLabel.Location = new System.Drawing.Point(43, 267);
            this.priceAdjustValueLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.priceAdjustValueLabel.Name = "priceAdjustValueLabel";
            this.priceAdjustValueLabel.Size = new System.Drawing.Size(120, 17);
            this.priceAdjustValueLabel.TabIndex = 4;
            this.priceAdjustValueLabel.Text = "Price adjust value";
            // 
            // subsequentLevelSizeLabel
            // 
            this.subsequentLevelSizeLabel.AutoSize = true;
            this.subsequentLevelSizeLabel.Location = new System.Drawing.Point(17, 50);
            this.subsequentLevelSizeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.subsequentLevelSizeLabel.Name = "subsequentLevelSizeLabel";
            this.subsequentLevelSizeLabel.Size = new System.Drawing.Size(146, 17);
            this.subsequentLevelSizeLabel.TabIndex = 3;
            this.subsequentLevelSizeLabel.Text = "Subsequent level size";
            // 
            // profitOffsetLabel
            // 
            this.profitOffsetLabel.AutoSize = true;
            this.profitOffsetLabel.Location = new System.Drawing.Point(81, 143);
            this.profitOffsetLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.profitOffsetLabel.Name = "profitOffsetLabel";
            this.profitOffsetLabel.Size = new System.Drawing.Size(83, 17);
            this.profitOffsetLabel.TabIndex = 2;
            this.profitOffsetLabel.Text = "Profit Offset";
            // 
            // priceIncrementLabel
            // 
            this.priceIncrementLabel.AutoSize = true;
            this.priceIncrementLabel.Location = new System.Drawing.Point(57, 111);
            this.priceIncrementLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.priceIncrementLabel.Name = "priceIncrementLabel";
            this.priceIncrementLabel.Size = new System.Drawing.Size(106, 17);
            this.priceIncrementLabel.TabIndex = 1;
            this.priceIncrementLabel.Text = "Price increment";
            // 
            // initialLevelSizeLabel
            // 
            this.initialLevelSizeLabel.AutoSize = true;
            this.initialLevelSizeLabel.Location = new System.Drawing.Point(61, 23);
            this.initialLevelSizeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.initialLevelSizeLabel.Name = "initialLevelSizeLabel";
            this.initialLevelSizeLabel.Size = new System.Drawing.Size(102, 17);
            this.initialLevelSizeLabel.TabIndex = 0;
            this.initialLevelSizeLabel.Text = "Initial level size";
            // 
            // algoTab
            // 
            this.algoTab.BackColor = System.Drawing.Color.LightGray;
            this.algoTab.Controls.Add(this.useOddLots);
            this.algoTab.Controls.Add(this.noTradeAhead);
            this.algoTab.Controls.Add(this.getDone);
            this.algoTab.Controls.Add(this.displaySizeAlgo);
            this.algoTab.Controls.Add(this.forceCompletion);
            this.algoTab.Controls.Add(this.riskAversion);
            this.algoTab.Controls.Add(this.noTakeLiq);
            this.algoTab.Controls.Add(this.strategyType);
            this.algoTab.Controls.Add(this.pctVol);
            this.algoTab.Controls.Add(this.maxPctVol);
            this.algoTab.Controls.Add(this.allowPastEndTime);
            this.algoTab.Controls.Add(this.endTime);
            this.algoTab.Controls.Add(this.startTime);
            this.algoTab.Controls.Add(this.useOddLotsLabel);
            this.algoTab.Controls.Add(this.noTradeAheadLabel);
            this.algoTab.Controls.Add(this.getDoneLabel);
            this.algoTab.Controls.Add(this.displaySizeAlgoLabel);
            this.algoTab.Controls.Add(this.forceCompletionLabel);
            this.algoTab.Controls.Add(this.riskAversionLabel);
            this.algoTab.Controls.Add(this.noTakeLiqLabel);
            this.algoTab.Controls.Add(this.strategyTypeLabel);
            this.algoTab.Controls.Add(this.pctVolLabel);
            this.algoTab.Controls.Add(this.maxPctVolLabel);
            this.algoTab.Controls.Add(this.allowPastEndTimeLabel);
            this.algoTab.Controls.Add(this.endTimeLabel);
            this.algoTab.Controls.Add(this.startTimeLabel);
            this.algoTab.Controls.Add(this.algoStrategy);
            this.algoTab.Controls.Add(this.algoStrategyLabel);
            this.algoTab.Location = new System.Drawing.Point(4, 25);
            this.algoTab.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.algoTab.Name = "algoTab";
            this.algoTab.Padding = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.algoTab.Size = new System.Drawing.Size(836, 418);
            this.algoTab.TabIndex = 5;
            this.algoTab.Text = "IB Algo";
            // 
            // useOddLots
            // 
            this.useOddLots.Enabled = false;
            this.useOddLots.Location = new System.Drawing.Point(429, 215);
            this.useOddLots.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.useOddLots.Name = "useOddLots";
            this.useOddLots.Size = new System.Drawing.Size(92, 22);
            this.useOddLots.TabIndex = 27;
            // 
            // noTradeAhead
            // 
            this.noTradeAhead.Enabled = false;
            this.noTradeAhead.Location = new System.Drawing.Point(429, 183);
            this.noTradeAhead.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.noTradeAhead.Name = "noTradeAhead";
            this.noTradeAhead.Size = new System.Drawing.Size(92, 22);
            this.noTradeAhead.TabIndex = 26;
            // 
            // getDone
            // 
            this.getDone.Enabled = false;
            this.getDone.Location = new System.Drawing.Point(429, 151);
            this.getDone.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.getDone.Name = "getDone";
            this.getDone.Size = new System.Drawing.Size(92, 22);
            this.getDone.TabIndex = 25;
            // 
            // displaySizeAlgo
            // 
            this.displaySizeAlgo.Enabled = false;
            this.displaySizeAlgo.Location = new System.Drawing.Point(429, 119);
            this.displaySizeAlgo.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.displaySizeAlgo.Name = "displaySizeAlgo";
            this.displaySizeAlgo.Size = new System.Drawing.Size(92, 22);
            this.displaySizeAlgo.TabIndex = 24;
            // 
            // forceCompletion
            // 
            this.forceCompletion.Enabled = false;
            this.forceCompletion.Location = new System.Drawing.Point(429, 87);
            this.forceCompletion.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.forceCompletion.Name = "forceCompletion";
            this.forceCompletion.Size = new System.Drawing.Size(92, 22);
            this.forceCompletion.TabIndex = 23;
            // 
            // riskAversion
            // 
            this.riskAversion.Enabled = false;
            this.riskAversion.Location = new System.Drawing.Point(429, 55);
            this.riskAversion.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.riskAversion.Name = "riskAversion";
            this.riskAversion.Size = new System.Drawing.Size(92, 22);
            this.riskAversion.TabIndex = 22;
            // 
            // noTakeLiq
            // 
            this.noTakeLiq.Enabled = false;
            this.noTakeLiq.Location = new System.Drawing.Point(429, 23);
            this.noTakeLiq.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.noTakeLiq.Name = "noTakeLiq";
            this.noTakeLiq.Size = new System.Drawing.Size(92, 22);
            this.noTakeLiq.TabIndex = 21;
            // 
            // strategyType
            // 
            this.strategyType.Enabled = false;
            this.strategyType.Location = new System.Drawing.Point(167, 215);
            this.strategyType.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.strategyType.Name = "strategyType";
            this.strategyType.Size = new System.Drawing.Size(92, 22);
            this.strategyType.TabIndex = 20;
            // 
            // pctVol
            // 
            this.pctVol.Enabled = false;
            this.pctVol.Location = new System.Drawing.Point(167, 183);
            this.pctVol.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.pctVol.Name = "pctVol";
            this.pctVol.Size = new System.Drawing.Size(92, 22);
            this.pctVol.TabIndex = 19;
            // 
            // maxPctVol
            // 
            this.maxPctVol.Enabled = false;
            this.maxPctVol.Location = new System.Drawing.Point(167, 151);
            this.maxPctVol.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.maxPctVol.Name = "maxPctVol";
            this.maxPctVol.Size = new System.Drawing.Size(92, 22);
            this.maxPctVol.TabIndex = 18;
            // 
            // allowPastEndTime
            // 
            this.allowPastEndTime.Enabled = false;
            this.allowPastEndTime.Location = new System.Drawing.Point(167, 119);
            this.allowPastEndTime.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.allowPastEndTime.Name = "allowPastEndTime";
            this.allowPastEndTime.Size = new System.Drawing.Size(92, 22);
            this.allowPastEndTime.TabIndex = 17;
            // 
            // endTime
            // 
            this.endTime.Enabled = false;
            this.endTime.Location = new System.Drawing.Point(167, 87);
            this.endTime.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.endTime.Name = "endTime";
            this.endTime.Size = new System.Drawing.Size(92, 22);
            this.endTime.TabIndex = 16;
            // 
            // startTime
            // 
            this.startTime.Enabled = false;
            this.startTime.Location = new System.Drawing.Point(167, 55);
            this.startTime.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.startTime.Name = "startTime";
            this.startTime.Size = new System.Drawing.Size(92, 22);
            this.startTime.TabIndex = 15;
            // 
            // useOddLotsLabel
            // 
            this.useOddLotsLabel.AutoSize = true;
            this.useOddLotsLabel.Location = new System.Drawing.Point(333, 215);
            this.useOddLotsLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.useOddLotsLabel.Name = "useOddLotsLabel";
            this.useOddLotsLabel.Size = new System.Drawing.Size(87, 17);
            this.useOddLotsLabel.TabIndex = 14;
            this.useOddLotsLabel.Text = "Use odd lots";
            // 
            // noTradeAheadLabel
            // 
            this.noTradeAheadLabel.AutoSize = true;
            this.noTradeAheadLabel.Location = new System.Drawing.Point(313, 183);
            this.noTradeAheadLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.noTradeAheadLabel.Name = "noTradeAheadLabel";
            this.noTradeAheadLabel.Size = new System.Drawing.Size(107, 17);
            this.noTradeAheadLabel.TabIndex = 13;
            this.noTradeAheadLabel.Text = "No trade ahead";
            // 
            // getDoneLabel
            // 
            this.getDoneLabel.AutoSize = true;
            this.getDoneLabel.Location = new System.Drawing.Point(353, 151);
            this.getDoneLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.getDoneLabel.Name = "getDoneLabel";
            this.getDoneLabel.Size = new System.Drawing.Size(67, 17);
            this.getDoneLabel.TabIndex = 12;
            this.getDoneLabel.Text = "Get done";
            // 
            // displaySizeAlgoLabel
            // 
            this.displaySizeAlgoLabel.AutoSize = true;
            this.displaySizeAlgoLabel.Location = new System.Drawing.Point(339, 119);
            this.displaySizeAlgoLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.displaySizeAlgoLabel.Name = "displaySizeAlgoLabel";
            this.displaySizeAlgoLabel.Size = new System.Drawing.Size(83, 17);
            this.displaySizeAlgoLabel.TabIndex = 11;
            this.displaySizeAlgoLabel.Text = "Display size";
            // 
            // forceCompletionLabel
            // 
            this.forceCompletionLabel.AutoSize = true;
            this.forceCompletionLabel.Location = new System.Drawing.Point(304, 87);
            this.forceCompletionLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.forceCompletionLabel.Name = "forceCompletionLabel";
            this.forceCompletionLabel.Size = new System.Drawing.Size(116, 17);
            this.forceCompletionLabel.TabIndex = 10;
            this.forceCompletionLabel.Text = "Force completion";
            // 
            // riskAversionLabel
            // 
            this.riskAversionLabel.AutoSize = true;
            this.riskAversionLabel.Location = new System.Drawing.Point(327, 55);
            this.riskAversionLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.riskAversionLabel.Name = "riskAversionLabel";
            this.riskAversionLabel.Size = new System.Drawing.Size(93, 17);
            this.riskAversionLabel.TabIndex = 9;
            this.riskAversionLabel.Text = "Risk aversion";
            // 
            // noTakeLiqLabel
            // 
            this.noTakeLiqLabel.AutoSize = true;
            this.noTakeLiqLabel.Location = new System.Drawing.Point(340, 22);
            this.noTakeLiqLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.noTakeLiqLabel.Name = "noTakeLiqLabel";
            this.noTakeLiqLabel.Size = new System.Drawing.Size(79, 17);
            this.noTakeLiqLabel.TabIndex = 8;
            this.noTakeLiqLabel.Text = "No take liq.";
            // 
            // strategyTypeLabel
            // 
            this.strategyTypeLabel.AutoSize = true;
            this.strategyTypeLabel.Location = new System.Drawing.Point(48, 215);
            this.strategyTypeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.strategyTypeLabel.Name = "strategyTypeLabel";
            this.strategyTypeLabel.Size = new System.Drawing.Size(92, 17);
            this.strategyTypeLabel.TabIndex = 7;
            this.strategyTypeLabel.Text = "Strategy type";
            // 
            // pctVolLabel
            // 
            this.pctVolLabel.AutoSize = true;
            this.pctVolLabel.Location = new System.Drawing.Point(79, 183);
            this.pctVolLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.pctVolLabel.Name = "pctVolLabel";
            this.pctVolLabel.Size = new System.Drawing.Size(58, 17);
            this.pctVolLabel.TabIndex = 6;
            this.pctVolLabel.Text = "Pct. vol.";
            // 
            // maxPctVolLabel
            // 
            this.maxPctVolLabel.AutoSize = true;
            this.maxPctVolLabel.Location = new System.Drawing.Point(47, 151);
            this.maxPctVolLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.maxPctVolLabel.Name = "maxPctVolLabel";
            this.maxPctVolLabel.Size = new System.Drawing.Size(89, 17);
            this.maxPctVolLabel.TabIndex = 5;
            this.maxPctVolLabel.Text = "Max Pct. Vol.";
            // 
            // allowPastEndTimeLabel
            // 
            this.allowPastEndTimeLabel.AutoSize = true;
            this.allowPastEndTimeLabel.Location = new System.Drawing.Point(9, 119);
            this.allowPastEndTimeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.allowPastEndTimeLabel.Name = "allowPastEndTimeLabel";
            this.allowPastEndTimeLabel.Size = new System.Drawing.Size(129, 17);
            this.allowPastEndTimeLabel.TabIndex = 4;
            this.allowPastEndTimeLabel.Text = "Allow past end time";
            // 
            // endTimeLabel
            // 
            this.endTimeLabel.AutoSize = true;
            this.endTimeLabel.Location = new System.Drawing.Point(76, 87);
            this.endTimeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.endTimeLabel.Name = "endTimeLabel";
            this.endTimeLabel.Size = new System.Drawing.Size(63, 17);
            this.endTimeLabel.TabIndex = 3;
            this.endTimeLabel.Text = "End time";
            // 
            // startTimeLabel
            // 
            this.startTimeLabel.AutoSize = true;
            this.startTimeLabel.Location = new System.Drawing.Point(72, 55);
            this.startTimeLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.startTimeLabel.Name = "startTimeLabel";
            this.startTimeLabel.Size = new System.Drawing.Size(68, 17);
            this.startTimeLabel.TabIndex = 2;
            this.startTimeLabel.Text = "Start time";
            // 
            // algoStrategy
            // 
            this.algoStrategy.FormattingEnabled = true;
            this.algoStrategy.Items.AddRange(new object[] {
            "None",
            "Vwap",
            "Twap",
            "ArrivalPx",
            "DarkIce",
            "PctVol"});
            this.algoStrategy.Location = new System.Drawing.Point(167, 22);
            this.algoStrategy.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.algoStrategy.Name = "algoStrategy";
            this.algoStrategy.Size = new System.Drawing.Size(92, 24);
            this.algoStrategy.TabIndex = 1;
            this.algoStrategy.Text = "None";
            this.algoStrategy.SelectedIndexChanged += new System.EventHandler(this.AlgoStrategy_SelectedIndexChanged);
            // 
            // algoStrategyLabel
            // 
            this.algoStrategyLabel.AutoSize = true;
            this.algoStrategyLabel.Location = new System.Drawing.Point(49, 22);
            this.algoStrategyLabel.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.algoStrategyLabel.Name = "algoStrategyLabel";
            this.algoStrategyLabel.Size = new System.Drawing.Size(91, 17);
            this.algoStrategyLabel.TabIndex = 0;
            this.algoStrategyLabel.Text = "Algo strategy";
            // 
            // peg2benchTab
            // 
            this.peg2benchTab.BackColor = System.Drawing.Color.LightGray;
            this.peg2benchTab.Controls.Add(this.pgdStockRangeLower);
            this.peg2benchTab.Controls.Add(this.pgdStockRangeUpper);
            this.peg2benchTab.Controls.Add(this.label20);
            this.peg2benchTab.Controls.Add(this.label21);
            this.peg2benchTab.Controls.Add(this.cbPeggedChangeType);
            this.peg2benchTab.Controls.Add(this.tbReferenceChangeAmount);
            this.peg2benchTab.Controls.Add(this.tbPeggedChangeAmount);
            this.peg2benchTab.Controls.Add(this.tbStartingReferencePrice);
            this.peg2benchTab.Controls.Add(this.label10);
            this.peg2benchTab.Controls.Add(this.label9);
            this.peg2benchTab.Controls.Add(this.label8);
            this.peg2benchTab.Controls.Add(this.label7);
            this.peg2benchTab.Controls.Add(this.label6);
            this.peg2benchTab.Controls.Add(this.tbStartingPrice);
            this.peg2benchTab.Controls.Add(this.label4);
            this.peg2benchTab.Location = new System.Drawing.Point(4, 25);
            this.peg2benchTab.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.peg2benchTab.Name = "peg2benchTab";
            this.peg2benchTab.Size = new System.Drawing.Size(836, 418);
            this.peg2benchTab.TabIndex = 6;
            this.peg2benchTab.Text = "Pegged to Benchmark";
            // 
            // pgdStockRangeLower
            // 
            this.pgdStockRangeLower.Location = new System.Drawing.Point(199, 228);
            this.pgdStockRangeLower.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.pgdStockRangeLower.Name = "pgdStockRangeLower";
            this.pgdStockRangeLower.Size = new System.Drawing.Size(273, 22);
            this.pgdStockRangeLower.TabIndex = 20;
            // 
            // pgdStockRangeUpper
            // 
            this.pgdStockRangeUpper.Location = new System.Drawing.Point(199, 196);
            this.pgdStockRangeUpper.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.pgdStockRangeUpper.Name = "pgdStockRangeUpper";
            this.pgdStockRangeUpper.Size = new System.Drawing.Size(273, 22);
            this.pgdStockRangeUpper.TabIndex = 19;
            // 
            // label20
            // 
            this.label20.AutoSize = true;
            this.label20.Location = new System.Drawing.Point(9, 231);
            this.label20.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label20.Name = "label20";
            this.label20.Size = new System.Drawing.Size(130, 17);
            this.label20.TabIndex = 18;
            this.label20.Text = "Stock range - lower";
            // 
            // label21
            // 
            this.label21.AutoSize = true;
            this.label21.Location = new System.Drawing.Point(9, 199);
            this.label21.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label21.Name = "label21";
            this.label21.Size = new System.Drawing.Size(134, 17);
            this.label21.TabIndex = 17;
            this.label21.Text = "Stock range - upper";
            // 
            // cbPeggedChangeType
            // 
            this.cbPeggedChangeType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbPeggedChangeType.FormattingEnabled = true;
            this.cbPeggedChangeType.Items.AddRange(new object[] {
            "Increase",
            "Decrease"});
            this.cbPeggedChangeType.Location = new System.Drawing.Point(199, 132);
            this.cbPeggedChangeType.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.cbPeggedChangeType.Name = "cbPeggedChangeType";
            this.cbPeggedChangeType.Size = new System.Drawing.Size(276, 24);
            this.cbPeggedChangeType.TabIndex = 10;
            // 
            // tbReferenceChangeAmount
            // 
            this.tbReferenceChangeAmount.Location = new System.Drawing.Point(199, 164);
            this.tbReferenceChangeAmount.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbReferenceChangeAmount.Name = "tbReferenceChangeAmount";
            this.tbReferenceChangeAmount.Size = new System.Drawing.Size(276, 22);
            this.tbReferenceChangeAmount.TabIndex = 9;
            // 
            // tbPeggedChangeAmount
            // 
            this.tbPeggedChangeAmount.Location = new System.Drawing.Point(199, 100);
            this.tbPeggedChangeAmount.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbPeggedChangeAmount.Name = "tbPeggedChangeAmount";
            this.tbPeggedChangeAmount.Size = new System.Drawing.Size(276, 22);
            this.tbPeggedChangeAmount.TabIndex = 8;
            // 
            // tbStartingReferencePrice
            // 
            this.tbStartingReferencePrice.Location = new System.Drawing.Point(199, 68);
            this.tbStartingReferencePrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbStartingReferencePrice.Name = "tbStartingReferencePrice";
            this.tbStartingReferencePrice.Size = new System.Drawing.Size(276, 22);
            this.tbStartingReferencePrice.TabIndex = 7;
            // 
            // label10
            // 
            this.label10.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(9, 167);
            this.label10.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(176, 17);
            this.label10.TabIndex = 6;
            this.label10.Text = "Reference change amount";
            // 
            // label9
            // 
            this.label9.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(9, 135);
            this.label9.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(139, 17);
            this.label9.TabIndex = 5;
            this.label9.Text = "Pegged change type";
            // 
            // label8
            // 
            this.label8.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(9, 103);
            this.label8.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(159, 17);
            this.label8.TabIndex = 4;
            this.label8.Text = "Pegged change amount";
            // 
            // label7
            // 
            this.label7.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(9, 71);
            this.label7.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(157, 17);
            this.label7.TabIndex = 3;
            this.label7.Text = "Starting reference price";
            // 
            // label6
            // 
            this.label6.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(9, 39);
            this.label6.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(129, 17);
            this.label6.TabIndex = 2;
            this.label6.Text = "Reference contract";
            // 
            // tbStartingPrice
            // 
            this.tbStartingPrice.Location = new System.Drawing.Point(199, 4);
            this.tbStartingPrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbStartingPrice.Name = "tbStartingPrice";
            this.tbStartingPrice.Size = new System.Drawing.Size(276, 22);
            this.tbStartingPrice.TabIndex = 1;
            // 
            // label4
            // 
            this.label4.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(9, 7);
            this.label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(92, 17);
            this.label4.TabIndex = 0;
            this.label4.Text = "Starting price";
            // 
            // adjustStopTab
            // 
            this.adjustStopTab.BackColor = System.Drawing.Color.LightGray;
            this.adjustStopTab.Controls.Add(this.label16);
            this.adjustStopTab.Controls.Add(this.cbAdjustedTrailingAmntUnit);
            this.adjustStopTab.Controls.Add(this.tbAdjustedTrailingAmnt);
            this.adjustStopTab.Controls.Add(this.label15);
            this.adjustStopTab.Controls.Add(this.tbAdjustedStopLimitPrice);
            this.adjustStopTab.Controls.Add(this.label14);
            this.adjustStopTab.Controls.Add(this.tbAdjustedStopPrice);
            this.adjustStopTab.Controls.Add(this.label13);
            this.adjustStopTab.Controls.Add(this.tbTriggerPrice);
            this.adjustStopTab.Controls.Add(this.label12);
            this.adjustStopTab.Controls.Add(this.cbAdjustedOrderType);
            this.adjustStopTab.Controls.Add(this.label11);
            this.adjustStopTab.Location = new System.Drawing.Point(4, 25);
            this.adjustStopTab.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.adjustStopTab.Name = "adjustStopTab";
            this.adjustStopTab.Size = new System.Drawing.Size(836, 418);
            this.adjustStopTab.TabIndex = 7;
            this.adjustStopTab.Text = "Adjustable stops";
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Location = new System.Drawing.Point(19, 169);
            this.label16.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(187, 17);
            this.label16.TabIndex = 11;
            this.label16.Text = "Adjusted trailing amount unit";
            // 
            // cbAdjustedTrailingAmntUnit
            // 
            this.cbAdjustedTrailingAmntUnit.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbAdjustedTrailingAmntUnit.FormattingEnabled = true;
            this.cbAdjustedTrailingAmntUnit.Items.AddRange(new object[] {
            "amonunt",
            "%"});
            this.cbAdjustedTrailingAmntUnit.Location = new System.Drawing.Point(217, 165);
            this.cbAdjustedTrailingAmntUnit.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.cbAdjustedTrailingAmntUnit.Name = "cbAdjustedTrailingAmntUnit";
            this.cbAdjustedTrailingAmntUnit.Size = new System.Drawing.Size(160, 24);
            this.cbAdjustedTrailingAmntUnit.TabIndex = 7;
            // 
            // tbAdjustedTrailingAmnt
            // 
            this.tbAdjustedTrailingAmnt.Location = new System.Drawing.Point(217, 133);
            this.tbAdjustedTrailingAmnt.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbAdjustedTrailingAmnt.Name = "tbAdjustedTrailingAmnt";
            this.tbAdjustedTrailingAmnt.Size = new System.Drawing.Size(160, 22);
            this.tbAdjustedTrailingAmnt.TabIndex = 6;
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Location = new System.Drawing.Point(19, 137);
            this.label15.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(160, 17);
            this.label15.TabIndex = 8;
            this.label15.Text = "Adjusted trailing amount";
            // 
            // tbAdjustedStopLimitPrice
            // 
            this.tbAdjustedStopLimitPrice.Location = new System.Drawing.Point(217, 101);
            this.tbAdjustedStopLimitPrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbAdjustedStopLimitPrice.Name = "tbAdjustedStopLimitPrice";
            this.tbAdjustedStopLimitPrice.Size = new System.Drawing.Size(160, 22);
            this.tbAdjustedStopLimitPrice.TabIndex = 5;
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(19, 105);
            this.label14.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(154, 17);
            this.label14.TabIndex = 6;
            this.label14.Text = "Adusted stop limit price";
            // 
            // tbAdjustedStopPrice
            // 
            this.tbAdjustedStopPrice.Location = new System.Drawing.Point(217, 69);
            this.tbAdjustedStopPrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbAdjustedStopPrice.Name = "tbAdjustedStopPrice";
            this.tbAdjustedStopPrice.Size = new System.Drawing.Size(160, 22);
            this.tbAdjustedStopPrice.TabIndex = 4;
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(19, 73);
            this.label13.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(129, 17);
            this.label13.TabIndex = 4;
            this.label13.Text = "Adjusted stop price";
            // 
            // tbTriggerPrice
            // 
            this.tbTriggerPrice.Location = new System.Drawing.Point(217, 37);
            this.tbTriggerPrice.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbTriggerPrice.Name = "tbTriggerPrice";
            this.tbTriggerPrice.Size = new System.Drawing.Size(160, 22);
            this.tbTriggerPrice.TabIndex = 3;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(19, 7);
            this.label12.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(132, 17);
            this.label12.TabIndex = 2;
            this.label12.Text = "Adjust to order type";
            // 
            // cbAdjustedOrderType
            // 
            this.cbAdjustedOrderType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbAdjustedOrderType.FormattingEnabled = true;
            this.cbAdjustedOrderType.Items.AddRange(new object[] {
            "",
            "STP",
            "STP LMT",
            "TRAIL",
            "TRAIL LIMIT"});
            this.cbAdjustedOrderType.Location = new System.Drawing.Point(217, 4);
            this.cbAdjustedOrderType.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.cbAdjustedOrderType.Name = "cbAdjustedOrderType";
            this.cbAdjustedOrderType.Size = new System.Drawing.Size(160, 24);
            this.cbAdjustedOrderType.TabIndex = 2;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(19, 41);
            this.label11.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(89, 17);
            this.label11.TabIndex = 0;
            this.label11.Text = "Trigger price";
            // 
            // tabPage1
            // 
            this.tabPage1.BackColor = System.Drawing.Color.LightGray;
            this.tabPage1.Controls.Add(this.ignoreRth);
            this.tabPage1.Controls.Add(this.cancelOrder);
            this.tabPage1.Controls.Add(this.conditionList);
            this.tabPage1.Controls.Add(this.lbAddCondition);
            this.tabPage1.Controls.Add(this.lbRemoveCondition);
            this.tabPage1.Location = new System.Drawing.Point(4, 25);
            this.tabPage1.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Size = new System.Drawing.Size(836, 418);
            this.tabPage1.TabIndex = 8;
            this.tabPage1.Text = "Conditions";
            // 
            // ignoreRth
            // 
            this.ignoreRth.AutoSize = true;
            this.ignoreRth.Location = new System.Drawing.Point(179, 361);
            this.ignoreRth.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.ignoreRth.Name = "ignoreRth";
            this.ignoreRth.Size = new System.Drawing.Size(537, 21);
            this.ignoreRth.TabIndex = 13;
            this.ignoreRth.Text = "Allow condition to be satisfied and activate order outside of regular trading hou" +
    "rs";
            this.ignoreRth.UseVisualStyleBackColor = true;
            // 
            // cancelOrder
            // 
            this.cancelOrder.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cancelOrder.FormattingEnabled = true;
            this.cancelOrder.Items.AddRange(new object[] {
            "Submit order",
            "Cancel order"});
            this.cancelOrder.Location = new System.Drawing.Point(9, 356);
            this.cancelOrder.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.cancelOrder.Name = "cancelOrder";
            this.cancelOrder.Size = new System.Drawing.Size(160, 24);
            this.cancelOrder.TabIndex = 4;
            // 
            // conditionList
            // 
            this.conditionList.AllowUserToAddRows = false;
            this.conditionList.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.conditionList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.conditionList.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Description,
            this.Logic});
            this.conditionList.Dock = System.Windows.Forms.DockStyle.Top;
            this.conditionList.Location = new System.Drawing.Point(0, 0);
            this.conditionList.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.conditionList.Name = "conditionList";
            this.conditionList.Size = new System.Drawing.Size(836, 348);
            this.conditionList.TabIndex = 3;
            this.conditionList.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.conditionList_CellDoubleClick);
            // 
            // Description
            // 
            this.Description.HeaderText = "Description";
            this.Description.Name = "Description";
            this.Description.ReadOnly = true;
            this.Description.Width = 106;
            // 
            // Logic
            // 
            this.Logic.HeaderText = "Logic";
            this.Logic.Items.AddRange(new object[] {
            "and",
            "or"});
            this.Logic.Name = "Logic";
            this.Logic.Width = 46;
            // 
            // lbAddCondition
            // 
            this.lbAddCondition.AutoSize = true;
            this.lbAddCondition.Location = new System.Drawing.Point(723, 362);
            this.lbAddCondition.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbAddCondition.Name = "lbAddCondition";
            this.lbAddCondition.Size = new System.Drawing.Size(32, 17);
            this.lbAddCondition.TabIndex = 1;
            this.lbAddCondition.TabStop = true;
            this.lbAddCondition.Text = "add";
            this.lbAddCondition.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lbAddCondition_LinkClicked);
            // 
            // lbRemoveCondition
            // 
            this.lbRemoveCondition.AutoSize = true;
            this.lbRemoveCondition.Location = new System.Drawing.Point(764, 362);
            this.lbRemoveCondition.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lbRemoveCondition.Name = "lbRemoveCondition";
            this.lbRemoveCondition.Size = new System.Drawing.Size(55, 17);
            this.lbRemoveCondition.TabIndex = 2;
            this.lbRemoveCondition.TabStop = true;
            this.lbRemoveCondition.Text = "remove";
            this.lbRemoveCondition.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lbRemoveCondition_LinkClicked);
            // 
            // sendOrderButton
            // 
            this.sendOrderButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.sendOrderButton.Location = new System.Drawing.Point(14, 452);
            this.sendOrderButton.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.sendOrderButton.Name = "sendOrderButton";
            this.sendOrderButton.Size = new System.Drawing.Size(100, 28);
            this.sendOrderButton.TabIndex = 0;
            this.sendOrderButton.Text = "Send";
            this.sendOrderButton.UseVisualStyleBackColor = true;
            this.sendOrderButton.Click += new System.EventHandler(this.sendOrderButton_Click);
            // 
            // textBox6
            // 
            this.textBox6.Location = new System.Drawing.Point(511, 231);
            this.textBox6.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.textBox6.Name = "textBox6";
            this.textBox6.Size = new System.Drawing.Size(92, 22);
            this.textBox6.TabIndex = 3;
            this.textBox6.Text = "WARNING!!!";
            // 
            // textBox7
            // 
            this.textBox7.Location = new System.Drawing.Point(511, 263);
            this.textBox7.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.textBox7.Name = "textBox7";
            this.textBox7.Size = new System.Drawing.Size(92, 22);
            this.textBox7.TabIndex = 4;
            this.textBox7.Text = "WARNING!!!";
            // 
            // textBox8
            // 
            this.textBox8.Location = new System.Drawing.Point(511, 295);
            this.textBox8.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.textBox8.Name = "textBox8";
            this.textBox8.Size = new System.Drawing.Size(92, 22);
            this.textBox8.TabIndex = 5;
            this.textBox8.Text = "WARNING!!!";
            // 
            // checkMarginButton
            // 
            this.checkMarginButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.checkMarginButton.Location = new System.Drawing.Point(122, 456);
            this.checkMarginButton.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.checkMarginButton.Name = "checkMarginButton";
            this.checkMarginButton.Size = new System.Drawing.Size(116, 28);
            this.checkMarginButton.TabIndex = 1;
            this.checkMarginButton.Text = "Check Margin";
            this.checkMarginButton.UseVisualStyleBackColor = true;
            this.checkMarginButton.Click += new System.EventHandler(this.checkMarginButton_Click);
            // 
            // closeOrderDialogButton
            // 
            this.closeOrderDialogButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.closeOrderDialogButton.Location = new System.Drawing.Point(741, 456);
            this.closeOrderDialogButton.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.closeOrderDialogButton.Name = "closeOrderDialogButton";
            this.closeOrderDialogButton.Size = new System.Drawing.Size(100, 28);
            this.closeOrderDialogButton.TabIndex = 2;
            this.closeOrderDialogButton.Text = "Close";
            this.closeOrderDialogButton.UseVisualStyleBackColor = true;
            this.closeOrderDialogButton.Click += new System.EventHandler(this.closeOrderDialogButton_Click);
            // 
            // contractSearchControl1
            // 
            this.contractSearchControl1.Contract = null;
            this.contractSearchControl1.IBClient = null;
            this.contractSearchControl1.Location = new System.Drawing.Point(149, 32);
            this.contractSearchControl1.Name = "contractSearchControl1";
            this.contractSearchControl1.Size = new System.Drawing.Size(206, 13);
            this.contractSearchControl1.TabIndex = 0;
            // 
            // B_SaveOrder
            // 
            this.B_SaveOrder.Location = new System.Drawing.Point(246, 456);
            this.B_SaveOrder.Name = "B_SaveOrder";
            this.B_SaveOrder.Size = new System.Drawing.Size(75, 23);
            this.B_SaveOrder.TabIndex = 6;
            this.B_SaveOrder.Text = "Save";
            this.B_SaveOrder.UseVisualStyleBackColor = true;
            this.B_SaveOrder.Click += new System.EventHandler(this.B_SaveOrder_Click);
            // 
            // OrderDialog
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(861, 524);
            this.ControlBox = false;
            this.Controls.Add(this.B_SaveOrder);
            this.Controls.Add(this.closeOrderDialogButton);
            this.Controls.Add(this.checkMarginButton);
            this.Controls.Add(this.sendOrderButton);
            this.Controls.Add(this.conditionsTab);
            this.Controls.Add(this.textBox6);
            this.Controls.Add(this.textBox8);
            this.Controls.Add(this.textBox7);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.Name = "OrderDialog";
            this.Text = "Order";
            this.conditionsTab.ResumeLayout(false);
            this.orderContractTab.ResumeLayout(false);
            this.baseGroup.ResumeLayout(false);
            this.baseGroup.PerformLayout();
            this.contractGroup.ResumeLayout(false);
            this.contractGroup.PerformLayout();
            this.extendedOrderTab.ResumeLayout(false);
            this.extendedOrderTab.PerformLayout();
            this.advisorTab.ResumeLayout(false);
            this.advisorTab.PerformLayout();
            this.volatilityTab.ResumeLayout(false);
            this.volatilityTab.PerformLayout();
            this.scaleTab.ResumeLayout(false);
            this.scaleTab.PerformLayout();
            this.algoTab.ResumeLayout(false);
            this.algoTab.PerformLayout();
            this.peg2benchTab.ResumeLayout(false);
            this.peg2benchTab.PerformLayout();
            this.adjustStopTab.ResumeLayout(false);
            this.adjustStopTab.PerformLayout();
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.conditionList)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        
        private System.Windows.Forms.TabControl conditionsTab;
        private System.Windows.Forms.TabPage orderContractTab;
        private System.Windows.Forms.TabPage extendedOrderTab;
        private System.Windows.Forms.Button sendOrderButton;

        private System.Windows.Forms.ComboBox contractSecType;
        private System.Windows.Forms.TextBox contractLastTradeDateOrContractMonth;
        private System.Windows.Forms.TextBox contractStrike;
        private System.Windows.Forms.ComboBox contractRight;
        private System.Windows.Forms.TextBox contractMultiplier;
        private System.Windows.Forms.TextBox contractExchange;
        private System.Windows.Forms.TextBox contractCurrency;
        private System.Windows.Forms.TextBox contractLocalSymbol;        
        private System.Windows.Forms.GroupBox contractGroup;
        private System.Windows.Forms.GroupBox baseGroup;
        private System.Windows.Forms.TextBox contractSymbol;
        private System.Windows.Forms.TextBox orderReference;        
        private System.Windows.Forms.CheckBox firmQuote;
        private System.Windows.Forms.CheckBox eTrade;
        private System.Windows.Forms.CheckBox overrideConstraints;
        private System.Windows.Forms.CheckBox allOrNone;
        private System.Windows.Forms.CheckBox outsideRTH;
        private System.Windows.Forms.CheckBox hidden;
        private System.Windows.Forms.CheckBox sweepToFill;
        private System.Windows.Forms.CheckBox block;
        private System.Windows.Forms.CheckBox notHeld;
        private System.Windows.Forms.TextBox hedgeParam;
        private System.Windows.Forms.TextBox trailStopPrice;
        private System.Windows.Forms.TextBox percentOffset;
        private System.Windows.Forms.ComboBox hedgeType;
        private System.Windows.Forms.ComboBox triggerMethod;
        private System.Windows.Forms.ComboBox rule80A;
        private System.Windows.Forms.ComboBox ocaType;
        private System.Windows.Forms.TextBox goodUntil;
        private System.Windows.Forms.TextBox ocaGroup;
        private System.Windows.Forms.TextBox goodAfter;
        private System.Windows.Forms.TextBox minQty;
        private System.Windows.Forms.TextBox textBox6;
        private System.Windows.Forms.TextBox textBox7;
        private System.Windows.Forms.TextBox textBox8;
        private System.Windows.Forms.CheckBox transmit;
        private System.Windows.Forms.CheckBox optOutSmart;
        private System.Windows.Forms.TextBox nbboPriceCap;
        private System.Windows.Forms.TextBox discretionaryAmount;
        private System.Windows.Forms.TextBox trailingPercent;

        private System.Windows.Forms.Label orderSymbolLabel;
        private System.Windows.Forms.Label orderSecTypeLabel;
        private System.Windows.Forms.Label orderLastTradeDateOrContractMonthLabel;
        private System.Windows.Forms.Label orderStrikeLabel;
        private System.Windows.Forms.Label orderRightLabel;
        private System.Windows.Forms.Label orderMultiplierLabel;
        private System.Windows.Forms.Label orderExchangeLabel;
        private System.Windows.Forms.Label orderCurrencyLabel;
        private System.Windows.Forms.Label orderLocalSymbol;
        private System.Windows.Forms.Label tiggerMethodLabel;
        private System.Windows.Forms.Label rule80ALabel;
        private System.Windows.Forms.Label goodUntilLabel;
        private System.Windows.Forms.Label goodAfterLabel;
        private System.Windows.Forms.Label orderMinQtyLabel;
        private System.Windows.Forms.Label orderRefLabel;
        private System.Windows.Forms.Label percentOffsetLabel;        
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label nbboPriceCapLabel;
        private System.Windows.Forms.Label trailingPercentLabel;
        private System.Windows.Forms.Label accountLabel;
        private System.Windows.Forms.Label limitPriceLabel;
        private System.Windows.Forms.Label orderTypeLabel;
        private System.Windows.Forms.Label displaySizeLabel;
        private System.Windows.Forms.Label quantityLabel;
        private System.Windows.Forms.Label actionLabel;
        private System.Windows.Forms.Label auxPriceLabel;
        private System.Windows.Forms.ComboBox account;
        private System.Windows.Forms.Label timeInForceLabel;
        private System.Windows.Forms.ComboBox orderType;
        private System.Windows.Forms.TextBox displaySize;
        private System.Windows.Forms.TextBox quantity;
        private System.Windows.Forms.ComboBox action;
        private System.Windows.Forms.ComboBox timeInForce;
        private System.Windows.Forms.TextBox auxPrice;
        private System.Windows.Forms.TextBox lmtPrice;
        private System.Windows.Forms.TabPage advisorTab;
        private System.Windows.Forms.Label groupLabel;
        private System.Windows.Forms.Label profileLabel;
        private System.Windows.Forms.Label orLabel;
        private System.Windows.Forms.Label percentageLabel;
        private System.Windows.Forms.Label methodLabel;
        private System.Windows.Forms.TextBox faGroup;
        private System.Windows.Forms.ComboBox faMethod;
        private System.Windows.Forms.TextBox faProfile;
        private System.Windows.Forms.TextBox faPercentage;
        private System.Windows.Forms.TabPage volatilityTab;
        private System.Windows.Forms.TabPage scaleTab;
        private System.Windows.Forms.TabPage algoTab;
        private System.Windows.Forms.Label stockRangeLowerLabel;
        private System.Windows.Forms.Label sockRangeUpperLabel;
        private System.Windows.Forms.Label hedgeContractConIdLabel;
        private System.Windows.Forms.Label hedgeOrderAuxPriceLabel;
        private System.Windows.Forms.Label hedgeOrderTypeLabel;
        private System.Windows.Forms.Label optionReferencePriceLabel;
        private System.Windows.Forms.Label volatilityLabel;
        private System.Windows.Forms.CheckBox continuousUpdate;
        private System.Windows.Forms.TextBox stockRangeLower;
        private System.Windows.Forms.TextBox stockRangeUpper;
        private System.Windows.Forms.TextBox deltaNeutralConId;
        private System.Windows.Forms.TextBox deltaNeutralAuxPrice;
        private System.Windows.Forms.ComboBox deltaNeutralOrderType;
        private System.Windows.Forms.ComboBox optionReferencePrice;
        private System.Windows.Forms.ComboBox volatilityType;
        private System.Windows.Forms.TextBox volatility;
        private System.Windows.Forms.Label secondsLabel;
        private System.Windows.Forms.Label initialPositionLabel;
        private System.Windows.Forms.Label initialFillQuantityLabel;
        private System.Windows.Forms.Label everyLabel;
        private System.Windows.Forms.Label priceAdjustValueLabel;
        private System.Windows.Forms.Label subsequentLevelSizeLabel;
        private System.Windows.Forms.Label profitOffsetLabel;
        private System.Windows.Forms.Label priceIncrementLabel;
        private System.Windows.Forms.Label initialLevelSizeLabel;
        private System.Windows.Forms.CheckBox autoReset;
        private System.Windows.Forms.CheckBox randomiseSize;
        private System.Windows.Forms.TextBox initialLevelSize;
        private System.Windows.Forms.TextBox priceAdjustInterval;
        private System.Windows.Forms.TextBox priceAdjustValue;
        private System.Windows.Forms.TextBox initialFillQuantity;
        private System.Windows.Forms.TextBox initialPosition;
        private System.Windows.Forms.TextBox priceIncrement;
        private System.Windows.Forms.TextBox profitOffset;
        private System.Windows.Forms.TextBox subsequentLevelSize;
        private System.Windows.Forms.Label algoStrategyLabel;
        private System.Windows.Forms.ComboBox algoStrategy;
        private System.Windows.Forms.Label useOddLotsLabel;
        private System.Windows.Forms.Label noTradeAheadLabel;
        private System.Windows.Forms.Label getDoneLabel;
        private System.Windows.Forms.Label displaySizeAlgoLabel;
        private System.Windows.Forms.Label forceCompletionLabel;
        private System.Windows.Forms.Label riskAversionLabel;
        private System.Windows.Forms.Label noTakeLiqLabel;
        private System.Windows.Forms.Label strategyTypeLabel;
        private System.Windows.Forms.Label pctVolLabel;
        private System.Windows.Forms.Label maxPctVolLabel;
        private System.Windows.Forms.Label allowPastEndTimeLabel;
        private System.Windows.Forms.Label endTimeLabel;
        private System.Windows.Forms.Label startTimeLabel;
        private System.Windows.Forms.TextBox useOddLots;
        private System.Windows.Forms.TextBox noTradeAhead;
        private System.Windows.Forms.TextBox getDone;
        private System.Windows.Forms.TextBox displaySizeAlgo;
        private System.Windows.Forms.TextBox forceCompletion;
        private System.Windows.Forms.TextBox riskAversion;
        private System.Windows.Forms.TextBox noTakeLiq;
        private System.Windows.Forms.TextBox strategyType;
        private System.Windows.Forms.TextBox pctVol;
        private System.Windows.Forms.TextBox maxPctVol;
        private System.Windows.Forms.TextBox allowPastEndTime;
        private System.Windows.Forms.TextBox endTime;
        private System.Windows.Forms.TextBox startTime;
        private System.Windows.Forms.Button checkMarginButton;
        private System.Windows.Forms.Button closeOrderDialogButton;
        private System.Windows.Forms.Label orderPrimExchLabel;
        private System.Windows.Forms.TextBox contractPrimaryExch;
        private System.Windows.Forms.TabPage peg2benchTab;
        private System.Windows.Forms.TextBox tbReferenceChangeAmount;
        private System.Windows.Forms.TextBox tbPeggedChangeAmount;
        private System.Windows.Forms.TextBox tbStartingReferencePrice;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox tbStartingPrice;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox cbPeggedChangeType;
        private System.Windows.Forms.TabPage adjustStopTab;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.ComboBox cbAdjustedTrailingAmntUnit;
        private System.Windows.Forms.TextBox tbAdjustedTrailingAmnt;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.TextBox tbAdjustedStopLimitPrice;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.TextBox tbAdjustedStopPrice;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.TextBox tbTriggerPrice;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.ComboBox cbAdjustedOrderType;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.LinkLabel lbAddCondition;
        private System.Windows.Forms.LinkLabel lbRemoveCondition;
        private ui.ContractSearchControl contractSearchControl1;
        private System.Windows.Forms.DataGridView conditionList;
        private System.Windows.Forms.DataGridViewTextBoxColumn Description;
        private System.Windows.Forms.DataGridViewComboBoxColumn Logic;
        private System.Windows.Forms.ComboBox cancelOrder;
        private System.Windows.Forms.CheckBox ignoreRth;
        private System.Windows.Forms.TextBox pgdStockRangeLower;
        private System.Windows.Forms.TextBox pgdStockRangeUpper;
        private System.Windows.Forms.Label label20;
        private System.Windows.Forms.Label label21;
        private System.Windows.Forms.TextBox modelCode;
        private System.Windows.Forms.Label modelCodeLabel;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.ComboBox softDollarTier;
        private System.Windows.Forms.TextBox cashQty;
        private System.Windows.Forms.Label cashQtyLabel;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.TextBox mifid2DecisionAlgo;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.TextBox mifid2DecisionMaker;
        private System.Windows.Forms.Label label22;
        private System.Windows.Forms.TextBox mifid2ExecutionAlgo;
        private System.Windows.Forms.Label label23;
        private System.Windows.Forms.TextBox mifid2ExecutionTrader;
        private System.Windows.Forms.CheckBox dontUseAutoPriceForHedge;
        private System.Windows.Forms.CheckBox omsContainer;
        private System.Windows.Forms.CheckBox relativeDiscretionary;
        private System.Windows.Forms.Label label24;
        private System.Windows.Forms.CheckBox usePriceMgmtAlgo;
        private System.Windows.Forms.Button B_SaveOrder;
    }
}