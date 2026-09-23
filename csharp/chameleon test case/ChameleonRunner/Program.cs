using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using NUnit.Framework;
using System.Threading;
using MHA;
using NUnit.Framework.Constraints;
using System.Linq.Expressions;
using System.Xml.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Runtime.Serialization;
using Selenium.WebDriver.Extensions;

namespace ChameleonRunner
{
    class Program
    {
        private IWebDriver driver;
        public string homeURL;
        bool working = true;
        string dumpfilename;
        WebDriverWait wait;

        ChameleonOptionsTable cot = new ChameleonOptionsTable();
        static void Main(string[] args)
        {
            string dumpfilename = "";
            if (args.Count() != 1)
            {

                //Console.WriteLine("ChameleonRunner.exe dumplocation");
                //return;
                dumpfilename=String.Concat(  Directory.GetCurrentDirectory(),@"\","temp ",DateTime.Now.ToString("yyyy-MM-dd")," .bin");


            }
            else
            {
                dumpfilename = args[0];
            }



            Program p = new Program();
            try
            {
                p.setup(dumpfilename);

                //now loop through pages, and grab data
                p.loop();

                p.save();

                p.driver.Close();
                p.driver.Dispose();
                
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.StackTrace);
            }

           // Console.ReadKey();
        }

        public void save()
        {
            FileStream fs = new FileStream(dumpfilename, FileMode.Create);
            BinaryFormatter formatter = new BinaryFormatter();
            try
            {
                formatter.Serialize(fs, cot);
            }
            catch (SerializationException e)
            {
                Console.WriteLine("Failed to serialize. Reason: " + e.Message);
                throw;
            }
            finally
            {
                fs.Close();
            }
        }

        public ChameleonOptionsTable.OptionsTable parseChameleonRow(string rs)
        {

            ChameleonOptionsTable.OptionsTable ot = new ChameleonOptionsTable.OptionsTable();
            ot.chameleonRow = rs;
            string[] spaces2=null;
            try
            {
                rs = rs.Replace("\r", "");

                string[] returns = rs.Split(new char[] { '\n' });
                if (returns.Count() != 3) return ot;

                string[] spaces0 = returns[0].Split(new char[] { ' ' });
                //sanity
                if (spaces0.Count() != 4) return ot;
                if (!spaces0[0].Equals("Open")) return ot;
                if (!spaces0[1].Equals("+")) return ot;

                ot.Time = String.Concat(spaces0[2], " ", spaces0[3]);

                ot.Symbol = returns[1];

                spaces2 = returns[2].Split(new char[] { ' ' });

                int cnt = 0;
                if (spaces2.Count() < 24) return ot;
                ot.OptionExpiration = spaces2[cnt++];
                ot.Type = spaces2[cnt++];
                ot.Strike = Double.Parse(spaces2[cnt++]);
                ot.SpotPrice = Double.Parse(spaces2[cnt++]);
                ot.OpenInterest = Int32.Parse(spaces2[cnt++].Replace(",", ""));
                ot.TradeQty = Int32.Parse(spaces2[cnt++].Replace(",",""));
                ot.TradePrice = Double.Parse(spaces2[cnt++]);
                ot.Bid = Double.Parse(spaces2[cnt++]);
                ot.Ask = Double.Parse(spaces2[cnt++]);
                int notionalbase = 1;
                if (spaces2[cnt+1].Equals("K")) notionalbase = 1000;
                if (spaces2[cnt+1].Equals("M")) notionalbase = 1000000;
                ot.TradeNotional = Double.Parse(spaces2[cnt++].Replace("$","")) * notionalbase;
                cnt++;
                ot.Side = (spaces2[cnt++]);
                ot.TradeIV = Double.Parse(spaces2[cnt++]);
                double num;
                if (!double.TryParse(spaces2[cnt], out num))
                {
                    // It's not a number!
               
                    ot.IVChg = 0;
                }
                else
                {
                    ot.IVChg = Double.Parse(spaces2[cnt++]);
                }

                ot.IVRank = 0;
                
                if (spaces2[cnt].Contains("%"))
                {
                    ot.IVRank = Double.Parse(spaces2[cnt++].Replace("%", "")) / 100;
                }

                ot.Exch = (spaces2[cnt++]);
                ot.Condition = (spaces2[cnt++]);
                ot.Execution = "";

                for (int ei = 0; ei < 5; ei++)
                {
                    try
                    {
                        Double.Parse(spaces2[cnt]);
                    }
                    catch (Exception ex)
                    {
                        ot.Execution = String.Concat(ot.Execution," ",(spaces2[cnt++]));
                    }
                }
                try
                {
                    ot.Delta = Double.Parse(spaces2[cnt++]);
                    ot.BidAskSpread = Double.Parse(spaces2[cnt++]);
                    ot.TradeEdge = Double.Parse(spaces2[cnt++]);
                    ot.HistVol20Day = Double.Parse(spaces2[cnt++]);
                    ot.IVvsHV20day = Double.Parse(spaces2[cnt++].Replace("%", "")) / 100;
                    ot.HistVol1Yr = Double.Parse(spaces2[cnt++]);

                    ot.IVvsHV1Yr = Double.Parse(spaces2[cnt++].Replace("%", "")) / 100;
                    ot.QtyPercentAvgVolume = Double.Parse(spaces2[cnt++].Replace("%", "")) / 100;
                    ot.DaysToExp = Int32.Parse(spaces2[cnt++]);
                }
                catch { }
                ot.Event = "";
                if (spaces2.Length > cnt)
                {
                    ot.Event = (spaces2[cnt]);
                }
                else
                {
                    ot.Event = "";
                }





                
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.WriteLine(ex.StackTrace);
            }

            return ot;
        }

