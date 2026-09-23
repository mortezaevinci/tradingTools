using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MHA;
using IBApi;
using IBSampleApp.ui;
using IBSampleApp.messages;
using IBSampleApp.types;
using System.Windows.Forms.DataVisualization.Charting;
using System.Drawing.Drawing2D;
using System.Threading;
using System.Linq.Expressions;
using System.IO;
using System.Reflection.Emit;

namespace IBSampleApp
{
    partial class FormOrderWatchlist : Form
    {
        double[] lasts_underlying;
        double[] bids_contract;
        double[] asks_contract;
        double[] asks_underlying;
        double[] bids_underlying;


        Semaphore processgetticks = new Semaphore(1, 1);
        // Contract genericEquityContract = new Contract();
        int watchlistindex = 0;
        System.Windows.Forms.Label[] lspreads_contract;
        System.Windows.Forms.Label[] lbids_contract;
        System.Windows.Forms.Label[] lasks_contract;
        System.Windows.Forms.Label[] llasts_underlying;
        System.Windows.Forms.Label[] lspreads_underlying;
        CheckBox[] lapplycond;
        Button[] bgenround;
        Button[] bbidaskqs;
        Button[] bstpentryqs;
        Button[] blastqs;
        Button[] bticks;
        System.Windows.Forms.Label[] lpos;


        System.Windows.Forms.TextBox[] bstops;
        System.Windows.Forms.TextBox[] btargets;

        System.Windows.Forms.TextBox[] blmts;
        System.Windows.Forms.TextBox[] bauxs;
        System.Windows.Forms.Button[] bsx2;

        System.Windows.Forms.TextBox[] bsymbols;
        System.Windows.Forms.Label[] lsymbols;
        System.Windows.Forms.TextBox[] btypes;
        System.Windows.Forms.TextBox[] bexpiries;
        System.Windows.Forms.TextBox[] bstrikes;
        System.Windows.Forms.TextBox[] brights;
        System.Windows.Forms.TextBox[] blocalsymbols;
        System.Windows.Forms.TextBox[] bqtys;
        System.Windows.Forms.Label[,] borders;
        System.Windows.Forms.Button[,] bconds;
        System.Windows.Forms.Panel[] bpanels;

        private int maxConditions = 8;
        private int maxContracts = 45;
       
        IBControlDefinition IBCD=null;

        private OrderManager orderManager;
        private MarketDataManager marketDataManager;
        private IBClient ibClient;
        public FormOrderWatchlist(IBClient ibclientin, OrderManager ordermanagerin, MarketDataManager marketDataManagerin)
        {
            InitializeComponent();

            this.orderManager = ordermanagerin;
            this.marketDataManager = marketDataManagerin;
            this.ibClient = ibclientin;
        }

       public async void fillIBCD()
        {
            List<ContractDefinition> cds = IBCD.orderWatchlists[watchlistindex].contractDefinitions;
            int nc = cds.Count;
            for (int i=0;i<nc;i++)
            {
                if (cds[i].underlying.ConId == 0)
                {
                    Contract c = cds[i].contract;
                    List<Contract> contracts = new List<Contract>();
                    contracts.AddRange(await ibClient.ResolveContractAsync("STK", c.Symbol, c.Currency, c.Exchange));
                    Thread.Sleep(1000);
                    if (contracts.Count > 0)
                    {
                        cds[i].underlying.ConId = contracts[0].ConId;
                        cds[i].underlying.Exchange = contracts[0].Exchange;
                    }
                }
            }
        }

        private void FormOrderWatchlist_Load(object sender, EventArgs e)
        {

           

        }

        /*
        public void fillLabel(System.Windows.Forms.Label l, TickPriceMessage dataMessage)
        {
            switch (dataMessage.Field)
            {

                case TickType.BID:
                case TickType.DELAYED_BID:
                    {
                        l.Text = dataMessage.Price.ToString();
                        break;
                    }
                case TickType.ASK:
                case TickType.DELAYED_ASK:
                    {
                        //ASK, DELAYED_ASK
                        l.Text = dataMessage.Price.ToString();
                        break;
                    }
                case TickType.LAST:
                case TickType.DELAYED_LAST:
                    {
                        //LAST, DELAYED_LAST
                        l.Text = dataMessage.Price.ToString();
                        break;
                    }
                    
                case TickType.CLOSE:
                case TickType.DELAYED_CLOSE:
                    {
                        //CLOSE, DELAYED_CLOSE
                        grid[CLOSE_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                        break;
                    }
                case TickType.OPEN:
                case TickType.DELAYED_OPEN:
                    {
                        //OPEN, DELAYED_OPEN
                        grid[OPEN_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                        break;
                    }
               
                case TickType.HIGH:
                case TickType.DELAYED_HIGH:
                    {
                        //HIGH, DELAYED_HIGH
                        grid[HIGH_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                        break;
                    }
                case TickType.LOW:
                case TickType.DELAYED_LOW:
                    {
                        //LOW, DELAYED_LOW
                        grid[LOW_PRICE_INDEX, GetIndex(dataMessage.RequestId)].Value = dataMessage.Price;
                        break;
                    }
                    
            }
        }
*/

        public void evaluateMarketData(TickPriceMessage dataMessage)
        {
            if (IBCD == null) return;

            int nContracts = IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count();

            for (int r = 0; r < 2; r++) //rerun one more time so that spread can be calculated at once
            {

                for (int n = 0; n < nContracts; n++)
                {
                    try
                    {
                        if ((int)lbids_contract[n].Tag == dataMessage.RequestId)

                        {
                            switch (dataMessage.Field)
                            {

                                case TickType.BID:
                                case TickType.DELAYED_BID:
                                    {
                                        lbids_contract[n].Text = dataMessage.Price.ToString();
                                        bids_contract[n] = dataMessage.Price;
                                        try
                                        {
                                            double ask = asks_contract[n];// Double.Parse(lasks_contract[n].Text);
                                            lspreads_contract[n].Text = String.Format("{0:0.0}%", ((ask - dataMessage.Price) * 200 / (ask + dataMessage.Price)));
                                        }
                                        catch (Exception ex)
                                        { Console.WriteLine(ex.Message); }
                                        break;
                                    }
                                case TickType.ASK:
                                case TickType.DELAYED_ASK:
                                    {
                                        //ASK, DELAYED_ASK
                                        lasks_contract[n].Text = dataMessage.Price.ToString();
                                        asks_contract[n] = dataMessage.Price;
                                        try
                                        {
                                            double bid = bids_contract[n];// Double.Parse(lbids_contract[n].Text);
                                            lspreads_contract[n].Text = String.Format("{0:0.0}%", ((dataMessage.Price - bid) * 200 / (bid + dataMessage.Price)));
                                        }
                                        catch (Exception ex)
                                        { Console.WriteLine(ex.Message); }
                                        break;
                                    }

                            }
                        }

                        if ((int)llasts_underlying[n].Tag == dataMessage.RequestId)

                        {
                            switch (dataMessage.Field)
                            {

                                case TickType.LAST:
                                case TickType.DELAYED_LAST:
                                    {
                                        //LAST, DELAYED_LAST
                                        lasts_underlying[n] = dataMessage.Price;
                                        llasts_underlying[n].Text = dataMessage.Price.ToString();
                                        break;
                                    }

                            }
                        }

                        if ((int)lspreads_underlying[n].Tag == dataMessage.RequestId)

                        {
                            switch (dataMessage.Field)
                            {

                                case TickType.BID:
                                case TickType.DELAYED_BID:
                                    {
                                        try
                                        {
                                            bids_underlying[n] = dataMessage.Price;

                                            double ask = asks_underlying[n];// Double.Parse(lasks_contract[n].Text);
                                            lspreads_underlying[n].Text = String.Format("{0:0.0}", ((ask - dataMessage.Price)));
                                        }
                                        catch (Exception ex)
                                        { Console.WriteLine(ex.Message); }
                                        break;
                                    }
                                case TickType.ASK:
                                case TickType.DELAYED_ASK:
                                    {
                                        //ASK, DELAYED_ASK

                                        asks_underlying[n] = dataMessage.Price;
                                        try
                                        {
                                            double bid = bids_underlying[n];// Double.Parse(lbids_contract[n].Text);
                                            lspreads_underlying[n].Text = String.Format("{0:0.0}", ((dataMessage.Price - bid)));
                                        }
                                        catch (Exception ex)
                                        { Console.WriteLine(ex.Message); }
                                        break;
                                    }

                            }


                        }
                    }
                    catch (Exception ex)
                    {
                        Console.Write("err:{0}", ex.Message);
                    }




                }
            }
        }

        private void asyncGenTicksForOptions()
        {
            Thread t1 = new Thread(genTicksForOptions);
            t1.Start();
        }

        private void genTicksForContracts(int n)
        {
            Contract c = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract;
            int reqid = marketDataManager.AddRequestExternal(c, "");

            //it is rightfully assumed that there is no need for a repeated purchaseable instrument

            lbids_contract[n].Tag = reqid;
            lasks_contract[n].Tag = reqid;
            lspreads_contract[n].Tag = reqid;
        }

        private void genTicksForOptions()
        {


            int nContracts = IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count();
            for (int n = 0; n < nContracts; n++)
            {
                try
                {
                    processgetticks.WaitOne();
                    Thread.Sleep(100);
                    genTicksForContracts(n);

                    processgetticks.Release();

                }
                catch{ }
            }
        }

