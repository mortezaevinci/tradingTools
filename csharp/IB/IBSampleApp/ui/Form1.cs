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

namespace IBSampleApp.ui
{
    public partial class formChart : Form
    {
        public int requestId;
        public string symbol;
        public mimicORderDefinition mimicOrders = new mimicORderDefinition();
        public class mimicORderDefinition
        {
          public   List<Order> orders = new List<Order>();
        }

        public formChart()
        {
            InitializeComponent();
        }

        private void toolStripMenuClearOrders_Click(object sender, EventArgs e)
        {
            mimicOrders.orders.Clear();
            //clear annotations too
        }
    }
}
