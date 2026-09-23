using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using IBApi;
using IBApi.messages;
using MHA;

namespace MHA
{
    public partial class IBTraderPad : Form
    {
        string[][] griddata = new string[100][];

        double cellPenny = 0.01;

        Dictionary<double, int> penny2index = new Dictionary<double, int>();

        double pivotvalue = 0;

        protected int currentTicker = 0;
        protected int currentTickbytick = 0;

        const int colbids = 1;
        const int colasks = 5;
        const int collastbid = 2;
        const int colprice = 3;
        const int collastask = 4;


        int prevbid_cellindex = 0;
        int prevask_cellindex = 0;
        double prevbid = 0;
        double prevask = 0;
        double prevlast = 0;

        MHA.IBControlDefinition IBCD;

        private EReaderMonitorSignal signal = new EReaderMonitorSignal();
        IBClient ibClient;
        IBWrapper ibWrapper;
        bool isConnected = false;


        delegate void HandleUICallback();

        private void HandleUI()
        {
            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (this.gridTrader.InvokeRequired)
            {
                HandleUICallback d = new HandleUICallback(HandleUI);
                this.Invoke(d, new object[] {});
            }
            else
            {
                if (isConnected)
                {
                    connectToolStripMenuItem.Text = "Disconnect";
                }
                else
                {
                    connectToolStripMenuItem.Text = "Connect";
                 
                }
            }
        }

        public void handledconnectionclose(object sender, EventArgs e)
        {

            isConnected = ibClient.ClientSocket.IsConnected();
            if (isConnected)
            {
              
            }
            else
            {
               
                pivotvalue = 0;
                currentTickbytick = 0;
                cellPenny = 0.01;
            }
        }
        public DataTable dt;
        int gridsize = 400;
        public IBTraderPad()
        {
            InitializeComponent();
            /*
            for (int i=0;i< griddata.Length;i++)
            {
                griddata[i] = new string[] { "", "0", "", "", "0", "" };
            }
            //          gridTrader.DataSource = (from arr in griddata select new { BidHist = arr[0], BidSize = arr[1], BidPrice = arr[2], AskPrice = arr[3], AskSize = arr[4], AskHist = arr[5] });

            //
            dt = new DataTable();
            dt.Columns.Add("BidH");
            dt.Columns.Add("BidS");
            dt.Columns.Add("BidP");
            dt.Columns.Add("AskP");
            dt.Columns.Add("AskS");
            dt.Columns.Add("AskH");
        
            int l = griddata.Length;

            for (int i = 0; i < l; i++)
            {
                dt.LoadDataRow(griddata[i], true); //Pass array object to LoadDataRow method
            }

            gridTrader.DataSource = dt;
            */
            

           
            for (int i = 0; i < gridsize; i++)
            {
                gridTrader.Rows.Add(new string[]{ "","","","","","",""});
             }

            //gridTrader.FirstDisplayedScrollingRowIndex = 40;
            gridTrader.CurrentCell = gridTrader.Rows[gridsize/2-10].Cells[0];
            ibClient = new IBClient(signal);

            ibWrapper = new IBWrapper(ibClient, signal);
            
            //ibWrapper.HandledTickPrice += handledtick;
            //ibWrapper.HandledTickSize += handledticksize;
            ibWrapper.HandledMarketDataType += handlemarketdatatype;
            ibWrapper.HandledConnectionClose += handledconnectionclose;
            //ibWrapper.HandledTickByTickAllLast += handledtickbytickalllast;
            //ibWrapper.HandledTickByTickBidAsk += handledtickbytickbidask;
            ibWrapper.ibClient.tickByTickAllLast += handletickbytickalllast;
            ibWrapper.ibClient.tickByTickBidAsk += handletickbytickbidask;
            ibWrapper.ibClient.Error += HandleError;

            //for now use some hardcoded IBCD
            IBCD = new IBControlDefinition();

            Random random = new Random();
            
            IBCD.ClientId = 500+ random.Next(0, 50);
            IBCD.port = 4002;// 7497;// 4002;
            IBCD.host = "";

        }