        public void loop()
        {
            //loop
            IWebElement we = null;
            IReadOnlyList<IWebElement> werows = null;
         //   IReadOnlyList<IWebElement> wecols = null;
            int currentpage = 1;
            string xpath;
            bool hasnextpage = true;
            do
            {
                Thread.Sleep(2000);
                xpath = "//table[@id='opt_trades_screener_tbl']//tr";
                wait.Until(ExpectedConditions.ElementExists(OpenQA.Selenium.By.XPath(xpath)));
                werows = driver.FindElements(OpenQA.Selenium.By.XPath(xpath));
                string[] rs = new string[werows.Count];
                for (int i = 0; i < werows.Count; i++)
                {
                    try
                    {
                        rs[i] = werows[i].Text;
                    }
                    catch (Exception ex) 
                    {
                        Console.WriteLine(ex.Message);
                        Console.WriteLine(ex.StackTrace);
                    }
                }
               
                // werows = we.FindElements(By.XPath("//tr"));
              
                for (int r=0;r<werows.Count();r++)
                {
                    try
                    {
                        if (String.IsNullOrEmpty(rs[r])) continue;


                        ChameleonOptionsTable.OptionsTable ot = parseChameleonRow(rs[r]);
                        cot.optionsTables.Add(ot);

                        //if (ss == null) continue;

                        /*
                        for (int c=0;c< ss.Count();c++)
                        {
                            try
                            {
                                int cc = c % 30;


                                if (cc == 0) cot.optionsTables[r].Details = new ChameleonOptionsTable.OptionsTable.OpenDetails();

                                if (cc == 1) cot.optionsTables[r].Time = ss[c];
                                if (cc == 2) cot.optionsTables[r].Symbol = ss[c];
                                if (cc == 3) cot.optionsTables[r].OptionExpiration = ss[c];
                                if (cc == 4) cot.optionsTables[r].Type = ss[c];
                                if (cc == 5) cot.optionsTables[r].Strike = Double.Parse(ss[c]);
                                if (cc == 6) cot.optionsTables[r].SpotPrice = Double.Parse(ss[c]);
                                if (cc == 7) cot.optionsTables[r].OpenInterest = Int32.Parse(ss[c].Replace(",", ""));
                                    if (cc == 8) cot.optionsTables[r].TradeQty = Int32.Parse(ss[c]);
                                if (cc == 9) cot.optionsTables[r].TradePrice = Double.Parse(ss[c]);
                                if (cc == 10) cot.optionsTables[r].Bid = Double.Parse(ss[c]);
                                if (cc == 11) cot.optionsTables[r].Ask = Double.Parse(ss[c]);
                                if (cc == 12)
                                {
                                    string[] splits = ss[c].Split(new char[] { ' ' });
                                    int basen = Int32.Parse(splits[0]);
                                    if (splits[1].Equals("K")) basen *= 1000;
                                    if (splits[1].Equals("M")) basen *= 1000000;

                                    cot.optionsTables[r].TradeNotional = basen;
                                        }
                                    if (cc == 13) cot.optionsTables[r].Side = ss[c];
                                if (cc == 14) cot.optionsTables[r].TradeIV = Double.Parse(ss[c]);
                                if (cc == 15) cot.optionsTables[r].IVChg = Double.Parse(ss[c]);
                                if (cc == 16) cot.optionsTables[r].IVRank = Double.Parse( ss[c].Replace("%", ""));
                                    if (cc == 17) cot.optionsTables[r].Exch = ss[c];
                                if (cc == 18) cot.optionsTables[r].Condition = ss[c];
                                if (cc == 19) cot.optionsTables[r].Execution = ss[c];
                                if (cc == 20) cot.optionsTables[r].Delta = Double.Parse(ss[c]);
                                if (cc == 21) cot.optionsTables[r].BidAskSpread = Double.Parse(ss[c]);
                                if (cc == 22) cot.optionsTables[r].TradeEdge = Double.Parse(ss[c]);
                                if (cc == 23) cot.optionsTables[r].HistVol20Day = Double.Parse(ss[c]);
                                if (cc == 24) cot.optionsTables[r].IVvsHV20day = Double.Parse(ss[c].Replace("%", ""));
                                if (cc == 25) cot.optionsTables[r].HistVol1Yr = Double.Parse(ss[c]);
                                if (cc == 26) cot.optionsTables[r].IVvsHV1Yr = Double.Parse(ss[c].Replace("%", ""));
                                if (cc == 27) cot.optionsTables[r].QtyPercentAvgVolume = Double.Parse(ss[c].Replace("%", ""));
                                if (cc == 28) cot.optionsTables[r].DaysToExp = Int32.Parse(ss[c]);
                                if (cc == 29) cot.optionsTables[r].Event = ss[c];
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine(ex.Message);
                            }
                        }
                        */
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                        Console.WriteLine(ex.StackTrace);
                    }

                }

                //next page
               
                try
                {
                    currentpage++;
                    Thread.Sleep(1000);
                    // xpath = String.Concat("//a[@data-dt-idx='7']");
                    // IWebElement ww= driver.FindElement(By.XPath(xpath));
                    xpath = String.Concat("//a[@class='paginate_button next']");
                    IWebElement wec= driver.FindElement(OpenQA.Selenium.By.XPath(xpath));
                    //wec.Click();
                    driver.ExecuteScript("arguments[0].click();", wec);
                    Thread.Sleep(500);
                    hasnextpage = true;
                   
                }
                catch (Exception ex)

                {
                    Console.WriteLine("next click:{0})",ex.Message);
                    hasnextpage = false;
                }
                

            } while (hasnextpage);

            for (int i=0;i<cot.optionsTables.Count();i++)
            {
               Console.WriteLine(cot.optionsTables[i].BasicInfo());
            }

        }

