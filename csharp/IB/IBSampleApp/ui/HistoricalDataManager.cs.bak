/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms.DataVisualization.Charting;
using IBApi;
using IBSampleApp.messages;
using System.Globalization;
using System.Windows.Forms;
using MHA;
using System.Threading;

namespace IBSampleApp.ui
{
    class HistoricalDataManager : DataManager
    {
        private bool cumvol = false;
        public class HistoricalDataDefinition
        {
            

            public string currentKey="";

            public int lastusedreqid = -1;
            public Dictionary<string, int> historicalDataMap = new Dictionary<string, int>();
            public Dictionary<int,HistoricalDataMessageManager> historicalDataMessageManagers = new Dictionary<int, HistoricalDataMessageManager>();

            public class HistoricalDataMessageManager
            {
                public List<HistoricalDataMessage> historicalData=new List<HistoricalDataMessage>();
                public double chartPriceMin = 10000;
                public double chartPriceMax = 0;

                
            }
        }

        public HistoricalDataDefinition historicalDataDefinition=new HistoricalDataDefinition();


        public const int HISTORICAL_ID_BASE = 30000000;

        private string fullDatePattern = "yyyyMMdd  HH:mm:ss";
        private string yearMonthDayPattern = "yyyyMMdd";

        protected int barCounter = -1;
        protected DataGridView gridView;

        public double chartMin
        {
            get
            {
                return historicalDataDefinition.historicalDataMessageManagers[historicalDataDefinition.historicalDataMap[historicalDataDefinition.currentKey]].chartPriceMin;
            }
            set
            {
                historicalDataDefinition.historicalDataMessageManagers[historicalDataDefinition.historicalDataMap[historicalDataDefinition.currentKey]].chartPriceMin = value;
            }
        }

        public double chartMax
        {
            get
            {
                return historicalDataDefinition.historicalDataMessageManagers[historicalDataDefinition.historicalDataMap[historicalDataDefinition.currentKey]].chartPriceMax;
            }
            set
            {
                historicalDataDefinition.historicalDataMessageManagers[historicalDataDefinition.historicalDataMap[historicalDataDefinition.currentKey]].chartPriceMax = value;
            }
        }
        Chart historicalChart=null;
        public HistoricalDataManager(IBClient ibClient, Chart chart, DataGridView gridView) : base(ibClient, chart) 
        {
           historicalChart = (Chart)uiControl;
            historicalChart.Series[0]["PriceUpColor"] = "Green";
            historicalChart.Series[0]["PriceDownColor"] = "Red";
            this.gridView = gridView;
        }

        public void AddRequest(Contract contract, string endDateTime, string durationString, string barSizeSetting, string whatToShow, int useRTH, int dateFormat, bool keepUpToDate)
        {
            Clear();
            historicalDataDefinition.currentKey = ContractDefinition.Tools.uniqueKey(contract);
            if (!historicalDataDefinition.historicalDataMap.ContainsKey(historicalDataDefinition.currentKey))
            {

                ibClient.ClientSocket.reqHistoricalData(currentTicker + HISTORICAL_ID_BASE, contract, endDateTime, durationString, barSizeSetting, whatToShow, useRTH, 1, keepUpToDate, new List<TagValue>());
                historicalDataDefinition.lastusedreqid = currentTicker + HISTORICAL_ID_BASE;
    

                historicalDataDefinition.historicalDataMap.Add(historicalDataDefinition.currentKey, historicalDataDefinition.lastusedreqid);
                historicalDataDefinition.historicalDataMessageManagers.Add(historicalDataDefinition.lastusedreqid, new HistoricalDataDefinition.HistoricalDataMessageManager());
                HistoricalDataDefinition.HistoricalDataMessageManager manager = historicalDataDefinition.historicalDataMessageManagers[historicalDataDefinition.lastusedreqid];
                manager.chartPriceMax = 0;
                manager.chartPriceMin = 20000;
                currentTicker++;
            }
            else
            {
                historicalDataDefinition.lastusedreqid = historicalDataDefinition.historicalDataMap[historicalDataDefinition.currentKey];

                //update graph
                PaintChart();
            }
        }

        public override void Clear()
        {
            barCounter = -1;
           
            historicalChart.Series[0].Points.Clear();
            historicalChart.Series[1].Points.Clear();
            historicalChart.Annotations.Clear();
            gridView.Rows.Clear();
            //historicalData = new List<HistoricalDataMessage>();
        }

        public override void NotifyError(int requestId)
        {
        }