        void HandleError(int id, int errorCode, string str, Exception ex)
        {
           // Console.WriteLine("ERROR:{0}-{1}", errorCode.ToString(), str);


        }


        private void connectToolStripMenuItem_Click(object sender, EventArgs e)
        {
            isConnected = ibClient.ClientSocket.IsConnected();
            if (!isConnected)
            {
                ibWrapper.ibClient.ClientId = IBCD.ClientId;
                ibWrapper.allowedPorts = new int[] { IBCD.port };
                ibWrapper.Connect(IBCD.host);
                ibWrapper.CleanUpSummary();
            }
            else
            {
                ibWrapper.Disconnect();
            }



            isConnected = ibClient.ClientSocket.IsConnected();
                if (isConnected)
                {
                    connectToolStripMenuItem.Text = "Disconnect";
                }
                else
                {
                    connectToolStripMenuItem.Text = "Connect";
                }
          



        }



        private void handlemarketdatatype(object sender, EventArgs e)
        {
            Console.WriteLine("marketdata type by handler:{0}", ibWrapper.MarketDataType);
        }

        private double ind2penny(int ind)
        {
            
            int midindex = gridsize / 2;
            double pennydiff = (double)(midindex - ind) * cellPenny;
            return pivotvalue + pennydiff;
        }

        private int penny2ind(double p)
        {
            // double pennydiff = p - pivotvalue;
            //int midindex = gridsize / 2;
            //return midindex-(int)(pennydiff / cellPenny);

            double roundp = Math.Round(p / cellPenny) * cellPenny;

            if (penny2index.ContainsKey(roundp))
            {
                return penny2index[roundp];
            }
            else
            {
           //     Console.WriteLine("WARNING: price not in dictionary:{0}", roundp.ToString());
            }
            return 0;
            
        }

        Semaphore SETTHIS = new Semaphore(1,1);
        Semaphore processbidask = new Semaphore(1, 1);
        Semaphore processlast = new Semaphore(1, 1);
        private double setBidAskGrids(double p)
        {

            SETTHIS.WaitOne();
            try
            {
                //  Console.WriteLine("pivotvalue={0}", pivotvalue);

                penny2index.Clear();

                for (int i = 0; i < gridsize; i++)
                {
                    // int midindex = gridsize / 2;
                    // double pennydiff = (double)(midindex - i) * cellPenny;
                    double price = ind2penny(i);
                    gridTrader.Rows[i].Cells[3].Value = (price).ToString();
                    if (!penny2index.ContainsKey(price))
                    {
                        penny2index.Add(price, i);
                    }
                }
            }
            catch { }
            SETTHIS.Release();
            return p;
        }

        private void updateTraderCell(int row,int col,string value)
        {
           // Console.WriteLine("{0}x{1}={2}", row, col, value);
            if (row < 0) return;
            if (row > gridsize - 1) return;
            gridTrader.Rows[row].Cells[col].Value = value;
        }


        private int[] grabLastSizes(int row)
        {
            string prevval2 = (string)gridTrader.Rows[row].Cells[2].Value;
            string prevval4 = (string)gridTrader.Rows[row].Cells[4].Value;
            int[] prevsize=new int[2];
            //int prevsize4 = 0;
            prevsize[0] = 0;
            prevsize[1] = 0;
            try
            {
                prevsize[0] = Int32.Parse(prevval2);
               
            }
            catch { }
            try
            {
               
                prevsize[1] = Int32.Parse(prevval4);
            }
            catch { }

            return prevsize;
        }