        private void asyncGenTicksForUnderlying()
        {
            Thread t1 = new Thread(genTicksForUnderlying);
            t1.Start();
        }

        private void genTicksForUnderlying (int n)
        {
            Contract c = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract;
            Contract cstk = ContractDefinition.Tools.getGenericContract(c.Symbol);


            if (marketDataManager.uniquesymbolreqids.ContainsKey(ContractDefinition.Tools.uniqueKey(cstk)))
            {
                int mappedReqId = marketDataManager.uniquesymbolreqids[ContractDefinition.Tools.uniqueKey(cstk)];
                llasts_underlying[n].Tag = mappedReqId;
                lspreads_underlying[n].Tag = mappedReqId;
            }
            else
            {
                
               
                int reqid = marketDataManager.AddRequestExternal(cstk, "");
                int mappedReqId = marketDataManager.uniquesymbolreqids[ContractDefinition.Tools.uniqueKey(cstk)];
                llasts_underlying[n].Tag = mappedReqId;
                lspreads_underlying[n].Tag = mappedReqId;
                if (mappedReqId!=reqid)
                {
                    Console.WriteLine("WARNING:regid={0} while mappedReqId={1}", reqid, mappedReqId);
                }
            }
        }


        private void genTicksForUnderlying()
        {
            int nContracts = IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count();
            for (int contractindex = 0; contractindex < nContracts; contractindex++)
            {
                try
                {
                    processgetticks.WaitOne();
                    Thread.Sleep(250);
                    genTicksForUnderlying(contractindex);
                    processgetticks.Release();
                }
                catch { }
            }
        }

        private async void setbconds(int n,List<OperatorCondition> ccs,ContractDefinition cd)
        {
            Contract c = cd.contract;
            if (ccs.Count > 0)
            {
                int w = LCOND.Width / ccs.Count;
                for (int j = 0; j < ccs.Count; j++)
                {
                    //bconds[j, n] = new System.Windows.Forms.Button();
                    if (ccs[j].Type == OrderConditionType.Price)
                    {
                        bconds[j, n].Text = "P";

                        PriceCondition pc = ccs[j] as PriceCondition;

                        if (pc.ConId == 0)
                        {
                            if (cd.underlying.ConId>0)
                            {
                                pc.ConId = cd.underlying.ConId;

                            }
                            else
                            {
                                List<Contract> contracts = new List<Contract>();
                                contracts.AddRange(await ibClient.ResolveContractAsync("STK", c.Symbol, c.Currency, c.Exchange));
                                Thread.Sleep(1000);
                                if (contracts.Count > 0)
                                {
                                    pc.ConId = contracts[0].ConId;
                                }
                            }
                        }
                    }
                    else if (ccs[j].Type == OrderConditionType.Time)
                    {
                        string t_old = (ccs[j] as TimeCondition).Time;
                        DateTime dtnow = DateTime.Now;
                        string dnew = dtnow.ToString("yyyyMMdd");
                        t_old = String.Concat(dnew, t_old.Substring(8));
                        (ccs[j] as TimeCondition).Time = t_old;
                        bconds[j, n].Text = "T";
                    }
                    else
                    {
                        bconds[j, n].Text = ".";
                    }

                    bconds[j, n].Width = w;
                    bconds[j, n].Left = LCOND.Left + w * j;
                    bconds[j, n].Visible = true;
                }
            }
            else
            {

            }
        }