        Semaphore _pool_historical = new Semaphore(1, 1);
        public void UpdateHistoricalData(HistoricalDataMessage message)
        {
            //_pool_historical.WaitOne();
            try
            {

                if (!historicalDataDefinition.historicalDataMessageManagers.ContainsKey(message.RequestId)) return;
                if (message.Low < 0.1) return;
                if (message.High < 0.1) return;
                if (message.Close < 0.1) return;
                if (message.Open < 0.1) return;
                HistoricalDataDefinition.HistoricalDataMessageManager manager = historicalDataDefinition.historicalDataMessageManagers[message.RequestId];
                //cannot simply add here because the point might be merely updated
                int lastindex = manager.historicalData.Count - 1;

                double minimumerror = manager.historicalData[lastindex].Low / 10;
                if (minimumerror > message.Close) return;
                if (minimumerror > message.High) return;
                if (minimumerror > message.Low) return;
                if (minimumerror > message.Open) return;

                if (lastindex >= 0)
                {

                    manager.chartPriceMin = Math.Min(manager.chartPriceMin, message.Low);
                    manager.chartPriceMax = Math.Max(manager.chartPriceMax, message.High);

                    if (manager.historicalData[lastindex].Date.Equals(message.Date))
                    {
                        manager.historicalData[lastindex].Close = message.Close;
                        manager.historicalData[lastindex].High = Math.Max(manager.historicalData[lastindex].High, message.High);
                        manager.historicalData[lastindex].Low = Math.Min(manager.historicalData[lastindex].Low, message.Low);
                        manager.historicalData[lastindex].Date = message.Date;

                        manager.historicalData[lastindex].Volume = message.Volume;

                        manager.historicalData[lastindex].Wap = message.Wap;


                        if (historicalDataDefinition.historicalDataMap[historicalDataDefinition.currentKey] == message.RequestId)
                        {
                            updatePoint(lastindex, manager.historicalData[lastindex]);
                        }
                    }
                    else
                    {

                        manager.historicalData.Add(message);
                        if (historicalDataDefinition.historicalDataMap[historicalDataDefinition.currentKey] == message.RequestId)
                        {
                            addPoint(message);
                        }
                    }
                    if (historicalDataDefinition.historicalDataMap[historicalDataDefinition.currentKey] == message.RequestId)
                    {
                        // historicalChart = (Chart)uiControl;
                        double dis = (manager.chartPriceMax - manager.chartPriceMin) * .2;
                       // Console.WriteLine("AxisY limits:{0},{1}", manager.chartMin - dis, manager.chartMax + dis);
                        historicalChart.ChartAreas[0].AxisY.Maximum = manager.chartPriceMax + dis;
                        historicalChart.ChartAreas[0].AxisY.Minimum = manager.chartPriceMin - dis;
                    }

                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
           // _pool_historical.Release();
        }

        /*
         *   public void UpdateHistoricalData(HistoricalDataMessage message)
        {
            if (message.RequestId != lastusedreqid) return;

            //cannot simply add here because the point might be merely updated
            int lastindex = historicalData.Count - 1;
            if (lastindex >= 0)
            {

                chartMin = Math.Min(chartMin, message.Low );
                chartMax = Math.Max(chartMax, message.High );

                if (historicalData[lastindex].Date.Equals(message.Date))
                {
                    //update
                    double open = historicalData[lastindex].Open;
                    double high = historicalData[lastindex].High;
                    double low = historicalData[lastindex].Low;

                    historicalData[lastindex] = message;
                    historicalData[lastindex].Open = open;
                    historicalData[lastindex].High = Math.Max(historicalData[lastindex].High, high);
                    historicalData[lastindex].Low = Math.Min(historicalData[lastindex].Low, low);


                    //  Console.WriteLine("vol={0}", historicalData[lastindex].Volume);
                    updatePoint(lastindex, historicalData[lastindex]);
                }
                else
                {
                   
                    historicalData.Add(message);
                    addPoint(message);
                }
                historicalChart = (Chart)uiControl;
                double dis = (chartMax - chartMin)*.1;

                historicalChart.ChartAreas[0].AxisY.Maximum = chartMax+dis;
                historicalChart.ChartAreas[0].AxisY.Minimum = chartMin-dis;
            }
        }
        */

        public void AddHistoricalData(HistoricalDataMessage message)
        {
            if (!historicalDataDefinition.historicalDataMessageManagers.ContainsKey(message.RequestId)) return;// if (message.RequestId != lastusedreqid) return;
            HistoricalDataDefinition.HistoricalDataMessageManager manager = historicalDataDefinition.historicalDataMessageManagers[message.RequestId];
            if (manager.historicalData.Count > 5)
            {
                int lastindex = manager.historicalData.Count - 1;
                double minimumerror = manager.historicalData[lastindex].Low / 10;
                if (minimumerror > message.Close) return;
                if (minimumerror > message.High) return;
                if (minimumerror > message.Low) return;
                if (minimumerror > message.Open) return;
            }


            manager.historicalData.Add(message);
        }

        public void UpdateUI(HistoricalDataEndMessage message)
        {
            if (!historicalDataDefinition.historicalDataMessageManagers.ContainsKey(message.RequestId)) return;//if (message.RequestId != lastusedreqid) return;
            PaintChart();
        }

        private void addPoint(HistoricalDataMessage hd)
        {
            DateTime dt;

           // historicalChart = (Chart)uiControl;
            if (hd.Date.Length == fullDatePattern.Length)
                DateTime.TryParseExact(hd.Date, fullDatePattern, null, DateTimeStyles.None, out dt);
            else if (hd.Date.Length == yearMonthDayPattern.Length)
                DateTime.TryParseExact(hd.Date, yearMonthDayPattern, null, DateTimeStyles.None, out dt);
            else
                return;

            // adding date and high

            double prevol = 0;
            if (cumvol && historicalChart.Series[1].Points.Count>0)
            {
                prevol = historicalChart.Series[1].Points[historicalChart.Series[1].Points.Count - 1].YValues[0];
            }

            historicalChart.Series[1].Points.AddXY(dt, prevol + hd.Volume * 100);
            historicalChart.Series[0].Points.AddXY(dt, hd.High,hd.Low,hd.Open,hd.Close);
            
            //int i = historicalChart.Series[0].Points.Count - 1;
            // adding low
            //historicalChart.Series[0].Points[i].YValues[1] = hd.Low;
            //adding open
           // historicalChart.Series[0].Points[i].YValues[2] = hd.Open;
            // adding close
           // historicalChart.Series[0].Points[i].YValues[3] = hd.Close;
           // PopulateGrid(hd);
        }

        private void updatePoint(int i, HistoricalDataMessage hd)
        {
            // historicalChart = (Chart)uiControl;
            try
            {
                double prevol = 0;
                if (cumvol && i > 0)
                {
                    prevol = historicalChart.Series[1].Points[i - 1].YValues[0];
                }
                historicalChart.Series[1].Points[i].YValues[0] = prevol+ hd.Volume * 100;
            }catch { }
            try
            {
                historicalChart.Series[0].Points[i].YValues[0] = hd.High;
                historicalChart.Series[0].Points[i].YValues[1] = hd.Low;
                historicalChart.Series[0].Points[i].YValues[2] = hd.Open;
                historicalChart.Series[0].Points[i].YValues[3] = hd.Close;
            }
            catch { }
            
           // PopulateGrid(hd,i);
            //historicalChart.Update();
            historicalChart.Refresh();
            Application.DoEvents();
          
        }



        private void PaintChart()
        {
           // historicalChart = (Chart)uiControl;
            HistoricalDataDefinition.HistoricalDataMessageManager manager = historicalDataDefinition.historicalDataMessageManagers[historicalDataDefinition.historicalDataMap[historicalDataDefinition.currentKey]];

            for (int i = 0; i < manager.historicalData.Count; i++)
            {
                HistoricalDataMessage message = manager.historicalData[i];

                manager.chartPriceMin = Math.Min(manager.chartPriceMin, message.Low );
                manager.chartPriceMax = Math.Max(manager.chartPriceMax, message.High );

                addPoint(message);
            }
            double dis = (manager.chartPriceMax - manager.chartPriceMin) * .2;
            
            historicalChart.ChartAreas[0].AxisY.Maximum = manager.chartPriceMax + dis;
            historicalChart.ChartAreas[0].AxisY.Minimum = manager.chartPriceMin - dis;

        }

        protected void PopulateGrid(HistoricalDataMessage bar, int index = -1)
        {            
           
            if (index == -1)
            {
                gridView.Rows.Add(1);
                index = gridView.Rows.Count - 1;
            }
            try
            {
                gridView[0, index].Value = bar.Date;
                gridView[1, index].Value = bar.Open;
                gridView[2, index].Value = bar.High;
                gridView[3, index].Value = bar.Low;
                gridView[4, index].Value = bar.Close;
                gridView[5, index].Value = bar.Volume;
                gridView[6, index].Value = bar.Wap;
            }catch { }
        }
    }
}
