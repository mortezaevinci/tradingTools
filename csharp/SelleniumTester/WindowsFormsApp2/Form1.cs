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

namespace WindowsFormsApp2
{
    public partial class Form1 : Form
    {

    
        private SHDocVw.WebBrowser_V1 Web_V1;
        private void InlinePopups(WebBrowser browser)
        {
            // hooks to force new windows to open in the current instance
           
           Web_V1.NewWindow += new SHDocVw.DWebBrowserEvents_NewWindowEventHandler((string URL, int Flags, string TargetFrameName, ref object PostData, string Headers, ref bool Processed) =>
         
            {
                Processed = true; // stop event from being processed

                // open in the existing window
                wb1.Navigate(URL);
            });
        }
        

        public Form1()
        {
            InitializeComponent();

            webBrowser.AllowNavigation = true;

           

        }

        private void Button1_Click(object sender, EventArgs e)
        {

            //webBrowser.DocumentCompleted += new WebBrowserDocumentCompletedEventHandler(webBrowser_DocumentCompleted);

            webBrowser.Navigate("https://data.nasdaq.com/BookViewer.aspx");

            Web_V1 = (SHDocVw.WebBrowser_V1)webBrowser.ActiveXInstance;

        }

        private void webBrowser_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            doit();
        }

        public void clickById(string id)
        {
            HtmlDocument doc = webBrowser.Document;

            HtmlElementCollection el = doc.GetElementsByTagName("input");

            foreach (HtmlElement btn in el)
            {
                if (btn.GetAttribute("id") == id)
                {
                    btn.InvokeMember("click");
                    break;
                }
            }
        }

        private void doit()
        {
            Console.WriteLine("completeed");

            HtmlDocument doc = webBrowser.Document;

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

            clickById("btnLogin");
        }






        private void Button2_Click(object sender, EventArgs e)
        {
            webBrowser.Refresh();
        }

        private void Button3_Click(object sender, EventArgs e)
        {
            doit();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void Button4_Click(object sender, EventArgs e)
        {
            clickById("PageContent_btnLaunchBv3");
        }

        private void Button5_Click(object sender, EventArgs e)
        {
           InlinePopups(webBrowser);
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

            homeURL = "https://data.nasdaq.com";
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
            String name = "Charles";
            
            driver.FindElement(By.Id("txtUserName")).SendKeys("mortezahaydari");
        }
    }
}