        private void handledtickbytickalllast(object sender, EventArgs e)
        {
          // processlast.WaitOne();
            while (ibWrapper.TickByTickAllLastAvailable())
            {
                try
                {
                    TickByTickAllLastMessage etp = ibWrapper.TickByTickAllLastDQ();
                    if (etp != null)
                    {
                      //  Console.WriteLine("Tick-By-Tick. Request Id: {0}, TickType: {1}, Time: {2}, Price: {3}, Size: {4}, Exchange: {5}, Special Conditions: {6}, PastLimit: {7}, Unreported: {8}", etp.ReqId, etp.TickType == 1 ? "Last" : "AllLast", Util.UnixSecondsToString(etp.Time, "yyyyMMdd-HH:mm:ss zzz"), etp.Price, etp.Size, etp.Exchange, etp.SpecialConditions, etp.TickAttribLast.PastLimit, etp.TickAttribLast.Unreported);
                        //  Console.WriteLine("currentTickbytick={0}", currentTickbytick);
                        // use only the most recent ticker id

                        // if (etp.TickAttribLast.Unreported == true) return;

                        if ((currentTickbytick) == etp.ReqId)
                        {
                            if (pivotvalue == 0)
                            {
                                //last values are wrong sometimes, so let's make bid/ask set this

                                //wait for a a last value to arrive first, and set it as pivot
                                pivotvalue = Math.Round(etp.Price / cellPenny) * cellPenny;

                                setBidAskGrids(pivotvalue);
                            }

                            if (pivotvalue > 0)
                            {
                                int wipeind = 0;
                                int placeind = 0;
                                {//bid
                                    double price = etp.Price;
                                    if (price > 0)
                                    {

                                        placeind = penny2ind(price);
                                        // Console.WriteLine("placeind={0}", placeind);

                                        //string prevval = (string)gridTrader.Rows[placeind].Cells[2].Value;
                                        //string[] pp = prevval.Split(new char[] {'-'});
                                        //string ppp = String.Concat( pp[0],"-",etp.Size.ToString());


                                        int[] prevsize = new int[2];
                                        prevsize[0] = 0;
                                        prevsize[1] = 1;
                                        if (price <= prevbid && price < prevask)
                                        {

                                            prevsize = grabLastSizes(placeind);
                                            updateTraderCell(placeind, collastbid, (prevsize[0] + etp.Size).ToString());

                                        }
                                        else if (price >= prevask && price > prevbid)
                                        {
                                            //gridTrader.Rows[placeind].Cells[3].Style.BackColor = Color.Green;
                                            prevsize = grabLastSizes(placeind);
                                            updateTraderCell(placeind, collastask, (prevsize[1] + etp.Size).ToString());
                                        }

                                        else
                                        {
                                            prevsize = grabLastSizes(placeind);
                                            updateTraderCell(placeind, collastask, (prevsize[1] + etp.Size / 2).ToString());
                                            updateTraderCell(placeind, collastbid, (prevsize[0] + etp.Size / 2).ToString());
                                        }
                                        Color color;
                                        if (prevsize[0] > prevsize[1])
                                        {
                                            //gridTrader.Rows[placeind].Cells[colprice].Style.BackColor = Color.Pink;
                                            color = Color.Pink;
                                        }
                                        else if (prevsize[0] < prevsize[1])
                                        {
                                            //gridTrader.Rows[placeind].Cells[colprice].Style.BackColor = Color.LightGreen;
                                            color = Color.LightGreen;
                                        }
                                        else
                                        {
                                           // gridTrader.Rows[placeind].Cells[colprice].Style.BackColor = Color.White;
                                            color = Color.White;
                                        }

                                        CellUpdateColorText(placeind, colprice, null, color);


                                        //SetCell(placeind,3);
                                    }
                                }


                            }
                        }
                    }
                }
                catch { }
                Application.DoEvents();
            }
            
         // processlast.Release();
        }

