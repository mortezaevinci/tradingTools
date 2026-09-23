using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace IBSampleApp
{
    public partial class extrainfo : Form
    {
        public DialogResult result = DialogResult.Cancel;
        public extrainfo()
        {
            InitializeComponent();
        }

        private void B_OK_Click(object sender, EventArgs e)
        {
            result = DialogResult.OK;
            this.Hide();
        }

        public double limitPrice
        {
            get
            {
                return Double.Parse(TB_LmtPrice.Text);
            }
        }

        public double auxPrice
        {
            get
            {
                return Double.Parse(TB_AuxPrice.Text);
            }
        }

    }
}