        private void AddButtons(IBControlDefinition od)
        {

            IBControlDefinition.OrderWatchlist ow = od.orderWatchlists[watchlistindex];

            int nMadeContracts = ow.contractDefinitions.Count();
            maxContracts = Math.Max(maxContracts, nMadeContracts + 4);
            int nContracts = maxContracts;// have extra; ow.contractDefinitions.Count();
            int nOrders = ow.orderDefinitions.Count();
            int yPos = 40;
            int baseh = 15;

            int buttonWidth = 65;


            bids_contract=new double[maxContracts];
            asks_contract = new double[maxContracts];
            asks_underlying = new double[maxContracts];
            bids_underlying = new double[maxContracts];
            lasts_underlying = new double[maxContracts];

            bgenround = new Button[nContracts];
            bbidaskqs = new Button[nContracts];
            bstpentryqs = new Button[nContracts];
            blastqs = new Button[nContracts];
            bticks = new Button[nContracts];

            // Declare and assign number of buttons = 26 
            lbids_contract = new System.Windows.Forms.Label[nContracts];
            lasks_contract = new System.Windows.Forms.Label[nContracts];
            lspreads_contract = new System.Windows.Forms.Label[nContracts];
            llasts_underlying = new System.Windows.Forms.Label[nContracts];
            lspreads_underlying = new System.Windows.Forms.Label[nContracts];

            lpos = new System.Windows.Forms.Label[nContracts];

            lsymbols = new System.Windows.Forms.Label[nContracts];
            bsymbols = new System.Windows.Forms.TextBox[nContracts];
            btypes = new System.Windows.Forms.TextBox[nContracts];
            bexpiries = new System.Windows.Forms.TextBox[nContracts];
            bstrikes = new System.Windows.Forms.TextBox[nContracts];

            bstops = new TextBox[nContracts];

            bauxs = new TextBox[nContracts];
            blmts = new TextBox[nContracts];
           

            btargets = new TextBox[nContracts];

            bsx2 = new System.Windows.Forms.Button[nContracts];


            brights = new System.Windows.Forms.TextBox[nContracts];
            blocalsymbols = new System.Windows.Forms.TextBox[nContracts];
            bqtys = new System.Windows.Forms.TextBox[nContracts];
            borders = new System.Windows.Forms.Label[nOrders, nContracts];
            bconds = new Button[maxConditions, nContracts];
            lapplycond = new CheckBox[nContracts];
            bpanels = new Panel[nContracts];

            // Create (26) Buttons: 
            for (int i = 0; i < nContracts; i++)
            {
                // Initialize one variable 
                bgenround[i] = new Button();
                bbidaskqs[i] = new Button();
                bstpentryqs[i] = new Button();
                blastqs[i] = new Button();
                bticks[i] = new Button();
                lasks_contract[i] = new System.Windows.Forms.Label();
                lbids_contract[i] = new System.Windows.Forms.Label();
                lspreads_contract[i] = new System.Windows.Forms.Label();
                llasts_underlying[i] = new System.Windows.Forms.Label();
                lspreads_underlying[i] = new System.Windows.Forms.Label();

                lpos[i] = new System.Windows.Forms.Label();

                bstops[i] = new TextBox();
                btargets[i] = new TextBox();

                blmts[i] = new TextBox();
                bauxs[i] = new TextBox();

                lsymbols[i] = new System.Windows.Forms.Label();
                bsymbols[i] = new System.Windows.Forms.TextBox();
                btypes[i] = new System.Windows.Forms.TextBox();
                bexpiries[i] = new System.Windows.Forms.TextBox();
                bstrikes[i] = new System.Windows.Forms.TextBox();
                brights[i] = new System.Windows.Forms.TextBox();
                blocalsymbols[i] = new System.Windows.Forms.TextBox();
                bqtys[i] = new System.Windows.Forms.TextBox();
                lapplycond[i] = new CheckBox();
                bpanels[i] = new Panel();

                for (int j = 0; j < nOrders; j++)
                {
                    borders[j, i] = new System.Windows.Forms.Label();
                }

                
                for (int j = 0; j < maxConditions; j++)
                {
                    bconds[j, i] = new System.Windows.Forms.Button();

                    bconds[j, i].FlatStyle = FlatStyle.System;
                    
                    bconds[j, i].Top = 0;

                    bconds[j, i].Tag = String.Format("{0},{1}", j, i); // Tag of button 
                    bconds[j, i].Height = baseh; // Height of button 
                    bconds[j, i].Visible = false;
                    bpanels[i].Controls.Add(bconds[j, i]);

                    // the Event of click Button 
                    bconds[j, i].Click += new System.EventHandler(ClickConditionButton);

                }


            }

            for (int n = 0; n < nContracts; n++)
            {
                llasts_underlying[n].Tag = -1;
                lspreads_underlying[n].Tag = -1;
                lpos[n].Tag = n;
                



                bpanels[n].Left = 0;
                bpanels[n].Height = baseh;
                bpanels[n].Width = this.Width;
                bpanels[n].Top = yPos;

                this.Controls.Add(bpanels[n]);




                if (n < ow.contractDefinitions.Count())
                {
                    Thread.Sleep(25);



                    Contract c = ow.contractDefinitions[n].contract;

                    lsymbols[n].Text = c.Symbol;
                    bsymbols[n].Text = c.Symbol;
                    btypes[n].Text = c.SecType;
                    bexpiries[n].Text = c.LastTradeDateOrContractMonth;
                    bstrikes[n].Text = c.Strike.ToString();

                    btargets[n].Text = ow.contractDefinitions[n].auxOrderInfo.bracketTarget.ToString();
                    if (ow.contractDefinitions[n].auxOrderInfo.bracketTarget > 40000 && c.Strike > 0)
                    {
                        btargets[n].Text=  c.Strike.ToString();
                    }
                    bstops[n].Text = ow.contractDefinitions[n].auxOrderInfo.brackerStop.ToString();

                    blmts[n].Text = ow.contractDefinitions[n].auxOrderInfo.parentLmt.ToString();
                    bauxs[n].Text = ow.contractDefinitions[n].auxOrderInfo.parentAux.ToString();


                    bqtys[n].Text = ow.contractDefinitions[n].auxOrderInfo.qty.ToString();

                    lapplycond[n].Checked = ow.contractDefinitions[n].auxOrderInfo.applyConditions;

                    brights[n].Text = c.Right;
                    blocalsymbols[n].Text = c.LocalSymbol;

                    if (ow.contractDefinitions[n].contract.Right.Contains("C"))
                    {
                        bpanels[n].BackColor = Color.LightGreen;
                    }
                    else
                    {
                        bpanels[n].BackColor = Color.LightPink;
                    }

                    if (String.IsNullOrEmpty(blocalsymbols[n].Text))
                    {
                        string localsystem = ow.contractDefinitions[n].generatedLocalSysmbol;
                        blocalsymbols[n].Text = localsystem;
                    }

                    List<OperatorCondition> ccs = ow.contractDefinitions[n].conditions;
                    setbconds(n, ccs,ow.contractDefinitions[n]);
                }

                lspreads_contract[n].Tag = 0;
                lbids_contract[n].Tag = 0;
                lasks_contract[n].Tag = 0;

                bgenround[n].Text = ">";
                bgenround[n].Width = baseh;
                bgenround[n].Left = ballround.Left;
                bgenround[n].Tag = n;
                bgenround[n].Click += new System.EventHandler(bgenround_clicked);

                bbidaskqs[n].Text = "Q";
                bbidaskqs[n].Width = baseh;
                bbidaskqs[n].Left = bBidAskQ.Left;
                bbidaskqs[n].Tag = n;
                bbidaskqs[n].Click += new System.EventHandler(bbidaskqs_clicked);

                bstpentryqs[n].Text = "Q";
                bstpentryqs[n].Width = baseh;
                bstpentryqs[n].Left = bStpEntryQ.Left;
                bstpentryqs[n].Tag = n;
                bstpentryqs[n].Click += new System.EventHandler(bstpentryqs_clicked);

                blastqs[n].Text = "Q";
                blastqs[n].Width = baseh;
                blastqs[n].Left = bStpEntryQ.Left;
                blastqs[n].Tag = n;
                blastqs[n].Click += new System.EventHandler(blastqs_clicked);


                bticks[n].Text = "T";
                bticks[n].Width = baseh;
                bticks[n].Left = bManageTicks.Left;
                bticks[n].Tag = n;
                bticks[n].Click += new System.EventHandler(bticks_clicked);

                llasts_underlying[n].Top = 0;
                llasts_underlying[n].Left = LLAST.Left;
                llasts_underlying[n].AutoSize = true;

                lspreads_underlying[n].Text = "0";
                lspreads_underlying[n].Top = 0;
                lspreads_underlying[n].Left = LSPREAD_UNDERLYING.Left;
                lspreads_underlying[n].AutoSize = true;

                lpos[n].Top = 0;
                lpos[n].Left = LPOS.Left;
                lpos[n].AutoSize = true;
                lpos[n].Text = "0";
                lpos[n].ForeColor = Color.LightGray;


                lspreads_contract[n].Top = 0;
                lspreads_contract[n].Left = LSPREAD.Left;
                lspreads_contract[n].Text = "0";
                lspreads_contract[n].AutoSize = true;

                lbids_contract[n].Top = 0;
                lbids_contract[n].Left = LBID.Left;
                lbids_contract[n].Text = "0";
                lbids_contract[n].AutoSize = true;

                lasks_contract[n].Top = 0;
                lasks_contract[n].Left = LASK.Left;
                lasks_contract[n].Text = "0";
                lasks_contract[n].AutoSize = true;

                lsymbols[n].Width = LSYMBOLEND.Width;
                lsymbols[n].Left = LSYMBOLEND.Left;
                lsymbols[n].Top = 0;


                bsymbols[n].Tag = n;
                bsymbols[n].Width = LSYMBOL.Width; bsymbols[n].Height = LSYMBOL.Height;
                bsymbols[n].Left = LSYMBOL.Left;
                bsymbols[n].Top = 0;
                bsymbols[n].Leave += new System.EventHandler(this.bsymbols_TextChanged);

                btypes[n].Tag = n;
                btypes[n].Width = LTYPE.Width; btypes[n].Height = LTYPE.Height;
                btypes[n].Left = LTYPE.Left;
                btypes[n].Top = 0;
                btypes[n].Leave += new System.EventHandler(this.btypes_TextChanged);

                bexpiries[n].Tag = n;
                bexpiries[n].Width = LEXPIRY.Width; bexpiries[n].Height = LEXPIRY.Height;
                bexpiries[n].Left = LEXPIRY.Left;
                bexpiries[n].Top = 0;
                bexpiries[n].Leave += new System.EventHandler(this.bexpiries_TextChanged);

                bstrikes[n].Tag = n;
                bstrikes[n].Width = LSTRIKE.Width; bstrikes[n].Height = LSTRIKE.Height;
                bstrikes[n].Left = LSTRIKE.Left;
                bstrikes[n].Top = 0;
                bstrikes[n].Leave += new System.EventHandler(this.bstrikes_TextChanged);

                brights[n].Tag = n;
                brights[n].Width = LRIGHT.Width; brights[n].Height = LRIGHT.Height;
                brights[n].Left = LRIGHT.Left;
                brights[n].Top = 0;
                brights[n].Leave += new System.EventHandler(this.brights_TextChanged);

                blocalsymbols[n].Tag = n;
                blocalsymbols[n].Width = LLOCALSYMBOL.Width; blocalsymbols[n].Height = LLOCALSYMBOL.Height;
                blocalsymbols[n].Left = LLOCALSYMBOL.Left;
                blocalsymbols[n].Top = 0;

                bstops[n].Tag = n;
                bstops[n].Width = L_STP.Width; 
                bstops[n].Height = L_STP.Height;
                bstops[n].Left = L_STP.Left;
                bstops[n].Top = 0;
                bstops[n].Leave += new System.EventHandler(this.bstops_TextChanged);
                bstops[n].KeyDown += new System.Windows.Forms.KeyEventHandler(this.TB_genericNumber_KeyDown);


                bauxs[n].Tag = n;
                bauxs[n].Width = LAUX.Width;
                bauxs[n].Height = LAUX.Height;
                bauxs[n].Left = LAUX.Left;
                bauxs[n].Top = 0;
                bauxs[n].Leave += new System.EventHandler(this.bauxs_TextChanged);
                bauxs[n].KeyDown += new System.Windows.Forms.KeyEventHandler(this.TB_genericNumber_KeyDown);

                blmts[n].Tag = n;
                blmts[n].Width = LLMT.Width;
                blmts[n].Height = LLMT.Height;
                blmts[n].Left = LLMT.Left;
                blmts[n].Top = 0;
                blmts[n].Leave += new System.EventHandler(this.blmts_TextChanged);
                blmts[n].KeyDown += new System.Windows.Forms.KeyEventHandler(this.TB_genericNumber_KeyDown);


                btargets[n].Tag = n;
                btargets[n].Width = L_TARGET.Width;
                btargets[n].Height = L_TARGET.Height;
                btargets[n].Left = L_TARGET.Left;
                btargets[n].Top = 0;
                btargets[n].Leave += new System.EventHandler(this.btargets_TextChanged);
                btargets[n].KeyDown += new System.Windows.Forms.KeyEventHandler(this.TB_genericNumber_KeyDown);



                blocalsymbols[n].Enter += new System.EventHandler(this.blocalsymbols_TextChanged);

                bqtys[n].Tag = n;
                bqtys[n].Width = LQTY.Width; bqtys[n].Height = LQTY.Height;
                bqtys[n].Left = LQTY.Left;
                bqtys[n].Top = 0;
             
                bqtys[n].Leave += new System.EventHandler(this.bqty_TextChanged);


                lapplycond[n].Tag = n;
                lapplycond[n].Left = LCONDAPPLY.Left;
                lapplycond[n].Text = "";
                lapplycond[n].Top = 0;
              //  lapplycond[n].Checked = true;
                lapplycond[n].AutoSize = true;
                lapplycond[n].CheckedChanged += new System.EventHandler(this.lapplycond_CheckedChanged);

                bpanels[n].Controls.Add(lapplycond[n]);

                bpanels[n].Controls.Add(llasts_underlying[n]);
                bpanels[n].Controls.Add(lspreads_underlying[n]);
                bpanels[n].Controls.Add(bgenround[n]);
                bpanels[n].Controls.Add(bbidaskqs[n]);
                bpanels[n].Controls.Add(bstpentryqs[n]);
                bpanels[n].Controls.Add(blastqs[n]);
                bpanels[n].Controls.Add(bticks[n]);

                bpanels[n].Controls.Add(lpos[n]);

                bpanels[n].Controls.Add(lspreads_contract[n]);
                bpanels[n].Controls.Add(lbids_contract[n]);
                bpanels[n].Controls.Add(lasks_contract[n]);

                bpanels[n].Controls.Add(lsymbols[n]);
                bpanels[n].Controls.Add(bsymbols[n]);
                bpanels[n].Controls.Add(btypes[n]);
                bpanels[n].Controls.Add(bexpiries[n]);
                bpanels[n].Controls.Add(bstrikes[n]);
                bpanels[n].Controls.Add(brights[n]);
                bpanels[n].Controls.Add(blocalsymbols[n]);
                bpanels[n].Controls.Add(bqtys[n]);

                bpanels[n].Controls.Add(bstops[n]);
                bpanels[n].Controls.Add(bauxs[n]);
                bpanels[n].Controls.Add(blmts[n]);
                bpanels[n].Controls.Add(btargets[n]);
               
                



                for (int j = 0; j < nOrders; j++)
                {
                    borders[j, n].BorderStyle = BorderStyle.FixedSingle;
                    borders[j, n].AutoSize = false;
                    borders[j, n].Margin = new Padding(0);
                    borders[j, n].Padding = new Padding(0);
                 
                    if (ow.orderDefinitions[j].order.Action.Contains("B"))
                    {
                        borders[j, n].ForeColor = Color.Green;

                    }
                    else
                    {
                        borders[j, n].ForeColor = Color.Red;
                    }

                  //  borders[j, n].FlatStyle = FlatStyle.System;
                    borders[j, n].Tag = String.Format("{0},{1}", j, n); // Tag of button 
                    borders[j, n].Width = buttonWidth; // Width of button 
                    borders[j, n].Height = baseh; // Height of button 

                    borders[j, n].Left = LORDERS.Left + buttonWidth * (j);
                    borders[j, n].Top = 0;
                    // Add buttons to a Panel: 

                    bpanels[n].Controls.Add(borders[j, n]);
                    borders[j, n].Text = ow.orderDefinitions[j].name;

                    // the Event of click Button 
                    borders[j, n].Click += new System.EventHandler(ClickOrderButton);
                    borders[j, n].MouseDown += new System.Windows.Forms.MouseEventHandler(borders_MouseDown);
                    borders[j, n].MouseUp += new System.Windows.Forms.MouseEventHandler(borders_MouseUp);

                }


                yPos += baseh+1;
            }

        }

