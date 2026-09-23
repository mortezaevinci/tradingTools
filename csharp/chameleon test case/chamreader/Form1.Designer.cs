namespace chamreader
{
    partial class Form1
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
            this.button1 = new System.Windows.Forms.Button();
            this.grid1 = new System.Windows.Forms.DataGridView();
            this.Time = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Symbol = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Type = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Expiration = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Strike = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Side = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Notional = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.gridtotal = new System.Windows.Forms.DataGridView();
            this.Offering = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.NotionalTotal = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.gridDir = new System.Windows.Forms.DataGridView();
            this.dataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Bullish = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.dataGridViewTextBoxColumn2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.B_readCsv = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.grid1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridtotal)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridDir)).BeginInit();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(0, 0);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "read selled";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // grid1
            // 
            this.grid1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.grid1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Time,
            this.Symbol,
            this.Type,
            this.Expiration,
            this.Strike,
            this.Side,
            this.Notional});
            this.grid1.Location = new System.Drawing.Point(4, 41);
            this.grid1.Name = "grid1";
            this.grid1.Size = new System.Drawing.Size(1050, 982);
            this.grid1.TabIndex = 1;
            // 
            // Time
            // 
            this.Time.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Time.HeaderText = "Time";
            this.Time.Name = "Time";
            // 
            // Symbol
            // 
            this.Symbol.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Symbol.HeaderText = "Symbol";
            this.Symbol.Name = "Symbol";
            // 
            // Type
            // 
            this.Type.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Type.HeaderText = "Type";
            this.Type.Name = "Type";
            // 
            // Expiration
            // 
            this.Expiration.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Expiration.HeaderText = "Expiration";
            this.Expiration.Name = "Expiration";
            // 
            // Strike
            // 
            this.Strike.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Strike.HeaderText = "Strike";
            this.Strike.Name = "Strike";
            // 
            // Side
            // 
            this.Side.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Side.HeaderText = "Side";
            this.Side.Name = "Side";
            // 
            // Notional
            // 
            this.Notional.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Notional.HeaderText = "Notional";
            this.Notional.Name = "Notional";
            // 
            // gridtotal
            // 
            this.gridtotal.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.gridtotal.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Offering,
            this.NotionalTotal});
            this.gridtotal.Location = new System.Drawing.Point(1074, 41);
            this.gridtotal.Name = "gridtotal";
            this.gridtotal.Size = new System.Drawing.Size(403, 982);
            this.gridtotal.TabIndex = 2;
            // 
            // Offering
            // 
            this.Offering.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Offering.HeaderText = "Offering";
            this.Offering.Name = "Offering";
            // 
            // NotionalTotal
            // 
            this.NotionalTotal.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.NotionalTotal.HeaderText = "Notional";
            this.NotionalTotal.Name = "NotionalTotal";
            // 
            // gridDir
            // 
            this.gridDir.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.gridDir.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.dataGridViewTextBoxColumn1,
            this.Bullish,
            this.dataGridViewTextBoxColumn2});
            this.gridDir.Location = new System.Drawing.Point(1513, 41);
            this.gridDir.Name = "gridDir";
            this.gridDir.Size = new System.Drawing.Size(403, 982);
            this.gridDir.TabIndex = 3;
            // 
            // dataGridViewTextBoxColumn1
            // 
            this.dataGridViewTextBoxColumn1.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.dataGridViewTextBoxColumn1.HeaderText = "Offering";
            this.dataGridViewTextBoxColumn1.Name = "dataGridViewTextBoxColumn1";
            // 
            // Bullish
            // 
            this.Bullish.HeaderText = "Bullish";
            this.Bullish.Name = "Bullish";
            // 
            // dataGridViewTextBoxColumn2
            // 
            this.dataGridViewTextBoxColumn2.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.dataGridViewTextBoxColumn2.HeaderText = "Notional";
            this.dataGridViewTextBoxColumn2.Name = "dataGridViewTextBoxColumn2";
            // 
            // B_readCsv
            // 
            this.B_readCsv.Location = new System.Drawing.Point(102, 0);
            this.B_readCsv.Name = "B_readCsv";
            this.B_readCsv.Size = new System.Drawing.Size(75, 23);
            this.B_readCsv.TabIndex = 4;
            this.B_readCsv.Text = "read csv";
            this.B_readCsv.UseVisualStyleBackColor = true;
            this.B_readCsv.Click += new System.EventHandler(this.B_readCsv_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1946, 1064);
            this.Controls.Add(this.B_readCsv);
            this.Controls.Add(this.gridDir);
            this.Controls.Add(this.gridtotal);
            this.Controls.Add(this.grid1);
            this.Controls.Add(this.button1);
            this.Name = "Form1";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.grid1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridtotal)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.gridDir)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.DataGridView grid1;
        private System.Windows.Forms.DataGridViewTextBoxColumn Time;
        private System.Windows.Forms.DataGridViewTextBoxColumn Symbol;
        private System.Windows.Forms.DataGridViewTextBoxColumn Type;
        private System.Windows.Forms.DataGridViewTextBoxColumn Expiration;
        private System.Windows.Forms.DataGridViewTextBoxColumn Strike;
        private System.Windows.Forms.DataGridViewTextBoxColumn Side;
        private System.Windows.Forms.DataGridViewTextBoxColumn Notional;
        private System.Windows.Forms.DataGridView gridtotal;
        private System.Windows.Forms.DataGridViewTextBoxColumn Offering;
        private System.Windows.Forms.DataGridViewTextBoxColumn NotionalTotal;
        private System.Windows.Forms.DataGridView gridDir;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn1;
        private System.Windows.Forms.DataGridViewTextBoxColumn Bullish;
        private System.Windows.Forms.DataGridViewTextBoxColumn dataGridViewTextBoxColumn2;
        private System.Windows.Forms.Button B_readCsv;
    }
}

