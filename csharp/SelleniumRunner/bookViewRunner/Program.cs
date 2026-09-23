using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using NUnit.Framework;
using System.Threading;
using System.IO;

namespace MHA
{
    class Program
    {
        private IWebDriver driver;
        public string homeURL;
        bool working = true;
        public static void Main(string[] args)
        {
            if (args.Count()>4)
            {
                Console.WriteLine("bookviewrunner.exe commaSeparatedSymbols filterlimit sleeplimit c:\\data\\directory\\");
                //if (args.Count()>0)
                //Console.WriteLine(args[0]);
                return;
            }
            string[] symbols =null;
            string filterlimit ="50";
            int overallSleepTime=60000;
            string directory =null;

            if (args.Count() == 4)
            {
                symbols = args[0].Split(new char[] { ',' });
                filterlimit = args[1];
                overallSleepTime = Int32.Parse(args[2]);
                directory = args[3]; 
                directory = String.Concat(directory.TrimEnd(new char[] { '"' }), "\\");
            }

          

            string window="";

            Program p = new Program();
            try
            {
                if (symbols == null)
                {
                    window = p.setupBookViewer(null, filterlimit);
                }
                else
                {
                    window = p.setupBookViewer(symbols[0], filterlimit);
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));
            }

            if (String.IsNullOrEmpty(window)) return;

            //need a thread to grab the data, and copy them to file, aso a thread to click on somethign on the page so bookview doesn't timeout

            //to get text containing %
            //abusePercentage = browser.find_element_by_xpath('//b[contains(text(), "%")]').text

                       
            p.working = true;
            SystemCoreExpansion.AsyncMethod<long> asyncMethod = null;

