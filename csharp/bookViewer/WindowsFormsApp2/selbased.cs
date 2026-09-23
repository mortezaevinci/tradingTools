using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using NUnit.Framework;
using System.Threading;

namespace WindowsFormsApp2
{
    public partial class Form1 : Form
    {

        public Form1()
        {
            InitializeComponent();



        }


               

        private void Form1_Load(object sender, EventArgs e)
        {

        }


        private IWebDriver driver;
        public string homeURL;

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
            
            driver.Close();
        }

        [SetUp]
        public void SetupTest()
        {
            driver = new ChromeDriver();

        }


        public void switchtopopup()
        {
            IReadOnlyList<String> windows = driver.WindowHandles;
            string currentwindow = driver.CurrentWindowHandle;

            // To handle all new opened window.				
            foreach (string window in windows)
            {

                Console.WriteLine(window);

                if (!currentwindow.Equals(window))
                {
                    // Switching to Child window
                    driver.SwitchTo().Window(window);
                    try
                    {



                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("error in id");
                    }
                }


            }
        }

        IWebElement we;
       
        public void setupBookViewer(string symbol, string filterlimit)
        {
            
            string limit = "500";

            int sleepshort = 25;
            int sleepmed = 100;
            int sleeplong = 350;

            bool[] values = { false, false, true, true, true, true, false, true, true, true, false, false, true, false };

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
                Thread.Sleep(sleeplong);
                driver.FindElement(By.Id("PageContent_btnLaunchBv3")).Click();
                Thread.Sleep(sleeplong);
                switchtopopup();

                Thread.Sleep(sleepmed);

                w = driver.FindElement(By.Id("mpid-input"));
                w.Clear();
                w.SendKeys(symbol + OpenQA.Selenium.Keys.Enter);

                Thread.Sleep(sleepshort);
                //ws = driver.FindElements(By.XPath(textBox1.Text));
                xpath = "//button[@data-ng-click='toggleAdv()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();
                Thread.Sleep(sleepshort);
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
                Thread.Sleep(sleepshort);
                xpath = "//button[@data-ng-click='toggleAdv()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();
                Thread.Sleep(sleepshort);
                xpath = "//input[@data-ng-change='aggregatedByPrice()']";
                w = driver.FindElement(By.XPath(xpath));
                w.Click();

                Thread.Sleep(sleepshort);
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
                        Thread.Sleep(sleepshort);
                        SetCheckBox(ws[i], values[i]);
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

            }
            catch { }
        }

        private void Button12_Click(object sender, EventArgs e)
        {
            setupBookViewer("AMD", "50");
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