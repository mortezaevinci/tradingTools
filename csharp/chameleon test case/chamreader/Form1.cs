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
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;
using System.IO;
using System.Linq.Expressions;

namespace chamreader
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();
        }

        public class notationaldata
        {
           public double bullish=0;
            public double bearish=0;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            DialogResult dr= ofd.ShowDialog();

            if (dr== DialogResult.OK)
            {
                ChameleonOptionsTable cot = readSelledBinfile(ofd.FileName);

                fillGrids(cot);
            }



        }


        private void fillGrids(ChameleonOptionsTable cot)
        {

            Dictionary<string, double> notationalTotal = new Dictionary<string, double>();
            Dictionary<string, notationaldata> notationalDir = new Dictionary<string, notationaldata>();

            int r = -1;
            foreach (ChameleonOptionsTable.OptionsTable ot in cot.optionsTables)
            {
                try
                {
                    grid1.Rows.Add();
                    r++;
                    grid1.Rows[r].Cells[0].Value = ot.Time;
                    grid1.Rows[r].Cells[1].Value = ot.Symbol;
                    grid1.Rows[r].Cells[2].Value = ot.Type;
                    grid1.Rows[r].Cells[3].Value = ot.OptionExpiration;
                    grid1.Rows[r].Cells[4].Value = ot.Strike;
                    grid1.Rows[r].Cells[5].Value = ot.Side;
                    grid1.Rows[r].Cells[6].Value = ot.TradeNotional;

                    string key = String.Concat(ot.Symbol, ",", ot.Type, ",", ot.OptionExpiration, ",", ot.Side);
                    if (notationalTotal.ContainsKey(key))
                    {
                        notationalTotal[key] = notationalTotal[key] + ot.TradeNotional;
                    }
                    else
                    {
                        notationalTotal.Add(key, ot.TradeNotional);
                    }

                    bool? bullish = null;
                    if (ot.Type == null) continue;

                    if (ot.Type.Equals("CALL") && (ot.Side.Equals("Above") || ot.Side.Equals("Ask"))) bullish = true;
                    if (ot.Type.Equals("PUT") && (ot.Side.Equals("Below") || ot.Side.Equals("Bid"))) bullish = true;
                    if (ot.Type.Equals("CALL") && (ot.Side.Equals("Below") || ot.Side.Equals("Bid"))) bullish = false;
                    if (ot.Type.Equals("PUT") && (ot.Side.Equals("Above") || ot.Side.Equals("Ask"))) bullish = false;

                    if (bullish != null)
                    {
                        key = String.Concat(ot.Symbol);
                        if (notationalDir.ContainsKey(key))
                        {
                            if (bullish == true)
                                notationalDir[key].bullish = notationalDir[key].bullish + ot.TradeNotional;
                            else
                                notationalDir[key].bearish = notationalDir[key].bearish + ot.TradeNotional;
                        }
                        else
                        {
                            notationalDir.Add(key, new notationaldata());
                            if (bullish == true)
                                notationalDir[key].bullish = ot.TradeNotional;
                            else
                                notationalDir[key].bearish = ot.TradeNotional;
                        }
                    }

                }
                catch
                { }
            }

            for (int n = 0; n < notationalTotal.Count; n++)
            {
                gridtotal.Rows.Add();
                gridtotal.Rows[n].Cells[0].Value = notationalTotal.Keys.ElementAt(n);
                gridtotal.Rows[n].Cells[1].Value = notationalTotal.Values.ElementAt(n);
            }

            for (int n = 0; n < notationalDir.Count; n++)
            {
                gridDir.Rows.Add();
                gridDir.Rows[n].Cells[0].Value = notationalDir.Keys.ElementAt(n);
                notationaldata nd = notationalDir.Values.ElementAt(n);
                gridDir.Rows[n].Cells[1].Value = 100 * nd.bullish / (nd.bullish + nd.bearish);
                gridDir.Rows[n].Cells[2].Value = (nd.bullish + nd.bearish);
            }
        }

        private ChameleonOptionsTable readSelledBinfile(string dumpfilename)
        {
            ChameleonOptionsTable cot;

            //string dumpfilename = String.Concat(Directory.GetCurrentDirectory(), @"\", "temp ", DateTime.Now.ToString("yyyy-MM-dd"), " .bin");
            FileStream fs = new FileStream(dumpfilename, FileMode.Open);
            try
            {
                BinaryFormatter formatter = new BinaryFormatter();

                // Deserialize the hashtable from the file and
                // assign the reference to the local variable.
                cot = (ChameleonOptionsTable)formatter.Deserialize(fs);
            }
            catch (SerializationException e)
            {
                Console.WriteLine("Failed to deserialize. Reason: " + e.Message);
                throw;
            }
            finally
            {
                fs.Close();
            }
            /*
            for (int i = 0; i < cot.optionsTables.Count(); i++)
            {
                Console.WriteLine(cot.optionsTables[i].BasicInfo());
            }
            */

            return cot;
        }

        private void B_readCsv_Click(object sender, EventArgs e)
        {
            OpenFileDialog ofd = new OpenFileDialog();
            DialogResult dr = ofd.ShowDialog();

            if (dr == DialogResult.OK)
            {
                ChameleonOptionsTable cot=new ChameleonOptionsTable();
               // using (var reader = new StreamReader(ofd.FileName))
                {
                    List<string> lines = File.ReadAllLines(ofd.FileName).ToList();// reader.ReadToEnd();
                    //string[] lines=all.Split('\n');

                    DateTime d0 = DateTime.Now;

                    foreach(string line in lines)//while (!reader.EndOfStream)
                    {
                        //string line = reader.ReadLine();
                        string[] values = line.Split(',');

                        if (values.Length < 30) continue;

                        if (values[0].Equals("Time"))
                        {
                            //headers
                            continue;
                        }
                        ChameleonOptionsTable.OptionsTable ot = new ChameleonOptionsTable.OptionsTable();
                        int cnt = 0;
                        string temps;
                        ot.Time = values[cnt++];
                        ot.Symbol = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        ot.OptionExpiration = values[cnt++];
                        ot.Type = values[cnt++];
                        ot.Strike = Double.Parse(values[cnt++]);
                        ot.SpotPrice = Double.Parse(values[cnt++]);
                        ot.OpenInterest = Int32.Parse(values[cnt++]);
                        temps = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        ot.TradeQty = Int32.Parse(values[cnt++]);
                        ot.TradePrice = Double.Parse(values[cnt++]);
                        temps = values[cnt++];
                        ot.Bid = Double.Parse(values[cnt++]);
                        ot.Ask = Double.Parse(values[cnt++]);
                        temps = values[cnt++];
                        ot.TradeNotional = Double.Parse(values[cnt++]);
                        ot.Side = values[cnt++];
                   
                       
                        temps = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        try // could be empty
                        {
                            ot.TradeIV = Double.Parse(values[cnt]);
                        }
                        catch { }
                        cnt++;
                        try // could be empty
                        {
                            ot.IVChg = Double.Parse(values[cnt]);
                        }
                        catch { }
                        cnt++;
                        try // could be empty
                        {
                            ot.IVRank = Double.Parse(values[cnt]);
                        }
                        catch { }
                        cnt++;
                        ot.Exch = values[cnt++];
                        ot.Condition = values[cnt++];
                        ot.Execution = values[cnt++];
                        ot.Delta = Double.Parse(values[cnt++]);
                        ot.BidAskSpread = Double.Parse(values[cnt++]);
                        ot.TradeEdge = Double.Parse(values[cnt++]);
                        ot.HistVol20Day = Double.Parse(values[cnt++]);
                        ot.IVvsHV20day = Double.Parse(values[cnt++]);
                        ot.HistVol1Yr = Double.Parse(values[cnt++]);
                        ot.IVvsHV1Yr = Double.Parse(values[cnt++]);
                        temps = values[cnt++];
                        ot.QtyPercentAvgVolume = Double.Parse(values[cnt++]);
                        ot.DaysToExp = Int32.Parse(values[cnt++]);
                        ot.Event = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        temps = values[cnt++];
                        cot.optionsTables.Add(ot);


                        if ((DateTime.Now-d0).TotalSeconds>30)
                        {
                            Application.DoEvents();
                            d0 = DateTime.Now;
                        }
                    }
                }

                fillGrids(cot);

            }
        }
    }
}
