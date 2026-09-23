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

namespace MHA
{
    class Program
    {
        private IWebDriver driver;
        public string homeURL;
        bool working = true;
        string basedir = "";

        WebDriverWait wait;

        Dictionary<string,MarketBeatRatingsDefinition> mbrs = new Dictionary<string, MarketBeatRatingsDefinition>();
        static void Main(string[] args)
        {
            string basedir = "";
            if (args.Count()==0)
            {
                basedir = Directory.GetCurrentDirectory();
            }
            else
            {
                basedir = args[0];
            }

            Program p = new Program();
            try
            {
                p.setup(basedir);

                //now loop through pages, and grab data
                p.open();

                DateTime start = DateTime.Parse("01/02/2020");
                DateTime end = DateTime.Parse("09/27/2020");
                List<DateTime> dates = new List<DateTime>();

                for (DateTime dt = start; dt <= end; dt = dt.AddDays(1))
                {
                    dates.Add(dt);
                }
                foreach (DateTime date_ in dates)
                {
                    string date0 = date_.ToString("MM/dd/yyyy");
                    date0 = date0.Replace('-', '/');
                    Console.WriteLine(date0);
                    p.grab(date0);
                }
                p.save();
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
            int mbrcnt = mbrs.Count;
          
            for(int mi=0;mi<mbrcnt;mi++)
            {
                try
                {
                    MarketBeatRatingsDefinition mbr = mbrs.ElementAt(mi).Value;
                    string symbol = mbrs.ElementAt(mi).Key;
                    string filename = String.Concat(basedir, @"\", symbol, ".mbb");

                    mbr.save(filename);
                }
                catch(Exception ex)
                {
                    Console.Write("{0}",ex.Message);
                }
            }
            Console.WriteLine("mbrs size is {0}", mbrs.Count);
        }

        public void open()
        {
            string[] filePaths = Directory.GetFiles(basedir, "*.mbb");

            foreach(string file in filePaths)
            {
                MarketBeatRatingsDefinition mbr = new MarketBeatRatingsDefinition();
                mbr.open(file);
                mbrs.Add(mbr.ratingsAndTargets[0].symbol, mbr);

            }
            Console.WriteLine("mbrs size is {0}", mbrs.Count);
        }

    
        public void grab(string date0)
        {
            //loop
            IWebElement we = null;
            IReadOnlyList<IWebElement> werows = null;
            IReadOnlyList<IWebElement> wecols = null;

            string xpath;
          
            //iterate through dates and check business days
            
            {
                bool foundpage = false;
                DateTime date2=DateTime.Now;

                while (foundpage == false)
                {
                    try { 
                    Thread.Sleep(250);
                    xpath = "//input[@id='cphPrimaryContent_txtStartDate']";
                    try
                    {
                        wait.Until(ExpectedConditions.ElementExists(By.XPath(xpath)));
                    }
                    catch { }
                    we = driver.FindElement(By.XPath(xpath));
                    we.SendKeys(OpenQA.Selenium.Keys.Control + "a");
                    we.SendKeys(date0);
                    we.SendKeys(OpenQA.Selenium.Keys.Enter);

                    try
                    {
                        Thread.Sleep(250); //wait for date to update
                        xpath = "//table//tbody//tr//td//div[@class='ticker-area']";

                        wait.Until(ExpectedConditions.ElementExists(By.XPath(xpath)));
                    }
                    catch { }
                    Thread.Sleep(2000);

                    xpath = "//table//tbody//tr";
                    werows = driver.FindElements(By.XPath(xpath));


                    xpath = "//input[@id='cphPrimaryContent_txtStartDate']";
                    try
                    {
                        wait.Until(ExpectedConditions.ElementExists(By.XPath(xpath)));
                    }
                    catch { }
                    we = driver.FindElement(By.XPath(xpath));
                    string datetext = we.GetAttribute("value");
                    date2 = DateTime.Parse(datetext);
                    foundpage = true;
                }
                catch{ }
                }

                DateTime date1 = DateTime.Parse(date0);
               
                if (date1 != date2) return;
                Thread.Sleep(250);
                int rcnt = werows.Count;
                for (int ri=0;ri<rcnt;ri++)
                {
                    try
                    {
                        //each row contains one rating/target
                        xpath = ".//td//div[@class='ticker-area']";
                        we = werows[ri].FindElement(By.XPath(xpath));
                        string symbol = we.Text;
                        if (String.IsNullOrEmpty(symbol)) continue;

                        symbol=symbol.Replace('\\', '_').Replace('?', '_').Replace('/', '_');

                        xpath = ".//td";
                        wecols = werows[ri].FindElements(By.XPath(xpath));
                        if (wecols.Count != 8) continue;
                        string a = wecols[1].Text;
                        string b = wecols[2].Text;
                        string t = wecols[4].Text;
                        string r = wecols[5].Text;
                        string i = wecols[6].Text;
                        Console.WriteLine("{0}:{1} {2}", ri, symbol, t);
                        //find mbr i ndictionary
                        if (!mbrs.ContainsKey(symbol))
                        {
                            mbrs.Add(symbol, new MarketBeatRatingsDefinition());
                        }

                        mbrs[symbol].Add(DateTime.Parse(date0), symbol, a, b, t, r, i);
                    }
                    catch(Exception ex)
                    {
                        Console.WriteLine(ex.Message);
                    }
                }
                              

            }//next date

        }

        public void setup(string bd)
        {
            basedir = bd;
            IReadOnlyList<IWebElement> ws;
            IWebElement w;
            string xpath;

            var options = new ChromeOptions();
            //options.AddExcludedArguments(new List<string>() { "enable-automation" });
            //options.AddArguments(new List<string>() { "--user-agent=Chrome/84.0.4147.135", "--disable-blink-features=AutomationControlled" });

            driver = new ChromeDriver(options);
            Thread.Sleep(500);

            homeURL = "https://www.marketbeat.com/ratings/AllActions/";
            driver.Navigate().GoToUrl(homeURL);
            wait = new WebDriverWait(driver,
                  System.TimeSpan.FromSeconds(6));
           

            Thread.Sleep(5000);

        }

    }
}