        public void setNewStrike(int n)
        {

            try
            {
                double p = Double.Parse(llasts_underlying[n].Text);
                if (p > 0)
                {
                    string right = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract.Right;
                    bool upward = false;
                    if (right.Contains("C"))
                    {
                        upward = true;
                    }

                    double rlevel = 0;
                    if (p < 20)
                        rlevel = 0.5;
                    else if (p < 100)
                        rlevel = 1;
                    else if (p < 150)
                        rlevel = 2;
                    else if (p < 350)
                        rlevel = 5;
                    else if (p < 600)
                        rlevel = 10;
                    else if (p < 900)
                        rlevel = 20;
                    else
                        rlevel = 50;

                    if (upward)
                    {
                        p = Math.Floor(p / rlevel) * rlevel;
                    }
                    else

                    {
                        p = Math.Ceiling(p / rlevel) * rlevel;
                    }

                    bstrikes[n].Text = p.ToString();
                    strikeChanged(n);
                }


            }
            catch (Exception ex)
            { Console.WriteLine(ex.Message); }
        }

        public byte setBidAskQ(int n)
        {
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                double value = 0;

                double entry = Double.Parse(bauxs[n].Text);
                if (entry > 0)
                {
                    value = entry;
                }
                else
                {
                    if (asks_contract[n] <= 0)
                    {
                        return 1;
                    }
                    else
                    {
                        value = asks_contract[n];
                    }
                }

             
                try
                {
                    //use ask which is always bigger anyway
                    bqtys[n].Text = ((int)(Double.Parse(TB_AccountRisk.Text) / value)).ToString();
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].auxOrderInfo.qty = Int32.Parse(bqtys[n].Text);
                }
                catch { return 2; }
            }
            return 0;
        }

        public byte setLastQ(int n)
        {
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                if (lasts_underlying[n]==0)
                {
                    return 1;
                }
                try
                {
                    //use ask which is always bigger anyway
                    bqtys[n].Text = ((int)(Double.Parse(TB_AccountRisk.Text) / lasts_underlying[n])).ToString();
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].auxOrderInfo.qty = Int32.Parse(bqtys[n].Text);
                }
                catch { return 2; }
            }
            return 0;
        }

        public byte setStpEntryQ(int n)
        {
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                try
                {
                    double stp = Double.Parse(bstops[n].Text);
                    double entry = Double.Parse(bauxs[n].Text);
                    if ( stp==0 || entry==0)
                {
                   
                    return 1;
                }

                    //use ask which is always bigger anyway
                    int t1 = ((int)(Double.Parse(TB_AccountRisk.Text) / asks_contract[n]));
                    int t2 = ((int)(Double.Parse(TB_TradeRisk.Text) / Math.Abs(entry - stp)));
                    int t3 = Math.Min(t1, t2);
                    bqtys[n].Text = t3.ToString();
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].auxOrderInfo.qty = Int32.Parse(bqtys[n].Text);
                }
                catch { return 2; }
            }
            return 0;
        }
        public void bticks_clicked(Object sender, System.EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;

                int n = (int)btn.Tag;

                manageTicksForContracts(n);
                
            }
            catch (Exception ex)
            { Console.WriteLine(ex.Message); }
        }

        public void blastqs_clicked(Object sender, System.EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;

                int n = (int)btn.Tag;

                byte err = setLastQ(n);
                if (err == 1) MessageBox.Show("Bad last value.");
            }
            catch (Exception ex)
            { Console.WriteLine(ex.Message); }
        }

        public void bstpentryqs_clicked(Object sender, System.EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;

                int n = (int)btn.Tag;

                byte err=setStpEntryQ(n);
                if (err == 1) MessageBox.Show("Bad stop/entry values.");
            }
            catch (Exception ex)
            { Console.WriteLine(ex.Message); }
        }

        public void bbidaskqs_clicked(Object sender, System.EventArgs e)
        {
            try
            {
                Button btn = (Button)sender;

            int n = (int)btn.Tag;

           byte err= setBidAskQ(n);
                if (err == 1) MessageBox.Show("Bad bid/ask values.");
            }
            catch (Exception ex)
            { Console.WriteLine(ex.Message); }
        }

            public void bgenround_clicked(Object sender, System.EventArgs e)
        {
            try
            {


                Button btn = (Button)sender;

                int n = (int)btn.Tag;

                setNewStrike(n);
            }
            catch (Exception ex)
            { Console.WriteLine(ex.Message); }

        }


        public bool? optionOrderIsBullish(Contract c,Order o)
        {
            if (o.Action.Equals("BUY"))
            {
                if (c.Right.Contains("P")) return false;
                if (c.Right.Contains("C")) return true;
            }
            else
            {
                if (c.Right.Contains("P")) return true;
                if (c.Right.Contains("C")) return false;
            }
            return null; 
        }


        // Result of (Click Button) event, get the text of button 
        public void ClickOrderButton(Object sender, System.EventArgs e)
        {
            System.Windows.Forms.Label btn = (System.Windows.Forms.Label)sender;

            string t = (string)btn.Tag;
            string[] jn = t.Split(new char[] { ',' });
            int j = Int32.Parse(jn[0]); //j is order
            int n = Int32.Parse(jn[1]); //n is contract 

            //MessageBox.Show("You clicked [" + btn.Text + "] for [j,n]="+j.ToString()+","+n.ToString());

            double last = 0;
            try
            {
                last = Double.Parse(llasts_underlying[n].Text);
            }
            catch { }

            try
            {
                ContractDefinition cd = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n];
                Contract c = cd.contract;
                Order ordertemplate = IBCD.orderWatchlists[watchlistindex].orderDefinitions[j].order;

                Order o=(Order)ordertemplate.Copy();

                IBControlDefinition tempib = new IBControlDefinition();
                tempib.orderWatchlists.Add(new IBControlDefinition.OrderWatchlist());
                tempib.orderWatchlists[0].contractDefinitions.Add(new ContractDefinition());
                tempib.orderWatchlists[0].contractDefinitions[0] = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].Copy();


                string fn = "";


                //bypass stuff
                o.TotalQuantity = Double.Parse(bqtys[n].Text);

                if (o.Action.Contains("S"))
                {
                    double position = Double.Parse(lpos[n].Text);
                    if (position!=o.TotalQuantity)
                    {
                       DialogResult dr= MessageBox.Show(null, String.Format("Quantity is {0}, while position is {1}. Set quantity to position?",o.TotalQuantity,position), "", MessageBoxButtons.YesNoCancel);
                        if (dr== DialogResult.Yes)
                        {
                            o.TotalQuantity = position;
                            bqtys[n].Text = position.ToString();
                        }
                        else if (dr== DialogResult.Cancel)
                        {
                            return;
                        }

                    }
                }

                double limitPrice = 0;
                try
                {
                    limitPrice = Double.Parse(blmts[n].Text);
                }
                catch { }

                double auxPrice = 0;
                try
                {
                    auxPrice = Double.Parse(bauxs[n].Text);
                }
                catch { }


                

                if (o.OrderType.Contains("STP LMT"))
                {
                    //extrainfo ei = new extrainfo();
                    //ei.ShowDialog();

                    //if (ei.result != DialogResult.OK) return;

                    if ((limitPrice == 0 || limitPrice < last || auxPrice == 0 || auxPrice < last) && o.Action.Contains("B"))
                    {
                        DialogResult dr = MessageBox.Show(null, String.Format("long STPLMT set to value less than last price. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                        if (dr == DialogResult.Yes) { } else { return; }
                    }

                    if ((limitPrice == 0 || limitPrice > last ||auxPrice == 0 || auxPrice > last) && o.Action.Contains("S"))
                    {
                        DialogResult dr = MessageBox.Show(null, String.Format("short STPLMT set to value more than last price. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                        if (dr == DialogResult.Yes) { } else { return; }
                    }

                    o.LmtPrice = limitPrice;
                    o.AuxPrice = auxPrice;

                }
                else if (o.OrderType.Contains("STP"))
                {
                   // extrainfo ei = new extrainfo();
                   // ei.ShowDialog();

                   // if (ei.result != DialogResult.OK) return;



                  

                    if ((auxPrice == 0 || auxPrice < last) && o.Action.Contains("B"))
                    {
                        DialogResult dr = MessageBox.Show(null, String.Format("long STP set to value less than last price. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                        if (dr == DialogResult.Yes) { } else { return; }
                    }

                    if (( auxPrice == 0 || auxPrice > last) && o.Action.Contains("S"))
                    {
                        DialogResult dr = MessageBox.Show(null, String.Format("short STP set to value more than last price. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                        if (dr == DialogResult.Yes) { } else { return; }
                    }

                    o.LmtPrice = limitPrice;
                    o.AuxPrice = auxPrice;
                }

                PriceCondition pco = null;
                o.Conditions.Clear();
                List<OperatorCondition> cc = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].conditions;
                if (lapplycond[n].Checked)
                {
                    for (int ii = 0; ii < cc.Count; ii++)
                    {
                        o.Conditions.Add(cc[ii]);
                        if (cc[ii].Type== OrderConditionType.Price)
                        {
                            pco = cc[ii] as PriceCondition;
                        }
                    }
                }
                bool stopadded = false;
                double stopprice = 0;
                try
                {
                    stopprice = Double.Parse(bauxs[n].Text);
                        }
                catch { }
                if (stopprice > 0 && stopprice < 50000)
                {
                    if (cd.underlying.ConId > 0)
                    {
                        if (btypes[n].Text.Equals("OPT"))
                        {
                            //apply limit as a condition
                            PriceCondition pc = new PriceCondition();
                            bool? bullish = optionOrderIsBullish( c,  o);
                            if (bullish==null)
                            {
                                DialogResult dr = MessageBox.Show(null, String.Format("Unrecognized option situation."), "", MessageBoxButtons.OK);
                                return;
                            }
                            pc.IsMore = bullish == true ? true : false;
                            pc.IsConjunctionConnection = true;
                            pc.TriggerMethod = IBApi.TriggerMethod.Last;
                            pc.Type = OrderConditionType.Price;
                            pc.ConId = cd.underlying.ConId;
                            pc.Price = stopprice;

                            pc.Exchange = cd.underlying.Exchange;
                            //replace pco for checking conditions

                            o.Conditions.Add(pc);

                            pco = pc;

                            stopadded = true;
                        }
                    }
                    else
                    {
                        DialogResult dr = MessageBox.Show(null, String.Format("Underlying conid unavailable."), "", MessageBoxButtons.OK);
                        return;
                    }
                }

                double limitprice = 0;
                try
                {
                    limitprice = Double.Parse(blmts[n].Text);
                }
                catch { }
                if (limitprice > 0 && limitprice < 50000 && stopadded)
                {
                    if (cd.underlying.ConId > 0)
                    {
                        if (btypes[n].Text.Equals("OPT"))
                        {
                            //apply limit as a condition
                            PriceCondition pc = new PriceCondition();
                            bool? bullish = optionOrderIsBullish(c, o);
                            if (bullish == null)
                            {
                                DialogResult dr = MessageBox.Show(null, String.Format("Unrecognized option situation."), "", MessageBoxButtons.OK);
                                return;
                            }
                            pc.IsMore = bullish == true ? false : true;
                            pc.IsConjunctionConnection = true;
                            pc.TriggerMethod = IBApi.TriggerMethod.Last;
                            pc.Type = OrderConditionType.Price;
                            pc.ConId = cd.underlying.ConId;
                            pc.Price = limitprice;
                            pc.Exchange = cd.underlying.Exchange;
                            o.Conditions.Add(pc);

                        }
                    }
                    else
                    {
                        DialogResult dr = MessageBox.Show(null, String.Format("Underlying conid unavailable."), "", MessageBoxButtons.OK);
                        return;
                    }
                }


                tempib.orderWatchlists[0].orderDefinitions.Add(new OrderDefinition());
                int id = tempib.orderWatchlists[0].orderDefinitions.Count - 1;
                tempib.orderWatchlists[0].orderDefinitions[id].order = o;


                if (true)//orderid > 0)
                {
                    //handle child orders
                    List<OrderDefinition> cods = IBCD.orderWatchlists[watchlistindex].orderDefinitions[j].childOrderDefinitions;
                    int codn = cods.Count;

                    for (int i = 0; i < codn; i++)
                    {
                        if (cods[i] == null) continue;
                        Order cotemplate = cods[i].order;
                        Order co = (Order)cotemplate.Copy();

                        co.TotalQuantity = o.TotalQuantity;

                        //these are for trading the underlying itself
                        if (co.OrderType.Equals("LMT"))
                        {
                            co.LmtPrice = Double.Parse(btargets[n].Text);
                           


                            if (o.Action.Equals("BUY"))
                            {

                                if (pco==null && !o.OrderType.Equals("LMT"))
                                {
                                    if (co.LmtPrice == 0 || co.LmtPrice <= last)
                                    {
                                        DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value less than last. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                        if (dr == DialogResult.Yes) { } else { return; }
                                    }
                                }
                                else if (pco!=null)
                                {
                                    if (pco.IsMore)
                                    {
                                        if (co.LmtPrice == 0 || co.LmtPrice <= pco.Price)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value less than pricecondition price. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                    else
                                    {
                                        if (co.LmtPrice >= pco.Price)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value more than pricecondition price. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                }
                                else
                                {
                                    if (o.OrderType.Contains("LMT"))
                                    {
                                        if ( last < o.LmtPrice && co.LmtPrice<o.LmtPrice)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value less than parent order limit for a long order. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes)    {  }    else  {  return;   }
                                        }
                                        if (last > o.LmtPrice && co.LmtPrice > o.LmtPrice)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value more than parent order limit for a short order. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                }
                            }
                            else //sell
                            {
                                if (pco == null && !o.OrderType.Equals("LMT"))
                                {
                                    if (co.LmtPrice == 0 || co.LmtPrice >= last)
                                    {
                                        DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value more than last for sell. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                        if (dr == DialogResult.Yes) { } else { return; }
                                    }
                                }
                                else if (pco != null)
                                {
                                    if (pco.IsMore)
                                    {
                                        if (co.LmtPrice == 0 || co.LmtPrice >= pco.Price)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value more than pricecondition price for sell. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                    else
                                    {
                                        if (co.LmtPrice <= pco.Price)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value less than pricecondition price for sell. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                }
                                else
                                {
                                    if (o.OrderType.Contains("LMT"))
                                    {
                                        if (last < o.LmtPrice && co.LmtPrice >= o.LmtPrice)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value more than parent order limit for a long order for sell. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                        if (last > o.LmtPrice && co.LmtPrice <= o.LmtPrice)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("LMT set to value less than parent order limit for a short order (for sell). Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                }
                            }
                        }
                        if (co.OrderType.Equals("STP"))
                        {
                            co.AuxPrice = Double.Parse(bstops[n].Text);
                            last = 50000;
                            try
                            {
                                last = Double.Parse(llasts_underlying[n].Text);
                            }
                            catch (Exception ex)
                            { Console.WriteLine(ex.Message); }
                            if (o.Action.Equals("BUY"))
                            {

                                if (pco == null && !o.OrderType.Equals("LMT"))
                                {
                                    if (co.AuxPrice >= last)
                                    {
                                        DialogResult dr = MessageBox.Show(null, String.Format("stop set to value more than last. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                        if (dr == DialogResult.Yes) { } else { return; }
                                    }
                                }
                                else if (pco != null)
                                {
                                    if (pco.IsMore)
                                    {
                                        if (co.AuxPrice >= pco.Price)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("stop set to value more than pricecondition price. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                    else
                                    {
                                        if (co.AuxPrice <= pco.Price)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("stop set to value less than pricecondition price. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                }
                                else
                                {
                                    if (o.OrderType.Contains("LMT"))
                                    {
                                        if (last < o.LmtPrice && co.AuxPrice >= o.LmtPrice)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("stop set to value more than parent order limit for a long order. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                        if (last > o.LmtPrice && co.AuxPrice <= o.LmtPrice)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("stop set to value less than parent order limit for a short order. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                }
                            }
                            else //sell
                            {
                                if (pco == null && !o.OrderType.Equals("LMT"))
                                {
                                    if (co.LmtPrice == 0 || co.AuxPrice <= last)
                                    {
                                        DialogResult dr = MessageBox.Show(null, String.Format("stop set to value less for sell than last for sell. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                        if (dr == DialogResult.Yes) { } else { return; }
                                    }
                                }
                                else if (pco != null)
                                {
                                    if (pco.IsMore)
                                    {
                                        if (co.LmtPrice == 0 || co.AuxPrice <= pco.Price)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("stop set to value less for sell than pricecondition price for sell. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                    else
                                    {
                                        if (co.AuxPrice >= pco.Price)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("stop set to value more for sell than pricecondition price for sell. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                }
                                else
                                {
                                    if (o.OrderType.Contains("LMT"))
                                    {
                                        if (last < o.LmtPrice && co.AuxPrice <= o.LmtPrice)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("stop set to value less for sell than parent order limit for a long order for sell. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                        if (last > o.LmtPrice && co.AuxPrice >= o.LmtPrice)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("stop set to value more for sell than parent order limit for a short order (for sell). Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                }
                            }
                        }

                        if (cods[i].name.Equals("target"))
                        {
                            // add target value as conditional limit of it
                            //for (int ii = 0; ii < cc.Count; ii++)
                            {
                                //if (cc[ii].Type==OrderConditionType.Price)
                                if (btypes[n].Text.Equals("OPT"))
                                {
                                    double target = 0;
                                    try
                                    {
                                        target = Double.Parse(btargets[n].Text);
                                    }
                                    catch { }
                                    if (target>0 && target<50000)
                                    { 

                                   // PriceCondition pc = cc[ii] as PriceCondition;
                                    PriceCondition pctemp = new PriceCondition();
                                    pctemp.Exchange = cd.underlying.Exchange;
                                    pctemp.ConId = cd.underlying.ConId;
                                    pctemp.IsConjunctionConnection = true;

                                        bool? bullish = optionOrderIsBullish(c, cods[i].order);
                                        if (bullish == null)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("Unrecognized option situation."), "", MessageBoxButtons.OK);
                                            return;
                                        }
                                        pctemp.IsMore = bullish == true ? false : true;
                                        pctemp.Price = target;

                                    last = 0;
                                    try
                                    {
                                        last = Double.Parse(llasts_underlying[n].Text);
                                    }
                                    catch (Exception ex)
                                    { Console.WriteLine(ex.Message); }

                                    bool goingup = true;
                                    double entry = last;
                                    if (c.Right.Contains("P")) { goingup = false; }
                                    if (pco != null)
                                    {
                                        if (pco.IsMore == false) { goingup = false; }
                                        entry = pco.Price;
                                    }
                                    if (o.Action.Equals("BUY"))
                                    {
                                        if (goingup && pctemp.Price <= entry)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("Target set to value less than entry. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }

                                        if (!goingup && pctemp.Price >= entry)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("Target set to value more than entry. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }
                                    else //sell
                                    {
                                        if (goingup && pctemp.Price >= entry)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("Target set to value more, for short, than entry. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }

                                        if (!goingup && pctemp.Price <= entry)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("Target set to value less, for short, than entry. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                    }

                                    /*
                                    if (pctemp.Price == 0 || pctemp.Price <= last)
                                    {
                                        DialogResult dr = MessageBox.Show(null, String.Format("Target set to value less than last. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                        if (dr == DialogResult.Yes) { } else { return; }
                                    }
                                    */

                                    pctemp.Type =  OrderConditionType.Price;
                                    co.Conditions.Add(pctemp);
                                }
                                    else
                                    {
                                        cods[i] = null;
                                    }
                                }
                            }
                        }
                        if (cods[i] == null) continue;
                        if (cods[i].name.Equals("stop"))
                        {
                            // add target value as conditional limit of it
                          //  for (int ii = 0; ii < cc.Count; ii++)
                            {
                                if (btypes[n].Text.Equals("OPT"))
                                {
                                    double stop = 0;
                                    try
                                    {
                                        stop = Double.Parse(bstops[n].Text);
                                    }
                                    catch { }
                                    if (stop > 0 && stop < 50000)
                                    {

                                        // PriceCondition pc = cc[ii] as PriceCondition;
                                        PriceCondition pctemp = new PriceCondition();
                                        pctemp.Exchange = cd.underlying.Exchange;
                                        pctemp.ConId = cd.underlying.ConId;
                                        pctemp.IsConjunctionConnection = true;

                                        bool? bullish = optionOrderIsBullish(c, cods[i].order);
                                        if (bullish == null)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("Unrecognized option situation."), "", MessageBoxButtons.OK);
                                            return;
                                        }
                                        pctemp.IsMore = bullish == true ? true : false;
                                        pctemp.Price = stop;

                                        last = 50000;
                                        try
                                        {
                                            last = Double.Parse(llasts_underlying[n].Text);
                                        }
                                        catch (Exception ex)
                                        { Console.WriteLine(ex.Message); }

                                        bool goingup = true;
                                        double entry = last;
                                        if (c.Right.Contains("P")) { goingup = false; }
                                        if (pco != null)
                                        {
                                            if (pco.IsMore == false) { goingup = false; }
                                            entry = pco.Price;
                                        }
                                        if (o.Action.Contains("B")) //buy
                                        {
                                            if (goingup && pctemp.Price >= entry)
                                            {
                                                DialogResult dr = MessageBox.Show(null, String.Format("stop set to value more than entry. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                                if (dr == DialogResult.Yes) { } else { return; }
                                            }

                                            if (!goingup && pctemp.Price <= entry)
                                            {
                                                DialogResult dr = MessageBox.Show(null, String.Format("stop set to value less than entry. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                                if (dr == DialogResult.Yes) { } else { return; }
                                            }
                                        }
                                        else //sell
                                        {
                                            if (goingup && pctemp.Price <= entry)
                                            {
                                                DialogResult dr = MessageBox.Show(null, String.Format("Target set to value less, for short, than entry. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                                if (dr == DialogResult.Yes) { } else { return; }
                                            }

                                            if (!goingup && pctemp.Price >= entry)
                                            {
                                                DialogResult dr = MessageBox.Show(null, String.Format("Target set to value more, for short, than entry. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                                if (dr == DialogResult.Yes) { } else { return; }
                                            }
                                        }

                                        /*
                                        if (pctemp.Price >= last)
                                        {
                                            DialogResult dr = MessageBox.Show(null, String.Format("STP set to value more than last. Are you sure you want to continue?"), "", MessageBoxButtons.YesNoCancel);
                                            if (dr == DialogResult.Yes) { } else { return; }
                                        }
                                        */

                                        pctemp.Type =  OrderConditionType.Price;
                                        co.Conditions.Add(pctemp);
                                    }
                                }
                                else
                                {
                                    cods[i] = null;
                                }
                            }
                        }

                        tempib.orderWatchlists[0].orderDefinitions[id].childOrderDefinitions.Add(new OrderDefinition());
                        int idc = tempib.orderWatchlists[0].orderDefinitions[id].childOrderDefinitions.Count - 1;
                        tempib.orderWatchlists[0].orderDefinitions[id].childOrderDefinitions[idc].order = co.Copy();

                    }
                }
                if (checkBoxArmed.Checked)
                {
                    /*
                    int orderid = orderManager.PlaceOrder(c, tempib.orderWatchlists[0].orderDefinitions[id].order);
                    tempib.orderWatchlists[0].orderDefinitions[id].order.OrderId = orderid;
                    Thread.Sleep(100);
                    Application.DoEvents();
                    int ccnt = tempib.orderWatchlists[0].orderDefinitions[id].childOrderDefinitions.Count;
                    for (int idc = 0; idc < ccnt; idc++)
                    {
                        tempib.orderWatchlists[0].orderDefinitions[id].childOrderDefinitions[idc].order.ParentId = orderid;
                        int childorderid = orderManager.PlaceOrder(c, tempib.orderWatchlists[0].orderDefinitions[id].childOrderDefinitions[idc].order);
                        tempib.orderWatchlists[0].orderDefinitions[id].childOrderDefinitions[idc].order.OrderId = childorderid;
                        Thread.Sleep(100);
                        Application.DoEvents();
                    }
                    */

                    orderManager.PlaceOrder(tempib);
                   
                }
                else
                {
                    orderManager.presubmitOrders.Add(tempib);


                }

              



            }
            catch (Exception ex)
            { Console.WriteLine(ex.Message); }
        }

        public async void ClickConditionButton(Object sender, System.EventArgs e)
        {
            Button btn = (Button)sender;

            string t = (string)btn.Tag;
            string[] jn = t.Split(new char[] { ',' });
            int j = Int32.Parse(jn[0]); //j is order
            int n = Int32.Parse(jn[1]); //n is contract 

            //MessageBox.Show("You clicked [" + btn.Text + "] for [j,n]="+j.ToString()+","+n.ToString());

            try
            {
                OperatorCondition cc = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].conditions[j];
                Contract c = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract;

                if (cc.Type == OrderConditionType.Price && ibClient.ClientSocket.IsConnected())
                {
                    PriceCondition pc = cc as PriceCondition;
                    if (pc.ConId == 0)
                    {
                        List<Contract> contracts = new List<Contract>();
                        contracts.AddRange(await ibClient.ResolveContractAsync("STK", c.Symbol, c.Currency, c.Exchange));
                        Thread.Sleep(1000);
                        if (contracts.Count > 0)
                        {
                            pc.ConId = contracts[0].ConId;
                        }
                    }

                }
                Thread.Sleep(100);
                ConditionDialog cd = new ConditionDialog(cc, ibClient);

                Thread.Sleep(250);

                cd.ShowDialog();

                if (cd.DialogResult== DialogResult.OK)
                {

                }
            }
            catch (Exception ex)
            { Console.WriteLine(ex.Message); }
        }

        private void generateSymbolDetails(int n)
        {
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract.Symbol = bsymbols[n].Text;
                Contract contract = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract;
                string localsymbol = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].generatedLocalSysmbol;
                contract.LocalSymbol = localsymbol;
                blocalsymbols[n].Text = localsymbol;
                string key = ContractDefinition.Tools.uniqueKey(contract);

                if (marketDataManager.uniquesymbolreqids.ContainsKey(key))
                {
                    llasts_underlying[n].Tag = marketDataManager.uniquesymbolreqids[key];
                    lspreads_underlying[n].Tag = marketDataManager.uniquesymbolreqids[key];
                }
                lsymbols[n].Text = bsymbols[n].Text;
            }
            else if (n == IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                //DateTime dtnow = DateTime.Now;
                lsymbols[n].Text = bsymbols[n].Text;

                ContractDefinition cd = IBCD.orderWatchlists[watchlistindex].defaultContractDefinition.Copy();
                cd.contract.Symbol = bsymbols[n].Text;
                cd.contract.Right = "Call";
                cd.contract.LastTradeDateOrContractMonth= TB_DefaultExpiry.Text;
                cd.contract.LocalSymbol = ContractDefinition.Tools.getLocalSymbol(cd.contract);

                IBCD.orderWatchlists[watchlistindex].contractDefinitions.Add(cd);

                btypes[n].Text = cd.contract.SecType;
                bstrikes[n].Text = cd.contract.Strike.ToString();
                brights[n].Text = cd.contract.Right;
                bexpiries[n].Text = cd.contract.LastTradeDateOrContractMonth;
                blocalsymbols[n].Text = cd.contract.LocalSymbol;

                bqtys[n].Text = TB_SetAllQty.Text;
                setbconds(n, cd.conditions, cd);

                blmts[n].Text = "0";
                bauxs[n].Text = "0";
                btargets[n].Text = "0";
                bstops[n].Text = "0";

                genTicksForUnderlying(n);
            }
        }

        private void bsymbols_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;

            tt.Text = tt.Text.ToUpper();

            generateSymbolDetails(n);
            fillIBCD();

            if (btypes[n].Text.Equals("STK"))
            {
                manageTicksForContracts(n);
            }

        }

        private void btypes_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;

            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract.SecType = btypes[n].Text;

                string localsymbol = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].generatedLocalSysmbol;
                blocalsymbols[n].Text = localsymbol;
                IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract.LocalSymbol = localsymbol;
            }
        }

        private void bstrikes_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;
           
                strikeChanged(n);
            
        }

        public void manageTicksForContracts(int n)
        {
            int reqid = (int)lbids_contract[n].Tag;
            if (reqid > 0)
            {
                marketDataManager.StopActiveRequest(reqid);

                lasks_contract[n].Text = "0";
                lbids_contract[n].Text = "0";
                lspreads_contract[n].Text = "0";
                lspreads_underlying[n].Text = "0";

                marketDataManager.RestartRequest(IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract, "", reqid);
            }
            else
            {

                genTicksForContracts(n);
            }
        }

        public void strikeChanged(int n)
        {
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract.Strike = Double.Parse(bstrikes[n].Text);
                string localsymbol = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].generatedLocalSysmbol;
                blocalsymbols[n].Text = localsymbol;
                updateLocalSymbol(n);

                if (btypes[n].Text.Equals("OPT"))
                {
                    manageTicksForContracts(n);
                }
            }
        }

        private void bexpiries_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract.LastTradeDateOrContractMonth = bexpiries[n].Text;

                string localsymbol = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].generatedLocalSysmbol;
                blocalsymbols[n].Text = localsymbol;
                updateLocalSymbol(n);

            }
        }

        private void updateLocalSymbol(int n)
        {
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract.LocalSymbol = blocalsymbols[n].Text;
            }
        }

        private void blocalsymbols_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;

            updateLocalSymbol(n);
        }


        private void brights_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract.Right = brights[n].Text;

                string localsymbol = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].generatedLocalSysmbol;
                blocalsymbols[n].Text = localsymbol;
                updateLocalSymbol(n);
                if (IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract.Right.Contains("C"))
                {
                    bpanels[n].BackColor = Color.LightGreen;
                }
                else
                {
                    bpanels[n].BackColor = Color.LightPink;
                }
            }
        }

        private void BSAVE_Click(object sender, EventArgs e)
        {

        }

        private void TB_SetAllQty_TextChanged(object sender, EventArgs e)
        {
            try
            {
                IBCD.auxAccountInfo.qty = Int32.Parse(TB_SetAllQty.Text);
            }
            catch { }

        }

        private void TB_SetAllQty_Enter(object sender, EventArgs e)
        {
           
        }

        private void sAVEToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveFileDialog sfd = new SaveFileDialog();
            sfd.AddExtension = true;
            sfd.Filter = "XML Files (*.xml)|*.xml";
            sfd.DefaultExt = "xml";


            DialogResult dr = sfd.ShowDialog();

            if (dr == DialogResult.OK)
            {
                if (!String.IsNullOrEmpty(sfd.FileName))
                    IBCD.saveXML(sfd.FileName);
            }
        }

        private void ballround_Click(object sender, EventArgs e)
        {
            int nContracts = IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count();

            for (int n = 0; n < nContracts; n++)
            {
                setNewStrike(n);
            }
        }

        private void exportToolStripMenuItem_Click(object sender, EventArgs e)
        {
            SaveFileDialog sfd = new SaveFileDialog();
            sfd.AddExtension = true;
            sfd.Filter = "csv Files (*.csv)|*.csv";
            sfd.DefaultExt = "csv";


            DialogResult dr = sfd.ShowDialog();

            if (dr == DialogResult.OK)
            {
                if (!String.IsNullOrEmpty(sfd.FileName))
                {
                    try
                    {
                        using (StreamWriter writer = File.CreateText(sfd.FileName))
                        {


                            int nContracts = IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count();
                            writer.WriteLine("COLUMN,0");
                            for (int n = 0; n < nContracts; n++)
                            {

                                Contract c = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].contract;
                                string exc = c.Exchange;
                                if (exc.Equals("SMART"))
                                {
                                    exc = "SMART/AMEX";
                                }
                                string line = String.Format("DES,{0},{1},{2},{3},{4},{5},100", c.Symbol, c.SecType, exc, c.LastTradeDateOrContractMonth, c.Strike, c.Right);
                                writer.WriteLine(line);

                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                    }
                }
            }
        }

        public void HandlePosition(PositionMessage positionMessage)
        {
            if (IBCD == null) return;


            int i = IBCD.orderWatchlists[watchlistindex].findContractIndex(positionMessage.Contract);

            if (i <0) return;

            lpos[i].Text = positionMessage.Position.ToString();
            if (positionMessage.Position!=0)
            {
                lpos[i].ForeColor = Color.Black;
            }
            else
            {
                lpos[i].ForeColor = Color.LightGray;
            }
        }

        private void LPOS_Click(object sender, EventArgs e)
        {
            ibClient.ClientSocket.reqPositions();
        }

      

        private void FormOrderWatchlist_FormClosing(object sender, FormClosingEventArgs e)
        {
          
        }

        private void TB_UpdateAll_TextChanged(object sender, EventArgs e)
        {
            IBCD.orderWatchlists[watchlistindex].defaultContractDefinition.contract.LastTradeDateOrContractMonth = TB_DefaultExpiry.Text;
        }

        private void TB_UpdateAll_Enter(object sender, EventArgs e)
        {
           
        }

        private void TB_UpdateAll_Leave(object sender, EventArgs e)
        {
            
        }

        private void TB_SetAllQty_Leave(object sender, EventArgs e)
        {
           
        }

        private void fILEToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void B_ApplyExpiry_Click(object sender, EventArgs e)
        {
            int ncnt = IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count;
            for (int i = 0; i < ncnt; i++)
            {
                bexpiries[i].Text = TB_DefaultExpiry.Text;
                btypes[i].Text = TB_DefaultType.Text;
                bexpiries_TextChanged(bexpiries[i], null);

                btypes_TextChanged(btypes[i], null);
            }
        }
        
        private void lapplycond_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox tt = (CheckBox)sender;
            int n = (int)tt.Tag;
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                try
                {
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].auxOrderInfo.applyConditions = lapplycond[n].Checked;
                }
                catch { }
            }

        }

        private void bqty_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                try
                {
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].auxOrderInfo.qty = Int32.Parse(bqtys[n].Text);
                }
                catch { }
            }

        }

        private void blmts_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                try
                {
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].auxOrderInfo.parentLmt = Double.Parse(blmts[n].Text);
                }
                catch { }
            }

        }

        private void bauxs_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                try
                {
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].auxOrderInfo.parentAux = Double.Parse(bauxs[n].Text);
                }
                catch { }
            }

        }

        private void bstops_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                try
                {
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].auxOrderInfo.brackerStop = Double.Parse(bstops[n].Text);
                }
                catch { }
            }

        }

        private void btargets_TextChanged(object sender, EventArgs e)
        {
            TextBox tt = (TextBox)sender;
            int n = (int)tt.Tag;
            if (n < IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count)
            {
                try
                {
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[n].auxOrderInfo.bracketTarget = Double.Parse(btargets[n].Text);
                }
                catch { }
            }

        }

        private void TB_DefaultType_TextChanged(object sender, EventArgs e)
        {
            IBCD.orderWatchlists[watchlistindex].defaultContractDefinition.contract.SecType = TB_DefaultType.Text;


        }

        private void B_ApplyQty_Click(object sender, EventArgs e)
        {
            try
            {
                int ncnt = bqtys.Count();
                int qty = Int32.Parse(TB_SetAllQty.Text);
                for (int i = 0; i < ncnt; i++)
                {
                    bqtys[i].Text = TB_SetAllQty.Text;
                    IBCD.orderWatchlists[watchlistindex].contractDefinitions[i].auxOrderInfo.qty = qty;
                }
            }
            catch { }
        }

        delegate void SetLposZeroCallback(int i);

        private void SetLposZero(int i)
        {
            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these lpos[i] are different, it returns true.
            if (this.lpos[i].InvokeRequired)
            {
                SetLposZeroCallback d = new SetLposZeroCallback(SetLposZero);
                this.Invoke(d, new object[] { i });
            }
            else
            {
                this.lpos[i].Text = "0";
                this.lpos[i].ForeColor = Color.Gray;
            }
        }

        public void clearPositions()
        {
            try
            {
                int ncnt = lpos.Count();
               
                for (int i = 0; i < ncnt; i++)
                {
                    if (!lpos[i].Text.Equals("0"))
                        SetLposZero(i);
                }
            }
            catch { }
        }

        private void B_csvSymbolListGenerate_Click(object sender, EventArgs e)
        {
            try
            {
                string[] symbols = TB_csvSymbolList.Text.Split(new char[] { ',' });

                for(int ii=0;ii<symbols.Count();ii++)
                {
                    string symbol = symbols[ii].Trim().ToUpper();
                    for (int i=0;i<bsymbols.Count();i++)
                    {
                        if (String.IsNullOrEmpty(bsymbols[i].Text))
                        {
                            bsymbols[i].Text = symbol;
                            generateSymbolDetails(i);
                            break;
                        }
                        else
                        {
                            if (bsymbols[i].Text.ToUpper().Equals(symbol.ToUpper()))
                            {
                                //symbol already exists, go to the next one.
                                break;
                            }

                        }
                    }
                }


            }
            catch { }
        }

        private void LORDERS_MouseDown(object sender, MouseEventArgs e)
        {

        }

        private void borders_MouseDown(object sender, MouseEventArgs e)
        {
            System.Windows.Forms.Label btn = (System.Windows.Forms.Label)sender;

            string t = (string)btn.Tag;
            string[] jn = t.Split(new char[] { ',' });
            int j = Int32.Parse(jn[0]); //j is order
            int n = Int32.Parse(jn[1]); //n is contract 
            borders[j,n].BorderStyle = BorderStyle.Fixed3D;
        }

        private void borders_MouseUp(object sender, MouseEventArgs e)
        {
            System.Windows.Forms.Label btn = (System.Windows.Forms.Label)sender;

            string t = (string)btn.Tag;
            string[] jn = t.Split(new char[] { ',' });
            int j = Int32.Parse(jn[0]); //j is order
            int n = Int32.Parse(jn[1]); //n is contract 
            borders[j, n].BorderStyle = BorderStyle.None;
        }

        private void clipboardIdeasToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string clip = "";
            {
                 {
                    try
                    {
                        {
                            int nContracts = IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count();

                            for (int n = 0; n < nContracts; n++)
                            {
                                ContractDefinition cd = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n];
                                Contract c = cd.contract;
                                if (!String.IsNullOrEmpty(c.LocalSymbol))
                                {
                                    string line = String.Format("{0},{1},{2},{3},{4}\n", c.LocalSymbol,cd.auxOrderInfo.brackerStop,cd.auxOrderInfo.parentAux,cd.auxOrderInfo.parentLmt,cd.auxOrderInfo.bracketTarget );
                                    clip = String.Concat(clip, line);
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                    }
                }
            }

            Clipboard.SetText(clip);
        }

        private void bBidAskQ_Click(object sender, EventArgs e)
        {
            try
            {
                int ncnt = bqtys.Count();
              
                for (int i = 0; i < ncnt; i++)
                {
                    setBidAskQ(i);
                }
            }
            catch { }
        }

        private void bStpEntryQ_Click(object sender, EventArgs e)
        {
            try
            {
                int ncnt = bqtys.Count();

                for (int i = 0; i < ncnt; i++)
                {
                    setStpEntryQ(i);
                }
            }
            catch { }
        }

        private void bManageTicks_Click(object sender, EventArgs e)
        {
            try
            {
                int ncnt = IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count;

                for (int i = 0; i < ncnt; i++)
                {
                    manageTicksForContracts(i);
                }

                Dictionary<string, int> uq = marketDataManager.uniquesymbolreqids;
                int c= uq.Count;
                for(int i=0;i<c;i++)
                {
                    Console.WriteLine("{0}={1}", uq.ElementAt(i).Key, uq.ElementAt(i).Value);
                }
                
            }
            catch { }
        }

        private void B_LastQ_Click(object sender, EventArgs e)
        {
            try
            {
                int ncnt = bqtys.Count();

                for (int i = 0; i < ncnt; i++)
                {
                    setLastQ(i);
                }
            }
            catch { }
        }

        private void symbolListToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string clip = "";
            {
                {
                    try
                    {
                        {
                            int nContracts = IBCD.orderWatchlists[watchlistindex].contractDefinitions.Count();

                            for (int n = 0; n < nContracts; n++)
                            {
                                ContractDefinition cd = IBCD.orderWatchlists[watchlistindex].contractDefinitions[n];
                                Contract c = cd.contract;
                                if (!String.IsNullOrEmpty(c.Symbol) && !clip.Contains(c.Symbol))
                                {
                                       clip = String.Concat(clip,",", c.Symbol);
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
                    }
                }
            }
            clip.TrimStart(new char[] { ',' });
            Clipboard.SetText(clip);
        }

        private void TB_AccountRisk_TextChanged(object sender, EventArgs e)
        {
            try
            {
                IBCD.auxAccountInfo.accountRisk = Double.Parse(TB_AccountRisk.Text);
            }
            catch { }
        }

        private void TB_TradeRisk_TextChanged(object sender, EventArgs e)
        {
            try
            {
                IBCD.auxAccountInfo.tradeRisk = Double.Parse(TB_TradeRisk.Text);
            }
            catch { }
        }

        private void TB_TradeRisk_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyValue==46)
            {
                (sender as TextBox).Text = "";
            }
        }

        private void TB_genericNumber_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyValue == 46)
            {
                (sender as TextBox).Text = "";
            }
        }

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            DialogResult dr = ofd.ShowDialog();
            if (dr == DialogResult.OK && !String.IsNullOrEmpty(ofd.FileName))
            {
                string[] fns = ofd.FileName.Split(new char[] { '\\' });
                this.Text = fns[fns.Count() - 1];

                IBCD = new IBControlDefinition();
                IBCD.loadXML(ofd.FileName);
                if (IBCD == null) return;
                if (IBCD.orderWatchlists.Count() > 0)
                {
                    if (IBCD.orderWatchlists[watchlistindex].defaultContractDefinition == null)
                    {
                        /*
                        IBCD.orderWatchlists[watchlistindex].defaultContractDefinition = new ContractDefinition();
                        IBCD.orderWatchlists[watchlistindex].defaultContractDefinition.contract = ContractDefinition.Tools.getGenericContract("");
                        IBCD.orderWatchlists[watchlistindex].defaultContractDefinition.name = "default";
                        IBCD.orderWatchlists[watchlistindex].defaultContractDefinition.conditions
                        */

                        ContractDefinition cd = ContractDefinition.genDefaultContractDefinition("", "STK", "");
                        IBCD.orderWatchlists[watchlistindex].defaultContractDefinition = cd;

                    }
                    try
                    {
                        if (IBCD.auxAccountInfo == null)
                        {
                            IBCD.auxAccountInfo = new IBControlDefinition.AuxAccountInfo();
                        }

                        TB_AccountRisk.Text = IBCD.auxAccountInfo.accountRisk.ToString();
                        TB_TradeRisk.Text = IBCD.auxAccountInfo.tradeRisk.ToString();
                        TB_SetAllQty.Text = IBCD.auxAccountInfo.qty.ToString();
                    }
                    catch
                    {


                    }
                    fillIBCD();


                    Console.WriteLine("add buttons);");

                    AddButtons(IBCD);

                    asyncGenTicksForOptions();
                    asyncGenTicksForUnderlying();


                    DateTime dtnow = DateTime.Now;
                    int dayat = (int)dtnow.DayOfWeek;
                    DateTime dt = dtnow.AddDays(5 - dayat);
                    string dnew = dt.ToString("yyyyMMdd");




                    if (true)//!String.IsNullOrEmpty(IBCD.orderWatchlists[watchlistindex].defaultContract.LastTradeDateOrContractMonth))
                    {
                        TB_DefaultExpiry.Text = IBCD.orderWatchlists[watchlistindex].defaultContractDefinition.contract.LastTradeDateOrContractMonth;
                    }
                    else
                    {
                        TB_DefaultExpiry.Text = dnew;
                    }



                    TB_DefaultType.Text = IBCD.orderWatchlists[watchlistindex].defaultContractDefinition.contract.SecType;

                }
            }
        }
    }
}
