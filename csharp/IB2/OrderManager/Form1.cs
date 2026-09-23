using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using IBApi;
using IBApi.messages;
using MHA;

namespace OrderManager
{
    public partial class OrderManagerForm : Form
    {
        IBWrapper ibWrapper;
        IBAccountDefinition IBAD;
        int gorderid = 0;
        public OrderManagerForm(IBWrapper _ibWrapper, IBAccountDefinition _IBAD)
        {
            InitializeComponent();

            ibWrapper = _ibWrapper;
            IBAD = _IBAD;
          

            if (IBAD == null) return;

            HashSet<OpenOrderMessage> msgs = IBAD.OrdersWithZeroPos();
            foreach (OpenOrderMessage msg in msgs)
            {
                if (msg.Order.ParentId == 0)
                {
                    DGV_ParentOrders.Rows.Add(msg.Contract.Symbol, msg.Order.OrderId, msg.Order.Action, msg.Order.OrderType);
                }
            }
        }

        private void TB_OrderId_TextChanged(object sender, EventArgs e)
        {
            int orderid;
            Int32.TryParse(TB_OrderId.Text, out orderid);

            findorderid(orderid);
        }


        private void findorderid(int orderid)
        {
            if (orderid > 0)
            {
                OpenOrderMessage o = IBAD.findOrder(orderid);

                L_OrderInfo.Text = OrderDefinition.Tools.MessageOrderDescription(o.Contract, o.Order, o.OrderState);
                gorderid = orderid;
            }
        }
        private void B_Cancel_Click(object sender, EventArgs e)
        {
            ibWrapper.ibClient.ClientSocket.cancelOrder(gorderid);
        }

        private void DGV_ParentOrders_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void DGV_ParentOrders_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            DataGridViewSelectedCellCollection cells = DGV_ParentOrders.SelectedCells;
            if (cells.Count == 0) return;
            DataGridViewCell cell = cells[0];
            try
            {
                if (cell.Value is int)
                {
                    int orderid = (int)(cell.Value);

                    findorderid(orderid);
                }
            }
            catch { }
        }
    }
}