        private void handletickbytickalllast(TickByTickAllLastMessage etp)
        {
            
            {
                try
                {
                   
                    if (etp != null)
                    {
                        if ((currentTickbytick) == etp.ReqId)
                        {
                            if (pivotvalue == 0)
                            {
                                //last values are wrong sometimes, so let's make bid/ask set this

                                //wait for a a last value to arrive first, and set it as pivot
                                pivotvalue = Math.Round(etp.Price / cellPenny) * cellPenny;

                                setBidAskGrids(pivotvalue);
                            }

                            if (pivotvalue > 0)
                            {
                                int wipeind = 0;
                                int placeind = 0;
                                {//bid
                                    double price = etp.Price;
                                    if (price > 0)
                                    {

                                        placeind = penny2ind(price);
                                        // Console.WriteLine("placeind={0}", placeind);

                                        //string prevval = (string)gridTrader.Rows[placeind].Cells[2].Value;
                                        //string[] pp = prevval.Split(new char[] {'-'});
                                        //string ppp = String.Concat( pp[0],"-",etp.Size.ToString());


                                        int[] prevsize = new int[2];
                                        prevsize[0] = 0;
                                        prevsize[1] = 1;
                                        if (price <= prevbid && price < prevask)
                                        {

                                            prevsize = grabLastSizes(placeind);
                                            updateTraderCell(placeind, collastbid, (prevsize[0] + etp.Size).ToString());

                                        }
                                        else if (price >= prevask && price > prevbid)
                                        {
                                            //gridTrader.Rows[placeind].Cells[3].Style.BackColor = Color.Green;
                                            prevsize = grabLastSizes(placeind);
                                            updateTraderCell(placeind, collastask, (prevsize[1] + etp.Size).ToString());
                                        }

                                        else
                                        {
                                            prevsize = grabLastSizes(placeind);
                                            updateTraderCell(placeind, collastask, (prevsize[1] + etp.Size / 2).ToString());
                                            updateTraderCell(placeind, collastbid, (prevsize[0] + etp.Size / 2).ToString());
                                        }
                                        Color color;
                                        if (prevsize[0] > prevsize[1])
                                        {
                                            //gridTrader.Rows[placeind].Cells[colprice].Style.BackColor = Color.Pink;
                                            color = Color.Pink;
                                        }
                                        else if (prevsize[0] < prevsize[1])
                                        {
                                            //gridTrader.Rows[placeind].Cells[colprice].Style.BackColor = Color.LightGreen;
                                            color = Color.LightGreen;
                                        }
                                        else
                                        {
                                            // gridTrader.Rows[placeind].Cells[colprice].Style.BackColor = Color.White;
                                            color = Color.White;
                                        }

                                        CellUpdateColorText(placeind, colprice, null, color);


                                        //SetCell(placeind,3);
                                    }
                                }


                            }
                        }
                    }
                }
                catch { }
                Application.DoEvents();
            }

          
        }


        delegate void SetCellCallback(int row,int col);

        private void SelectCell(int row,int col)
        {
            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (this.gridTrader.InvokeRequired)
            {
                SetCellCallback d = new SetCellCallback(SelectCell);
                this.Invoke(d, new object[] { row,col });
            }
            else
            {
                this.gridTrader.Rows[row].Cells[col].Selected = true;
            }
        }
        delegate void CellUpdateColorTextCallback(int row, int col,string text,Color color);
        private void CellUpdateColorText(int row, int col,string text, Color color)
        {
            if (row < 0) return;
           
            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (this.gridTrader.InvokeRequired)
            {
                CellUpdateColorTextCallback d = new CellUpdateColorTextCallback(CellUpdateColorText);
                this.Invoke(d, new object[] { row, col ,text,color});
            }
            else
            {
                if (row >= gridTrader.RowCount) return;
                if (text != null)
                {
                    this.gridTrader.Rows[row].Cells[col].Value = text;
                }
                this.gridTrader.Rows[row].Cells[col].Style.BackColor = color;


            }
        }

        public void setCellPenny(double midpoint)
        {
            cellPenny = 0.01;
            if (midpoint > 60) cellPenny = 0.02;
            if (midpoint > 100) cellPenny = 0.05;
            if (midpoint > 400) cellPenny = 0.1;
            if (midpoint > 1600) cellPenny = 0.25;
        
        }