            try
            {
                //open two files, and give handleto checkprogress
               

                asyncMethod = new SystemCoreExpansion.AsyncMethod<long>();
                Thread workerThreadImport = new Thread(() => asyncMethod.Execute(() => p.checkprogress(overallSleepTime,symbols, directory)));

                workerThreadImport.Start();

                while (!workerThreadImport.IsAlive) ;

                while (p.working)//sensecore.ImportProgress < 100)
                {
                    // do more stuff here, thread is running, or stop thread

                    //maybe, check for any key press to exit gracefully

                    Console.ReadKey();
                    p.working = false;
                }



                workerThreadImport.Join();
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));
            }
        }

        public IWebElement runFindElement(string xpath)
        {
           
            try
            {
               
                return driver.FindElement(By.XPath(xpath));
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));
                return null;
            }
        }

        public IReadOnlyList<IWebElement> runFindElements(string xpath)
        {
            IReadOnlyList<IWebElement> ws;
            try
            {
              
                ws= driver.FindElements(By.XPath(xpath));
                return ws;
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));
                return null;
            }
        }

        public void clickElement(IWebElement w)
        {
            try
            {
                if (w!=null)
                {
                    w.Click();
                }
            }
            catch
            {
                Console.WriteLine("could not click on {0}", w.Text);
            }
        }

        public string[,] getData1()
        {
            string[] indicators = new string[] { "buyOrders", "buyShares", "buyBid", "buyTotal", "sellOrders", "sellShares", "sellAsk", "sellTotal" };
            string xpath;
            string[,] components = new string[8, 120];
            IReadOnlyList<IWebElement>[] wdata = new IReadOnlyList<IWebElement>[8];
            try { 
           
            for (int i = 0; i < 8; i++)
            {
                xpath = string.Format("//td[@item-id='{0}']", indicators[i]);
                wdata[i] = runFindElements(xpath);
                // Console.WriteLine(wdata[i].Count);
                for (int j = 0; j < wdata[i].Count; j++)
                {
                    components[i, j] = wdata[i].ElementAt(j).Text;
                }
                Thread.Sleep(10);
            }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return components;
        }

        public float[,] getData2()
        {
            //in indicators order
            int[] indlocations = new int[8];
            string[] indicators = new string[] { "orders", "shares", "bid", "total", "orders", "shares", "ask", "total" };
            string xpath;
            float[,] components = new float[8, 120];
            string[] texts = new string[2];
            IWebElement buyw;
            IWebElement sellw;
            try
            {

            
           
            xpath = "//table[@type='buy']";
            buyw = runFindElement(xpath);
            xpath = "//table[@type='sell']";
            sellw = runFindElement(xpath);
            texts[0] = buyw.Text;
            texts[1] = sellw.Text;

            for (int t=0;t<2;t++)
            {
                string[] dels = texts[t].Split(new char[] { '\r' });
                    int dcnt = dels.Count();
                    if (dcnt<5)
                    {
                        Console.WriteLine("dels count={0}", dcnt);
                    }
                for (int i=0;i< dcnt; i++) { dels[i] = dels[i].Replace("\n", ""); }
                //dels[0] should be headers

                string[] headers = dels[0].Split(new char[] { ' ' });
                for (int i=0;i<4;i++)
                {
                    for (int j=0;j<4;j++)
                    {
                        if (headers[j].ToLower().Equals(indicators[i+t*4]))
                        {
                            indlocations[j] = i+t*4;
                            break;
                        }
                    }
                }

                //now put text elements in the components
                for (int i=1;i<dels.Count()-1;i++) //omit last one that gives totals
                {
                    string[] elements = dels[i].Split(new char[] { ' ' });
                    for (int j=0;j<elements.Count();j++)
                    {
                            string component = elements[j];
                            component = component.Replace(",", "");
                            component = component.Replace("$", "");
                            try
                            {
                                components[indlocations[j], i - 1] = Single.Parse(component);
                            }
                            catch
                            {
                                components[indlocations[j], i - 1] = 0;
                            }

                    }
                }
            }
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));
               
            }
            return components;
        }

        public long checkprogress(int overallSleepTime,string[] symbols, string directory)
        {
            string symbol = null;
            int symbolind = 0;
            int mastersleep ;
            if (symbols == null)
            {
                mastersleep = overallSleepTime;
            }
            else
            {
                mastersleep = overallSleepTime / symbols.Count();
                symbol = symbols[symbolind];
            }
            
            
            string data = "";
            string xpath;
            string headers="";
            string processeddata = "";
            char delimiter = '\t';
            IWebElement w;
            IReadOnlyList<IWebElement> ws;
            
           
            float[,] components = null;// new string[8, 120];
            /*
            xpath = "//table[@type='buy']/thead/tr/th";// "//th[@ng-show='renderColumn(header, true)']";
            ws = driver.FindElements(By.XPath(xpath));
            
            foreach(IWebElement ww in ws)
            {
                headers = String.Concat(headers, ww.Text, delimiter);
            }

            xpath = "//table[@type='sell']/thead/tr/th";// "//th[@ng-show='renderColumn(header, true)']";
            ws = driver.FindElements(By.XPath(xpath));

            foreach (IWebElement ww in ws)
            {
                headers = String.Concat(headers, ww.Text, delimiter);
            }
            string t1 = String.Concat(@directory, symbol, "_book_history.txt");
            
            using (System.IO.StreamWriter sw = new System.IO.StreamWriter(t1, true))
            {
                sw.WriteLine(headers);
            }

            using (System.IO.StreamWriter sw = new System.IO.StreamWriter(String.Concat(@directory, symbol,"_book_realtime.txt"), true))
            {
                sw.WriteLine(headers);
            }
            */

            DateTime t0 = DateTime.Now;

            while (working)
            {
                try
                {
                    //select symbol
                    if (symbols!=null && (symbols.Count() > 1 || ((DateTime.Now-t0).TotalMinutes>10)))
                    {
                        symbol = symbols[symbolind];
                        selectSymbol(symbol);
                        t0 = DateTime.Now;
                    }

                    Thread.Sleep(250);

                    //extract data

                    w = runFindElement("//div[@id='main-container']");
                    data = w.GetAttribute("innerHTML");

                    w = runFindElement("//div[@class='pause-icon']");
                    if (w != null)
                    {

                        //pause it
                        w = runFindElement("//button[@data-ng-click='togglePause()']");
                        if (w != null)
                        {
                            clickElement(w);
                        }
                    }


                    Thread.Sleep(100);
                    //getdata
                    //components = getData1();
                    components = getData2();

                    w = runFindElement("//div[@class='play-icon']");
                    if (w != null)
                    {
                        //resume it
                        w = runFindElement("//button[@data-ng-click='togglePause()']");
                        if (w != null)
                        {
                            clickElement(w);
                        }
                    }
                    string dtsdate = DateTime.Now.ToString("yyyy-MM-dd");

                    string dts = DateTime.Now.ToString("yyyy-MM-dd HH:mm:sszzz");
                    //write data to file

                    //System.IO.StreamWriter swr = new System.IO.StreamWriter(String.Concat(@directory, symbol, "_book_realtime.txt"), false);
                    //System.IO.StreamWriter swh = new System.IO.StreamWriter(String.Concat(@directory, symbol, "_book_history ", dtsdate,".txt"), true);

                    if (components != null)
                    {

                        MarketDataDefinition mdd = new MarketDataDefinition();
                        mdd.dateTime = DateTime.Now;
                        mdd.dateTimeString = dts;
                        mdd.components = components;
                       

                        if (directory != null)
                        {
                            bool writeok = false;
                            /*
                            try
                            {
                                using (Stream stream = File.Open(String.Concat(@directory, symbol, "_book_realtime.bin"), FileMode.Create))
                                {
                                    var binaryFormatter = new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter();
                                    binaryFormatter.Serialize(stream, mdd);
                                    //binaryFormatter.Deserialize()
                                }
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));
                            }
                            */
                            writeok = false;
                            for (int wi = 0; wi < 3; wi++)
                            {
                                try
                            {
                                using (Stream stream = File.Open(String.Concat(@directory, symbol, "_book_realtime.bn2"), FileMode.Create))
                                {
                                    mdd.writeSimpleBinary(stream);
                                }
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));
                            }
                                if (writeok) break;
                            }
                            writeok = false;
                            for (int wi = 0; wi < 3; wi++)
                            {
                                try
                                {
                                    using (Stream stream = File.Open(String.Concat(@directory, symbol, "_book_history ", dtsdate, ".bn2"), FileMode.Append))
                                    {
                                        mdd.writeSimpleBinary(stream);
                                        writeok = true;
                                    }
                                }
                                catch (Exception ex)
                                {
                                    Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));
                                }
                                if (writeok) break;
                            }

                        }
                        else
                        {
                            Console.WriteLine("directory reported null.");
                        }


                    }
                    else
                    {
                        Console.WriteLine("{0}:components set is null.", symbol);
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));

                }
                if (symbols != null)
                {
                    symbolind++;
                    if (symbolind >= symbols.Count()) symbolind = 0;
                }
                //touchsomething();
                Thread.Sleep(mastersleep);
            }
            

            return 0;
        }

        public void touchsomething()
        {
            string xpath;
            IWebElement w;

            xpath = "//button[@data-ng-click='toggleAdv()']";
            w = driver.FindElement(By.XPath(xpath));
            w.Click();
            Thread.Sleep(75);

            xpath = "//button[@data-ng-click='toggleAdv()']";
            w = driver.FindElement(By.XPath(xpath));
            w.Click();
            Thread.Sleep(75);
        }

        public void Login_is_on_home_page()
        {

            homeURL = "https://data.nasdaq.com/BookViewer.aspx";
            driver.Navigate().GoToUrl(homeURL);
            WebDriverWait wait = new WebDriverWait(driver,
                    System.TimeSpan.FromSeconds(15));


        }

        [TearDown]
        public void TearDownTest()
        {
            try
            {
                driver.Close();
                driver.Dispose();
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));

            }
        }

        [SetUp]
        public void SetupTest()
        {
            driver = new ChromeDriver();

        }
      

        public string switchtopopup()
        {
            driver.Close();
            IReadOnlyList<String> windows = driver.WindowHandles;
            //string currentwindow = driver.CurrentWindowHandle;
           

            // To handle all new opened window.				
            foreach (string window in windows)
            {

                Console.WriteLine(window);

                //if (!currentwindow.Equals(window))
                {
                    // Switching to Child window
                    driver.SwitchTo().Window(window);
                    try
                    {



                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                    }
                }

                return window;
            }
            return "";
        }

       public void selectSymbol(string symbol)
        {
            if (symbol == null) return;
            Thread.Sleep(250);

            IWebElement w = driver.FindElement(By.Id("mpid-input"));
            w.Clear();
            w.SendKeys(symbol + OpenQA.Selenium.Keys.Enter);
            Thread.Sleep(150);
        }

        public string setupBookViewer(string symbol, string filterlimit)
        {

            string limit = filterlimit;

            int sleepshort = 50;
            int sleepfunction = 100;
            int sleepmed = 250;
            int sleeplong = 500;

            bool[] values = { true, true, true, true, true, true, true, true, true, true, true, true, true, true };
            string[] turnon = { "Orders", "Shares", "Total", "BID", "ASK" };
            IReadOnlyList<IWebElement> ws;
            IWebElement w;
            string xpath;
            try
            {
                SetupTest();


                Login_is_on_home_page();

                String name = "Charles";
                Thread.Sleep(sleeplong);
                driver.FindElement(By.Id("txtUserName")).SendKeys("mortezahaydari");
                driver.FindElement(By.Id("txtPassword")).SendKeys("haymor968hay" + OpenQA.Selenium.Keys.Enter);
                Thread.Sleep(1500);
                driver.FindElement(By.Id("PageContent_btnLaunchBv3")).Click();
                Thread.Sleep(2000);
                string window=switchtopopup();

                Thread.Sleep(sleepmed);

                selectSymbol(symbol);

                Thread.Sleep(sleepfunction);
                //ws = driver.FindElements(By.XPath(textBox1.Text));
                xpath = "//button[@data-ng-click='toggleAdv()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();
                Thread.Sleep(sleepfunction);
                xpath = "//input[@data-ng-model='filters.buyVolumeMin']";
                w = driver.FindElement(By.XPath(xpath));
                w.Clear();
                w.SendKeys(limit);
                Thread.Sleep(sleepmed);
                xpath = "//input[@data-ng-model='filters.sellVolumeMin']";
                w = driver.FindElement(By.XPath(xpath));
                w.Clear();
                w.SendKeys(limit);
                Thread.Sleep(sleepmed);
                xpath = "//button[@data-ng-click='sellBtnGo()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();
                Thread.Sleep(sleepfunction);
                xpath = "//button[@data-ng-click='toggleAdv()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();
                Thread.Sleep(sleepfunction);
                xpath = "//input[@data-ng-change='aggregatedByPrice()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();

                Thread.Sleep(sleepfunction);
                xpath = "//select[@data-ng-change='toggleFilter()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();
                w.SendKeys("120");
                w.Click();
                Thread.Sleep(sleepmed);
                xpath = "//button[@uib-popover-template='userColumnsSelections.templateUrl']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();
                Thread.Sleep(sleeplong);
                xpath = "//input[@type='checkbox' and @title='item']";
                ws = driver.FindElements(By.XPath(xpath));
                Console.WriteLine("count of ws is {0}", ws.Count());
                if (ws.Count() == 14)
                {
                    for (int i = 0; i < 14; i++)
                    {
                        string ss = ws[i].FindElement(By.XPath("following-sibling::*")).Text;
                        bool status = false;
                        for (int si = 0; si < turnon.Count(); si++)
                        {
                            if (ss.Contains(turnon[si])) { status = true; break; }
                        }

                        Thread.Sleep(sleepshort);
                        SetCheckBox(ws[i], status);
                    }
                }
                
                Thread.Sleep(sleeplong);
                xpath = "//div[@ng-click='saveColumnSettings()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();
                Thread.Sleep(sleeplong);
                xpath = "//button[@data-ng-click='actionMethod()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();
                Thread.Sleep(sleeplong);
                xpath = "//button[@uib-popover-template='userColumnsSelections.templateUrl']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();


                return window;
            }
            catch (Exception ex)
            {
                Console.WriteLine(String.Concat(ex.HResult.ToString(), ":", ex.Message));

            }

            return null;
        }


        public void SetCheckBox(IWebElement w, bool value)
        {
            //Console.Write("checkbox state : " + checkbox_Address.Selected);  
            if (!value && w.Selected)
            {
                w.Click();
            }
            else if (value && !w.Selected)
            {

                w.Click();
            }
        }
    }
}
