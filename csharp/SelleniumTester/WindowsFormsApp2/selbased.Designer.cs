namespace WindowsFormsApp2
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
            this.button6 = new System.Windows.Forms.Button();
            this.button7 = new System.Windows.Forms.Button();
            this.button8 = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.button3 = new System.Windows.Forms.Button();
            this.button4 = new System.Windows.Forms.Button();
            this.button5 = new System.Windows.Forms.Button();
            this.button11 = new System.Windows.Forms.Button();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.TB_Address = new System.Windows.Forms.TextBox();
            this.B_runSubXPath = new System.Windows.Forms.Button();
            this.TB_subXPath = new System.Windows.Forms.TextBox();
            this.B_Clear = new System.Windows.Forms.Button();
            this.cb_options = new System.Windows.Forms.CheckBox();
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // button6
            // 
            this.button6.Location = new System.Drawing.Point(204, 11);
            this.button6.Margin = new System.Windows.Forms.Padding(2);
            this.button6.Name = "button6";
            this.button6.Size = new System.Drawing.Size(56, 28);
            this.button6.TabIndex = 7;
            this.button6.Text = "setup";
            this.button6.UseVisualStyleBackColor = true;
            this.button6.Click += new System.EventHandler(this.Button6_Click);
            // 
            // button7
            // 
            this.button7.Location = new System.Drawing.Point(560, 76);
            this.button7.Margin = new System.Windows.Forms.Padding(2);
            this.button7.Name = "button7";
            this.button7.Size = new System.Drawing.Size(98, 19);
            this.button7.TabIndex = 8;
            this.button7.Text = "page";
            this.button7.UseVisualStyleBackColor = true;
            this.button7.Click += new System.EventHandler(this.Button7_Click);
            // 
            // button8
            // 
            this.button8.Location = new System.Drawing.Point(11, 232);
            this.button8.Margin = new System.Windows.Forms.Padding(2);
            this.button8.Name = "button8";
            this.button8.Size = new System.Drawing.Size(59, 23);
            this.button8.TabIndex = 9;
            this.button8.Text = "close";
            this.button8.UseVisualStyleBackColor = true;
            this.button8.Click += new System.EventHandler(this.Button8_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(17, 101);
            this.textBox1.Margin = new System.Windows.Forms.Padding(2);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(295, 20);
            this.textBox1.TabIndex = 13;
            this.textBox1.TextChanged += new System.EventHandler(this.textBox1_TextChanged);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(316, 101);
            this.button3.Margin = new System.Windows.Forms.Padding(2);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(98, 20);
            this.button3.TabIndex = 14;
            this.button3.Text = "run xpath";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.Button3_Click);
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(378, 158);
            this.button4.Margin = new System.Windows.Forms.Padding(2);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(50, 20);
            this.button4.TabIndex = 15;
            this.button4.Text = "click we";
            this.button4.UseVisualStyleBackColor = true;
            this.button4.Click += new System.EventHandler(this.Button4_Click);
            // 
            // button5
            // 
            this.button5.Location = new System.Drawing.Point(432, 154);
            this.button5.Margin = new System.Windows.Forms.Padding(2);
            this.button5.Name = "button5";
            this.button5.Size = new System.Drawing.Size(50, 26);
            this.button5.TabIndex = 15;
            this.button5.Text = "space";
            this.button5.UseVisualStyleBackColor = true;
            this.button5.Click += new System.EventHandler(this.Button5_Click);
            // 
            // button11
            // 
            this.button11.Location = new System.Drawing.Point(244, 152);
            this.button11.Margin = new System.Windows.Forms.Padding(2);
            this.button11.Name = "button11";
            this.button11.Size = new System.Drawing.Size(62, 23);
            this.button11.TabIndex = 17;
            this.button11.Text = "text";
            this.button11.UseVisualStyleBackColor = true;
            this.button11.Click += new System.EventHandler(this.Button11_Click);
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(102, 154);
            this.textBox2.Margin = new System.Windows.Forms.Padding(2);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(138, 20);
            this.textBox2.TabIndex = 19;
            // 
            // TB_Address
            // 
            this.TB_Address.Location = new System.Drawing.Point(17, 77);
            this.TB_Address.Margin = new System.Windows.Forms.Padding(2);
            this.TB_Address.Name = "TB_Address";
            this.TB_Address.Size = new System.Drawing.Size(539, 20);
            this.TB_Address.TabIndex = 20;
            this.TB_Address.Text = "https://www.marketbeat.com/ratings/AllActions/";
            // 
            // B_runSubXPath
            // 
            this.B_runSubXPath.Location = new System.Drawing.Point(384, 125);
            this.B_runSubXPath.Margin = new System.Windows.Forms.Padding(2);
            this.B_runSubXPath.Name = "B_runSubXPath";
            this.B_runSubXPath.Size = new System.Drawing.Size(98, 20);
            this.B_runSubXPath.TabIndex = 22;
            this.B_runSubXPath.Text = "run sub xpath";
            this.B_runSubXPath.UseVisualStyleBackColor = true;
            this.B_runSubXPath.Click += new System.EventHandler(this.B_runSubXPath_Click);
            // 
            // TB_subXPath
            // 
            this.TB_subXPath.Location = new System.Drawing.Point(85, 125);
            this.TB_subXPath.Margin = new System.Windows.Forms.Padding(2);
            this.TB_subXPath.Name = "TB_subXPath";
            this.TB_subXPath.Size = new System.Drawing.Size(295, 20);
            this.TB_subXPath.TabIndex = 21;
            // 
            // B_Clear
            // 
            this.B_Clear.Location = new System.Drawing.Point(17, 152);
            this.B_Clear.Margin = new System.Windows.Forms.Padding(2);
            this.B_Clear.Name = "B_Clear";
            this.B_Clear.Size = new System.Drawing.Size(62, 23);
            this.B_Clear.TabIndex = 23;
            this.B_Clear.Text = "Clear";
            this.B_Clear.UseVisualStyleBackColor = true;
            this.B_Clear.Click += new System.EventHandler(this.B_Clear_Click);
            // 
            // cb_options
            // 
            this.cb_options.AutoSize = true;
            this.cb_options.Location = new System.Drawing.Point(17, 18);
            this.cb_options.Name = "cb_options";
            this.cb_options.Size = new System.Drawing.Size(115, 17);
            this.cb_options.TabIndex = 24;
            this.cb_options.Text = "automation options";
            this.cb_options.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(310, 154);
            this.button1.Margin = new System.Windows.Forms.Padding(2);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(62, 23);
            this.button1.TabIndex = 25;
            this.button1.Text = "REPLACE";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click_1);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(780, 266);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.cb_options);
            this.Controls.Add(this.B_Clear);
            this.Controls.Add(this.B_runSubXPath);
            this.Controls.Add(this.TB_subXPath);
            this.Controls.Add(this.TB_Address);
            this.Controls.Add(this.textBox2);
            this.Controls.Add(this.button11);
            this.Controls.Add(this.button5);
            this.Controls.Add(this.button4);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.button8);
            this.Controls.Add(this.button7);
            this.Controls.Add(this.button6);
            this.DoubleBuffered = true;
            this.Margin = new System.Windows.Forms.Padding(2);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Button button6;
        private System.Windows.Forms.Button button7;
        private System.Windows.Forms.Button button8;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.Button button5;
        private System.Windows.Forms.Button button11;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.TextBox TB_Address;
        private System.Windows.Forms.Button B_runSubXPath;
        private System.Windows.Forms.TextBox TB_subXPath;
        private System.Windows.Forms.Button B_Clear;
        private System.Windows.Forms.CheckBox cb_options;
        private System.Windows.Forms.Button button1;
    }
}

