namespace OrderManager2
{
    partial class OrderManagerForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.TB_OrderId = new System.Windows.Forms.TextBox();
            this.B_Cancel = new System.Windows.Forms.Button();
            this.L_OrderInfo = new System.Windows.Forms.TextBox();
            this.DGV_ParentOrders = new System.Windows.Forms.DataGridView();
            this.OID = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Symbol = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Action = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Type = new System.Windows.Forms.DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)(this.DGV_ParentOrders)).BeginInit();
            this.SuspendLayout();
            // 
            // TB_OrderId
            // 
            this.TB_OrderId.Location = new System.Drawing.Point(12, 281);
            this.TB_OrderId.Name = "TB_OrderId";
            this.TB_OrderId.Size = new System.Drawing.Size(100, 20);
            this.TB_OrderId.TabIndex = 0;
            this.TB_OrderId.TextChanged += new System.EventHandler(this.TB_OrderId_TextChanged);
            // 
            // B_Cancel
            // 
            this.B_Cancel.Location = new System.Drawing.Point(566, 440);
            this.B_Cancel.Name = "B_Cancel";
            this.B_Cancel.Size = new System.Drawing.Size(75, 23);
            this.B_Cancel.TabIndex = 1;
            this.B_Cancel.Text = "CANCEL";
            this.B_Cancel.UseVisualStyleBackColor = true;
            this.B_Cancel.Click += new System.EventHandler(this.B_Cancel_Click);
            // 
            // L_OrderInfo
            // 
            this.L_OrderInfo.Enabled = false;
            this.L_OrderInfo.Location = new System.Drawing.Point(12, 307);
            this.L_OrderInfo.Multiline = true;
            this.L_OrderInfo.Name = "L_OrderInfo";
            this.L_OrderInfo.Size = new System.Drawing.Size(629, 127);
            this.L_OrderInfo.TabIndex = 2;
            // 
            // DGV_ParentOrders
            // 
            this.DGV_ParentOrders.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.DGV_ParentOrders.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.OID,
            this.Symbol,
            this.Action,
            this.Type});
            this.DGV_ParentOrders.Location = new System.Drawing.Point(12, 12);
            this.DGV_ParentOrders.Name = "DGV_ParentOrders";
            this.DGV_ParentOrders.Size = new System.Drawing.Size(629, 263);
            this.DGV_ParentOrders.TabIndex = 3;
            this.DGV_ParentOrders.CellClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.DGV_ParentOrders_CellClick);
            this.DGV_ParentOrders.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.DGV_ParentOrders_CellContentClick);
            // 
            // OID
            // 
            this.OID.HeaderText = "OID";
            this.OID.Name = "OID";
            // 
            // Symbol
            // 
            this.Symbol.HeaderText = "Symbol";
            this.Symbol.Name = "Symbol";
            // 
            // Action
            // 
            this.Action.HeaderText = "Action";
            this.Action.Name = "Action";
            // 
            // Type
            // 
            this.Type.HeaderText = "Type";
            this.Type.Name = "Type";
            // 
            // OrderManagerForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(653, 475);
            this.Controls.Add(this.DGV_ParentOrders);
            this.Controls.Add(this.L_OrderInfo);
            this.Controls.Add(this.B_Cancel);
            this.Controls.Add(this.TB_OrderId);
            this.Name = "OrderManagerForm";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.DGV_ParentOrders)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox TB_OrderId;
        private System.Windows.Forms.Button B_Cancel;
        private System.Windows.Forms.TextBox L_OrderInfo;
        private System.Windows.Forms.DataGridView DGV_ParentOrders;
        private System.Windows.Forms.DataGridViewTextBoxColumn OID;
        private System.Windows.Forms.DataGridViewTextBoxColumn Symbol;
        private System.Windows.Forms.DataGridViewTextBoxColumn Action;
        private System.Windows.Forms.DataGridViewTextBoxColumn Type;
    }
}