        private void handledtickbytickbidask(object sender, EventArgs e)
        {
           // processbidask.WaitOne();
            if (ibWrapper.TickByTickBidAskAvailable())
            {
                try
                {
                    TickByTickBidAskMessage etp = ibWrapper.TickByTickBidAskDQ();
                    if (etp != null)
                    {
                        //Console.WriteLine("Tick-By-Tick. Request Id: {0}, TickType: BidAsk, Time: {1}, BidPrice: {2}, AskPrice: {3}, BidSize: {4}, AskSize: {5}, BidPastLow: {6}, AskPastHigh: {7}",   etp.ReqId, Util.UnixSecondsToString(etp.Time, "yyyyMMdd-HH:mm:ss zzz"), etp.BidPrice, etp.AskPrice, etp.BidSize, etp.AskSize, etp.TickAttribBidAsk.BidPastLow, etp.TickAttribBidAsk.AskPastHigh);
                        // Console.WriteLine("currentTickbytick={0}", currentTickbytick);
                        // use only the most recent ticker id
                        if ((currentTickbytick - 1) == etp.ReqId)
                        {
                            if (pivotvalue == 0)
                            {
                                //wait for a a last value to arrive first, and set it as pivot
                                /*
                                double midpoint = (etp.BidPrice + etp.AskPrice) / 2;
                                 setCellPenny(midpoint);
                                  pivotvalue = (double)(Math.Round(midpoint *cellPenny))/cellPenny;
                                setBidAskGrids(pivotvalue);
                                */
                            }

                            if (pivotvalue > 0)
                            {
                                int wipeind = 0;
                                int placeind = 0;
                                {//bid
                                    double price = etp.BidPrice;
                                    if (price > 0)
                                    {
                                        prevbid = price;
                                        wipeind = penny2ind(price);
                                        //    Console.WriteLine("wipeind={0}", wipeind);
                                        placeind = penny2ind(price);
                                        //      Console.WriteLine("placeind={0}", placeind);
                                        for (int i = wipeind - 1; i > wipeind - 50; i--)
                                        {
                                         //   updateTraderCell(i, colbids, "");
                                            CellUpdateColorText(i, colbids, "", Color.White);
                                        }

                                        //gridTrader.Rows[prevbid_cellindex].Cells[colbids].Style.BackColor = Color.White;
                                        //updateTraderCell(placeind, colbids, etp.BidSize.ToString());
                                        //gridTrader.Rows[placeind].Cells[colbids].Style.BackColor = Color.LightGreen;
                                        //prevbid_cellindex = placeind;
                                        if (prevbid_cellindex != placeind)
                                        {
                                            CellUpdateColorText(prevbid_cellindex, colbids, null, Color.White);
                                        }
                                  
                                        CellUpdateColorText(placeind, colbids, etp.BidSize.ToString(), Color.LightGreen);
                                        prevbid_cellindex = placeind;
                                    }
                                }
                                {//ask
                                    double price = etp.AskPrice;
                                    if (price > 0)
                                    {
                                        prevask = price;
                                        wipeind = penny2ind(price);
                                        // Console.WriteLine("wipeind={0}", wipeind);
                                        placeind = penny2ind(price);
                                        // Console.WriteLine("placeind={0}", placeind);
                                        for (int i = wipeind + 1; i < wipeind + 50; i++)
                                        {
                                           // updateTraderCell(i, colasks, "");
                                            CellUpdateColorText(i, colasks, "", Color.White);
                                        }
                                        /*
                                        gridTrader.Rows[prevask_cellindex].Cells[colasks].Style.BackColor = Color.White;
                                        updateTraderCell(placeind, colasks, etp.AskSize.ToString());
                                        gridTrader.Rows[placeind].Cells[colasks].Style.BackColor = Color.Pink;
                                        prevask_cellindex = placeind;
                                        */
                                        if (prevask_cellindex != placeind)
                                        {
                                            CellUpdateColorText(prevask_cellindex, colasks, null, Color.White);
                                        }
                                        CellUpdateColorText(placeind, colasks, etp.AskSize.ToString(), Color.Pink);
                                        prevask_cellindex = placeind;
                                    }
                                }

                            }
                        }
                    }

                }
                catch (Exception ex)
                {
                    //Console.WriteLine(ex.Message);
                }
                //Application.DoEvents();

            }
           // processbidask.Release();

        }