        public void setup(string filename)
        {
            dumpfilename = filename;
            IReadOnlyList<IWebElement> ws;
            IWebElement w;
            string xpath;

            var options = new ChromeOptions();
            options.AddExcludedArguments(new List<string>() { "enable-automation" });
            options.AddArguments(new List<string>() { "--user-agent=Chrome/85.0.4183.87", "--disable-blink-features=AutomationControlled" });

            driver = new ChromeDriver(options);
            Thread.Sleep(500);

            homeURL = "https://marketchameleon.com/Screeners/OptionTrades";
            driver.Navigate().GoToUrl(homeURL);
            wait = new WebDriverWait(driver,
                  System.TimeSpan.FromSeconds(15));
           
            try
            {
                xpath = "//select[@name='opt_trades_screener_tbl_length']";
                wait.Until(ExpectedConditions.ElementExists(OpenQA.Selenium.By.XPath(xpath)));
                Thread.Sleep(500);
                driver.FindElement(OpenQA.Selenium.By.XPath(xpath)).SendKeys("100");
            }
            catch (Exception ex) 
            {
                Console.WriteLine("select size:{0}", ex.Message);
            }
            /*
            try
            { 
            Thread.Sleep(250);
            xpath = "//th[contains(text(),'Notional')]";
            IWebElement wtemp= driver.FindElement(By.XPath(xpath));
            wtemp.Click();
            Thread.Sleep(500);
            wtemp.Click();
            }
            catch (Exception ex) { }
            */

            Thread.Sleep(1000);


        }

    }
}
