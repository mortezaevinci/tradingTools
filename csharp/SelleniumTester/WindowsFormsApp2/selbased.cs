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
using OpenQA.Selenium.Firefox;

namespace WindowsFormsApp2
{
    public partial class Form1 : Form
    {




        public Form1()
        {
            InitializeComponent();



        }

        /*
        private void doit()
        {
            Console.WriteLine("completeed");

         
            HtmlElementCollection el = doc.GetElementsByTagName("input");

            foreach (HtmlElement btn in el)
            {
                if (btn.GetAttribute("id") == "txtUserName")
                {
                    btn.SetAttribute("value", "mortezahaydari");
                    break;
                }
            }

            foreach (HtmlElement btn in el)
            {
                if (btn.GetAttribute("id") == "txtPassword")
                {
                    btn.SetAttribute("value", "haymor968hay");
                    break;
                }
            }

            %clickById("btnLogin");
        }
        */






        private void Form1_Load(object sender, EventArgs e)
        {

        }



        private void WebBrowser_NewWindow(object sender, CancelEventArgs e)
        {

            // e.Cancel = true;
            // Console.WriteLine(webBrowser.StatusText);
            // webBrowser.Navigate(webBrowser.StatusText);


        }

        private void WebBrowser_DocumentCompleted_1(object sender, WebBrowserDocumentCompletedEventArgs e)
        {

        }

        private IWebDriver driver;
        public string homeURL;

        [Test(Description = "Check SauceLabs Homepage for Login Link")]
        public void Login_is_on_home_page()
        {

            homeURL = TB_Address.Text;
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
            var options = new ChromeOptions();
            if (cb_options.Checked)
            {
                options.AddExcludedArguments(new List<string>() { "enable-automation" });
                options.AddArguments(new List<string>() { "--user-agent=Chrome/84.0.4147.135", "--disable-blink-features=AutomationControlled" });
            }
            driver = new ChromeDriver(options);// FirefoxDriver();

            //FirefoxOptions options = new FirefoxOptions();
            //options.AddArgument( "-user-agent=Mozilla/68.0");
            //driver = new FirefoxDriver(options);
        }

        private void Button6_Click(object sender, EventArgs e)
        {
            SetupTest();
        }


        private void Button7_Click(object sender, EventArgs e)
        {
            Login_is_on_home_page();
        }

        private void Button8_Click(object sender, EventArgs e)
        {
            TearDownTest();
        }

        private void Button9_Click(object sender, EventArgs e)
        {
       
        }

        private void Button1_Click(object sender, EventArgs e)
        {
        

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

        private void Button2_Click(object sender, EventArgs e)
        {
            switchtopopup();
        }
        IWebElement we;
        IReadOnlyList<IWebElement> wes = null;
        private void Button3_Click(object sender, EventArgs e)
        {
            wes = null;
            
            try
            {
                Console.WriteLine("by xpath");
                we = driver.FindElement(By.XPath(textBox1.Text));
                Console.WriteLine(we.Text);
                Console.WriteLine("all:");
                Console.WriteLine("by xpath");
                wes = driver.FindElements(By.XPath(textBox1.Text));
                Console.WriteLine("count={0}",wes.Count());
                


                foreach(IWebElement w in wes)
                {
                    Console.Write("element:");
                    Console.WriteLine(w.Text);
                    /*
                    wes_in = w.FindElements(By.XPath("//td"));

                    foreach (IWebElement win in wes_in)
                    {
                        Console.WriteLine(win.Text);
                    }

                        Console.WriteLine("following:");
                    Console.WriteLine(w.FindElement(By.XPath("following-sibling::*")).Text);
                    */
                }
            }
            catch (Exception ex)
            {
                // Console.WriteLine("error in id");
            }

        }

        private void Button10_Click(object sender, EventArgs e)
        {
            try
            {
                OpenQA.Selenium.Support.UI.SelectElement select = new OpenQA.Selenium.Support.UI.SelectElement(we);
                select.SelectByValue("120");

            }
            catch { }
        }

        private void Button4_Click(object sender, EventArgs e)
        {
            try
            {
                we.Click();
            }
            catch { }
        }

        private void Button5_Click(object sender, EventArgs e)
        {
            try
            {
                we.SendKeys(OpenQA.Selenium.Keys.Space);
            }
            catch { }
        }

        private void Button11_Click(object sender, EventArgs e)
        {
            try
            {
                we.SendKeys(textBox2.Text);
            }
            catch { }
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

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void B_runSubXPath_Click(object sender, EventArgs e)
        {
           
            try
            {
                if (wes == null) return;
                if (wes.Count == 0) return;
                Console.WriteLine("by sub xpath");
                Console.WriteLine("wes0 text={0}", wes[0].Text);
                we = wes[0].FindElement(By.XPath(TB_subXPath.Text));
                Console.WriteLine(we.Text);
                Console.WriteLine("all:");
                Console.WriteLine("by xpath");
                wes = wes[0].FindElements(By.XPath(TB_subXPath.Text));
                Console.WriteLine("count={0}", wes.Count());



                foreach (IWebElement w in wes)
                {
                    Console.Write("element:");
                    Console.WriteLine(w.Text);
                    /*
                    wes_in = w.FindElements(By.XPath("//td"));

                    foreach (IWebElement win in wes_in)
                    {
                        Console.WriteLine(win.Text);
                    }

                        Console.WriteLine("following:");
                    Console.WriteLine(w.FindElement(By.XPath("following-sibling::*")).Text);
                    */
                }
            }
            catch (Exception ex)
            {
                // Console.WriteLine("error in id");
            }
        }

        private void B_Clear_Click(object sender, EventArgs e)
        {
            try
            {
                we.Clear();

            }
            catch { }
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            try
            {
             
                we.SendKeys(OpenQA.Selenium.Keys.Control + "a");
                we.SendKeys(textBox2.Text);
                we.SendKeys(OpenQA.Selenium.Keys.Enter);
            }
            catch { }
        }
    }
}