        private void handletickbytickbidask(TickByTickBidAskMessage etp)
        {

            try
            {
                if (etp != null)
                {
                    //Console.WriteLine("Tick-By-Tick. Request Id: {0}, TickType: BidAsk, Time: {1}, BidPrice: {2}, AskPrice: {3}, BidSize: {4}, AskSize: {5}, BidPastLow: {6}, AskPastHigh: {7}",   etp.ReqId, Util.UnixSecondsToString(etp.Time, "yyyyMMdd-HH:mm:ss zzz"), etp.BidPrice, etp.AskPrice, etp.BidSize, etp.AskSize, etp.TickAttribBidAsk.BidPastLow, etp.TickAttribBidAsk.AskPastHigh);
                    // Console.WriteLine("currentTickbytick={0}", currentTickbytick);
                    // use only the most recent ticker id
                    if ((currentTickbytick - 1) == etp.ReqId)
                    {
                        if (pivotvalue == 0)
                        {
                            //wait for a a last value to arrive first, and set it as pivot
                            /*
                            double midpoint = (etp.BidPrice + etp.AskPrice) / 2;
                             setCellPenny(midpoint);
                              pivotvalue = (double)(Math.Round(midpoint *cellPenny))/cellPenny;
                            setBidAskGrids(pivotvalue);
                            */
                        }

                        if (pivotvalue > 0)
                        {
                            int wipeind = 0;
                            int placeind = 0;
                            {//bid
                                double price = etp.BidPrice;
                                if (price > 0)
                                {
                                    prevbid = price;
                                    wipeind = penny2ind(price);
                                    //    Console.WriteLine("wipeind={0}", wipeind);
                                    placeind = penny2ind(price);
                                    //      Console.WriteLine("placeind={0}", placeind);
                                    for (int i = wipeind - 1; i > wipeind - 50; i--)
                                    {
                                        //   updateTraderCell(i, colbids, "");
                                        CellUpdateColorText(i, colbids, "", Color.White);
                                    }

                                    //gridTrader.Rows[prevbid_cellindex].Cells[colbids].Style.BackColor = Color.White;
                                    //updateTraderCell(placeind, colbids, etp.BidSize.ToString());
                                    //gridTrader.Rows[placeind].Cells[colbids].Style.BackColor = Color.LightGreen;
                                    //prevbid_cellindex = placeind;
                                    if (prevbid_cellindex != placeind)
                                    {
                                        CellUpdateColorText(prevbid_cellindex, colbids, null, Color.White);
                                    }

                                    CellUpdateColorText(placeind, colbids, etp.BidSize.ToString(), Color.LightGreen);
                                    prevbid_cellindex = placeind;
                                }
                            }
                            {//ask
                                double price = etp.AskPrice;
                                if (price > 0)
                                {
                                    prevask = price;
                                    wipeind = penny2ind(price);
                                    // Console.WriteLine("wipeind={0}", wipeind);
                                    placeind = penny2ind(price);
                                    // Console.WriteLine("placeind={0}", placeind);
                                    for (int i = wipeind + 1; i < wipeind + 50; i++)
                                    {
                                        // updateTraderCell(i, colasks, "");
                                        CellUpdateColorText(i, colasks, "", Color.White);
                                    }
                                    /*
                                    gridTrader.Rows[prevask_cellindex].Cells[colasks].Style.BackColor = Color.White;
                                    updateTraderCell(placeind, colasks, etp.AskSize.ToString());
                                    gridTrader.Rows[placeind].Cells[colasks].Style.BackColor = Color.Pink;
                                    prevask_cellindex = placeind;
                                    */
                                    if (prevask_cellindex != placeind)
                                    {
                                        CellUpdateColorText(prevask_cellindex, colasks, null, Color.White);
                                    }
                                    CellUpdateColorText(placeind, colasks, etp.AskSize.ToString(), Color.Pink);
                                    prevask_cellindex = placeind;
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
         

        


        /*
            private void handledticksize(object sender, EventArgs e)
            {
                while (ibWrapper.TickSizeAvailable())
                {
                    IBWrapper.ExtendedTickSizeMessage etp = ibWrapper.TickSizeDQ();
                    if (etp != null)
                    {

                        Console.WriteLine("{0}: ID={3} {1}={2}", etp.dateTime, TickType.getField(etp.tickSizeMessage.Field), etp.tickSizeMessage.Size, etp.tickSizeMessage.RequestId);

                        // use only the most recent ticker id
                        if (IBWrapper.TICK_ID_BASE + (currentTicker) == etp.tickSizeMessage.RequestId)
                        {
                            if (pivotvalue == 0)
                            {

                            }
                            else
                            {
                                int placeind = 0;
                                Console.WriteLine("field={0}, prevbid={1}, prevask={2}", etp.tickSizeMessage.Field, prevbid, prevask);


                                switch (etp.tickSizeMessage.Field)
                                {
                                   case 0: //bid size
                                        if (prevbid > 0)
                                        {
                                            placeind = penny2ind(prevbid);
                                            Console.WriteLine("placeind={0}", placeind);
                                            updateTraderCell(placeind, 1, etp.tickSizeMessage.Size.ToString());
                                        }
                                        break;
                                    case 3://ask size
                                        if (prevask > 0)
                                        {

                                            placeind = penny2ind(prevask);
                                            Console.WriteLine("placeind={0}", placeind);
                                            updateTraderCell(placeind, 3, etp.tickSizeMessage.Size.ToString());
                                        }
                                        break;

                                    case 5: //last size
                                        //this is more complicated as we need to change values
                                        break;



                                }
                            }
                        }

                    }
                }
            }
            */

        private void toolStripTextBoxSymbol_Click(object sender, EventArgs e)
        {

        }

        private void toolStripTextBoxSymbol_KeyPress(object sender, KeyPressEventArgs e)
        {
           
        }

        private void toolStripTextBoxSymbol_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode== Keys.Enter)
            {
                pivotvalue = 0;
                cellPenny = 0.01;
                removePreviousTickers();

                for (int i=0;i<gridsize;i++)
                {
                    for (int j = 0; j < 6; j++)
                        updateTraderCell(i, j, "");
                  
                }

                string symbol = toolStripTextBoxSymbol.Text;
                Contract contract = ContractDefinition.Tools.getGenericContract(symbol);
                //currentTicker++;
                // int nextReqId = IBWrapper.TICK_ID_BASE + (currentTicker);
                //ibClient.ClientSocket.reqMktData(nextReqId, contract, "", false, false, new List<TagValue>());
                currentTickbytick++;
                int nextReqId = currentTickbytick;
                string ticktype = "BidAsk"; //Last, AllLast
                ibClient.ClientSocket.reqTickByTickData(nextReqId, contract, ticktype, 0, false);
                currentTickbytick++;
                nextReqId = currentTickbytick;
                ticktype = "AllLast"; //Last, AllLast
                ibClient.ClientSocket.reqTickByTickData(nextReqId, contract, ticktype, 0, false);
                
            }
        }

        public void removePreviousTickers()
        {
            for (int i=0;i<= currentTickbytick; i++)
            {
               // ibClient.ClientSocket.cancelMktData(i);
                ibWrapper.ibClient.ClientSocket.cancelTickByTickData(i);

            }
            currentTickbytick = 0;
        }

        private void gridTrader_CellPainting(object sender, DataGridViewCellPaintingEventArgs e)
        {
            bool correctid = e.ColumnIndex == 0 || e.ColumnIndex == 1;
            if (correctid && e.RowIndex >= 0)
            {
                e.PaintBackground(e.CellBounds, true);
                TextRenderer.DrawText(e.Graphics, e.FormattedValue.ToString(),
                e.CellStyle.Font, e.CellBounds, e.CellStyle.ForeColor,
                 TextFormatFlags.RightToLeft | TextFormatFlags.Right);
                e.Handled = true;
            }

            correctid = e.ColumnIndex == 2;
            if (correctid && e.RowIndex >= 0)
            {
                e.PaintBackground(e.CellBounds, true);
                TextRenderer.DrawText(e.Graphics, e.FormattedValue.ToString(),
                e.CellStyle.Font, e.CellBounds, e.CellStyle.ForeColor,
                  TextFormatFlags.HorizontalCenter);
                e.Handled = true;
            }
        }

        private void gridTrader_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void toolStripButtonRecenter_Click(object sender, EventArgs e)
        {
            pivotvalue = 0;
            cellPenny = 0.01;
        }

        private void settingsToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }
    }
}
