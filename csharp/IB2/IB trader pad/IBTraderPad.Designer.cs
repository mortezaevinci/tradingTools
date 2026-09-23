namespace MHA
{
    partial class IBTraderPad
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(IBTraderPad));
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.mainToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.settingsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.connectToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripTextBoxSymbol = new System.Windows.Forms.ToolStripTextBox();
            this.gridTrader = new System.Windows.Forms.DataGridView();
            this.BidHist = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BidSize = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.LastB = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Price = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.LastA = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.AskSize = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.AskHist = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.toolStripButtonRecenter = new System.Windows.Forms.ToolStripButton();
            this.menuStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gridTrader)).BeginInit();
            this.toolStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.mainToolStripMenuItem,
            this.connectToolStripMenuItem,
            this.toolStripTextBoxSymbol});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(448, 27);
            this.menuStrip1.TabIndex = 0;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // mainToolStripMenuItem
            // 
            this.mainToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.settingsToolStripMenuItem});
            this.mainToolStripMenuItem.Name = "mainToolStripMenuItem";
            this.mainToolStripMenuItem.Size = new System.Drawing.Size(46, 23);
            this.mainToolStripMenuItem.Text = "Main";
            // 
            // settingsToolStripMenuItem
            // 
            this.settingsToolStripMenuItem.Name = "settingsToolStripMenuItem";
            this.settingsToolStripMenuItem.Size = new System.Drawing.Size(180, 22);
            this.settingsToolStripMenuItem.Text = "Settings...";
            this.settingsToolStripMenuItem.Click += new System.EventHandler(this.settingsToolStripMenuItem_Click);
            // 
            // connectToolStripMenuItem
            // 
            this.connectToolStripMenuItem.Name = "connectToolStripMenuItem";
            this.connectToolStripMenuItem.Size = new System.Drawing.Size(64, 23);
            this.connectToolStripMenuItem.Text = "Connect";
            this.connectToolStripMenuItem.Click += new System.EventHandler(this.connectToolStripMenuItem_Click);
            // 
            // toolStripTextBoxSymbol
            // 
            this.toolStripTextBoxSymbol.Name = "toolStripTextBoxSymbol";
            this.toolStripTextBoxSymbol.Size = new System.Drawing.Size(100, 23);
            this.toolStripTextBoxSymbol.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.toolStripTextBoxSymbol_KeyPress);
            this.toolStripTextBoxSymbol.KeyUp += new System.Windows.Forms.KeyEventHandler(this.toolStripTextBoxSymbol_KeyUp);
            this.toolStripTextBoxSymbol.Click += new System.EventHandler(this.toolStripTextBoxSymbol_Click);
            // 
            // gridTrader
            // 
            this.gridTrader.AllowUserToAddRows = false;
            this.gridTrader.AllowUserToDeleteRows = false;
            this.gridTrader.AllowUserToResizeColumns = false;
            this.gridTrader.AllowUserToResizeRows = false;
            this.gridTrader.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.gridTrader.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.BidHist,
            this.BidSize,
            this.LastB,
            this.Price,
            this.LastA,
            this.AskSize,
            this.AskHist});
            this.gridTrader.Dock = System.Windows.Forms.DockStyle.Fill;
            this.gridTrader.Location = new System.Drawing.Point(0, 27);
            this.gridTrader.Margin = new System.Windows.Forms.Padding(0);
            this.gridTrader.MultiSelect = false;
            this.gridTrader.Name = "gridTrader";
            this.gridTrader.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.AutoSizeToFirstHeader;
            this.gridTrader.ShowCellErrors = false;
            this.gridTrader.ShowEditingIcon = false;
            this.gridTrader.ShowRowErrors = false;
            this.gridTrader.Size = new System.Drawing.Size(448, 724);
            this.gridTrader.TabIndex = 1;
            this.gridTrader.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.gridTrader_CellContentClick);
            this.gridTrader.CellPainting += new System.Windows.Forms.DataGridViewCellPaintingEventHandler(this.gridTrader_CellPainting);
            // 
            // BidHist
            // 
            this.BidHist.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.BidHist.HeaderText = "Bid H";
            this.BidHist.Name = "BidHist";
            // 
            // BidSize
            // 
            this.BidSize.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.BidSize.HeaderText = "Bid S";
            this.BidSize.Name = "BidSize";
            // 
            // LastB
            // 
            this.LastB.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.LastB.HeaderText = "Last B";
            this.LastB.Name = "LastB";
            // 
            // Price
            // 
            this.Price.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Price.HeaderText = "Price";
            this.Price.Name = "Price";
            // 
            // LastA
            // 
            this.LastA.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.LastA.HeaderText = "Last A";
            this.LastA.Name = "LastA";
            this.LastA.ReadOnly = true;
            this.LastA.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            // 
            // AskSize
            // 
            this.AskSize.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.AskSize.HeaderText = "Ask S";
            this.AskSize.Name = "AskSize";
            // 
            // AskHist
            // 
            this.AskHist.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.AskHist.HeaderText = "Ask H";
            this.AskHist.Name = "AskHist";
            // 
            // toolStrip1
            // 
            this.toolStrip1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripButtonRecenter});
            this.toolStrip1.Location = new System.Drawing.Point(0, 726);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(448, 25);
            this.toolStrip1.TabIndex = 2;
            this.toolStrip1.Text = "toolStrip1";
            // 
            // toolStripButtonRecenter
            // 
            this.toolStripButtonRecenter.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripButtonRecenter.Image = ((System.Drawing.Image)(resources.GetObject("toolStripButtonRecenter.Image")));
            this.toolStripButtonRecenter.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripButtonRecenter.Name = "toolStripButtonRecenter";
            this.toolStripButtonRecenter.Size = new System.Drawing.Size(23, 22);
            this.toolStripButtonRecenter.Text = "Recenter";
            this.toolStripButtonRecenter.Click += new System.EventHandler(this.toolStripButtonRecenter_Click);
            // 
            // IBTraderPad
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(448, 751);
            this.Controls.Add(this.toolStrip1);
            this.Controls.Add(this.gridTrader);
            this.Controls.Add(this.menuStrip1);
            this.MainMenuStrip = this.menuStrip1;
            this.Name = "IBTraderPad";
            this.Text = "Form1";
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.gridTrader)).EndInit();
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem mainToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem settingsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem connectToolStripMenuItem;
        private System.Windows.Forms.ToolStripTextBox toolStripTextBoxSymbol;
        private System.Windows.Forms.DataGridView gridTrader;
        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripButton toolStripButtonRecenter;
        private System.Windows.Forms.DataGridViewTextBoxColumn BidHist;
        private System.Windows.Forms.DataGridViewTextBoxColumn BidSize;
        private System.Windows.Forms.DataGridViewTextBoxColumn LastB;
        private System.Windows.Forms.DataGridViewTextBoxColumn Price;
        private System.Windows.Forms.DataGridViewTextBoxColumn LastA;
        private System.Windows.Forms.DataGridViewTextBoxColumn AskSize;
        private System.Windows.Forms.DataGridViewTextBoxColumn AskHist;
    }
}

