'
' Created by SharpDevelop.
' User: User
' Date: 07/04/2023
' Time: 23:38
' 
' To change this template use Tools | Options | Coding | Edit Standard Headers.
'
Partial Class MainForm
	Inherits System.Windows.Forms.Form
	
	''' <summary>
	''' Designer variable used to keep track of non-visual components.
	''' </summary>
	Private components As System.ComponentModel.IContainer
	
	''' <summary>
	''' Disposes resources used by the form.
	''' </summary>
	''' <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
	Protected Overrides Sub Dispose(ByVal disposing As Boolean)
		If disposing Then
			If components IsNot Nothing Then
				components.Dispose()
			End If
		End If
		MyBase.Dispose(disposing)
	End Sub
	
	''' <summary>
	''' This method is required for Windows Forms designer support.
	''' Do not change the method contents inside the source code editor. The Forms designer might
	''' not be able to load this method if it was changed manually.
	''' </summary>
	Private Sub InitializeComponent()
		Me.components = New System.ComponentModel.Container()
		Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(MainForm))
		Me.label1 = New System.Windows.Forms.Label()
		Me.cbx_P0 = New System.Windows.Forms.ComboBox()
		Me.cbx_P1 = New System.Windows.Forms.ComboBox()
		Me.label2 = New System.Windows.Forms.Label()
		Me.cbx_serial_port = New System.Windows.Forms.ComboBox()
		Me.label3 = New System.Windows.Forms.Label()
		Me.btn_connect = New System.Windows.Forms.Button()
		Me.timer1 = New System.Windows.Forms.Timer(Me.components)
		Me.tbx_received = New System.Windows.Forms.TextBox()
		Me.cbx_P2 = New System.Windows.Forms.ComboBox()
		Me.label4 = New System.Windows.Forms.Label()
		Me.cbx_P3 = New System.Windows.Forms.ComboBox()
		Me.label5 = New System.Windows.Forms.Label()
		Me.cbx_P4 = New System.Windows.Forms.ComboBox()
		Me.label6 = New System.Windows.Forms.Label()
		Me.cbx_P5 = New System.Windows.Forms.ComboBox()
		Me.label7 = New System.Windows.Forms.Label()
		Me.cbx_P6 = New System.Windows.Forms.ComboBox()
		Me.label8 = New System.Windows.Forms.Label()
		Me.cbx_P7 = New System.Windows.Forms.ComboBox()
		Me.label10 = New System.Windows.Forms.Label()
		Me.cbx_P8 = New System.Windows.Forms.ComboBox()
		Me.label11 = New System.Windows.Forms.Label()
		Me.label12 = New System.Windows.Forms.Label()
		Me.label13 = New System.Windows.Forms.Label()
		Me.label14 = New System.Windows.Forms.Label()
		Me.textBox1 = New System.Windows.Forms.TextBox()
		Me.textBox2 = New System.Windows.Forms.TextBox()
		Me.textBox3 = New System.Windows.Forms.TextBox()
		Me.textBox4 = New System.Windows.Forms.TextBox()
		Me.textBox5 = New System.Windows.Forms.TextBox()
		Me.textBox6 = New System.Windows.Forms.TextBox()
		Me.textBox7 = New System.Windows.Forms.TextBox()
		Me.textBox8 = New System.Windows.Forms.TextBox()
		Me.textBox9 = New System.Windows.Forms.TextBox()
		Me.label15 = New System.Windows.Forms.Label()
		Me.textBox10 = New System.Windows.Forms.TextBox()
		Me.label16 = New System.Windows.Forms.Label()
		Me.btn_Set = New System.Windows.Forms.Button()
		Me.btn_Clear = New System.Windows.Forms.Button()
		Me.btn_Exit = New System.Windows.Forms.Button()
		Me.checkBox1 = New System.Windows.Forms.CheckBox()
		Me.textBox11 = New System.Windows.Forms.TextBox()
		Me.label9 = New System.Windows.Forms.Label()
		Me.label17 = New System.Windows.Forms.Label()
		Me.toolTip1 = New System.Windows.Forms.ToolTip(Me.components)
		Me.btn_LogClear = New System.Windows.Forms.Button()
		Me.btn_Load = New System.Windows.Forms.Button()
		Me.btn_Save = New System.Windows.Forms.Button()
		Me.saveFileDialog1 = New System.Windows.Forms.SaveFileDialog()
		Me.openFileDialog1 = New System.Windows.Forms.OpenFileDialog()
		Me.btn_Default = New System.Windows.Forms.Button()
		Me.SuspendLayout
		'
		'label1
		'
		Me.label1.Location = New System.Drawing.Point(17, 63)
		Me.label1.Name = "label1"
		Me.label1.Size = New System.Drawing.Size(99, 22)
		Me.label1.TabIndex = 0
		Me.label1.Text = "P0: Relay mode"
		'
		'cbx_P0
		'
		Me.cbx_P0.Enabled = false
		Me.cbx_P0.FormattingEnabled = true
		Me.cbx_P0.Location = New System.Drawing.Point(207, 60)
		Me.cbx_P0.Name = "cbx_P0"
		Me.cbx_P0.Size = New System.Drawing.Size(56, 21)
		Me.cbx_P0.TabIndex = 1
		Me.cbx_P0.Tag = "0"
		Me.toolTip1.SetToolTip(Me.cbx_P0, resources.GetString("cbx_P0.ToolTip"))
		AddHandler Me.cbx_P0.KeyPress, AddressOf Me.Cbx_P0KeyPress
		'
		'cbx_P1
		'
		Me.cbx_P1.Enabled = false
		Me.cbx_P1.FormattingEnabled = true
		Me.cbx_P1.Location = New System.Drawing.Point(207, 88)
		Me.cbx_P1.Name = "cbx_P1"
		Me.cbx_P1.Size = New System.Drawing.Size(56, 21)
		Me.cbx_P1.TabIndex = 3
		Me.cbx_P1.Tag = "1"
		Me.toolTip1.SetToolTip(Me.cbx_P1, "   - - Parameter P1: Hysteresis (Degree hysteresis (°C) to toggle relay)")
		AddHandler Me.cbx_P1.KeyPress, AddressOf Me.Cbx_P1KeyPress
		'
		'label2
		'
		Me.label2.Location = New System.Drawing.Point(17, 91)
		Me.label2.Name = "label2"
		Me.label2.Size = New System.Drawing.Size(99, 22)
		Me.label2.TabIndex = 2
		Me.label2.Text = "P1: Hysteresis"
		'
		'cbx_serial_port
		'
		Me.cbx_serial_port.FormattingEnabled = true
		Me.cbx_serial_port.Location = New System.Drawing.Point(514, 34)
		Me.cbx_serial_port.Name = "cbx_serial_port"
		Me.cbx_serial_port.Size = New System.Drawing.Size(106, 21)
		Me.cbx_serial_port.TabIndex = 6
		AddHandler Me.cbx_serial_port.KeyPress, AddressOf Me.Cbx_serial_portKeyPress
		'
		'label3
		'
		Me.label3.Location = New System.Drawing.Point(514, 9)
		Me.label3.Name = "label3"
		Me.label3.Size = New System.Drawing.Size(65, 18)
		Me.label3.TabIndex = 5
		Me.label3.Text = "Serial port:"
		'
		'btn_connect
		'
		Me.btn_connect.Location = New System.Drawing.Point(514, 115)
		Me.btn_connect.Name = "btn_connect"
		Me.btn_connect.Size = New System.Drawing.Size(106, 45)
		Me.btn_connect.TabIndex = 7
		Me.btn_connect.Text = "Connect"
		Me.btn_connect.UseVisualStyleBackColor = true
		AddHandler Me.btn_connect.Click, AddressOf Me.Btn_connectClick
		'
		'timer1
		'
		AddHandler Me.timer1.Tick, AddressOf Me.Timer1Tick
		'
		'tbx_received
		'
		Me.tbx_received.Location = New System.Drawing.Point(514, 89)
		Me.tbx_received.Name = "tbx_received"
		Me.tbx_received.Size = New System.Drawing.Size(106, 20)
		Me.tbx_received.TabIndex = 8
		AddHandler Me.tbx_received.KeyPress, AddressOf Me.Tbx_receivedKeyPress
		'
		'cbx_P2
		'
		Me.cbx_P2.Enabled = false
		Me.cbx_P2.FormattingEnabled = true
		Me.cbx_P2.Location = New System.Drawing.Point(207, 115)
		Me.cbx_P2.Name = "cbx_P2"
		Me.cbx_P2.Size = New System.Drawing.Size(56, 21)
		Me.cbx_P2.TabIndex = 10
		Me.cbx_P2.Tag = "2"
		Me.toolTip1.SetToolTip(Me.cbx_P2, "   - - Parameter P2: Up limit"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (Used in the alert indication; Activated "& _ 
				"in Parameter P6)"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (Used in Alarm mode Parameter P0: A1 and A2)")
		AddHandler Me.cbx_P2.KeyPress, AddressOf Me.Cbx_P2KeyPress
		'
		'label4
		'
		Me.label4.Location = New System.Drawing.Point(17, 118)
		Me.label4.Name = "label4"
		Me.label4.Size = New System.Drawing.Size(99, 22)
		Me.label4.TabIndex = 9
		Me.label4.Text = "P2: Up limit"
		'
		'cbx_P3
		'
		Me.cbx_P3.Enabled = false
		Me.cbx_P3.FormattingEnabled = true
		Me.cbx_P3.Location = New System.Drawing.Point(207, 142)
		Me.cbx_P3.Name = "cbx_P3"
		Me.cbx_P3.Size = New System.Drawing.Size(56, 21)
		Me.cbx_P3.TabIndex = 12
		Me.cbx_P3.Tag = "3"
		Me.toolTip1.SetToolTip(Me.cbx_P3, "   - - Parameter P3: Down limit"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (Used in the alert indication; Activate"& _ 
				"d in P6)"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (Used in Alarm mode Parameter P0: A1 and A2)")
		AddHandler Me.cbx_P3.KeyPress, AddressOf Me.Cbx_P3KeyPress
		'
		'label5
		'
		Me.label5.Location = New System.Drawing.Point(17, 145)
		Me.label5.Name = "label5"
		Me.label5.Size = New System.Drawing.Size(99, 22)
		Me.label5.TabIndex = 11
		Me.label5.Text = "P3: Down limit"
		'
		'cbx_P4
		'
		Me.cbx_P4.Enabled = false
		Me.cbx_P4.FormattingEnabled = true
		Me.cbx_P4.Location = New System.Drawing.Point(207, 169)
		Me.cbx_P4.Name = "cbx_P4"
		Me.cbx_P4.Size = New System.Drawing.Size(56, 21)
		Me.cbx_P4.TabIndex = 14
		Me.cbx_P4.Tag = "4"
		Me.toolTip1.SetToolTip(Me.cbx_P4, "   - - Parameter P4: Temperature sensor offset"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (From -7.0 up to +7.0)")
		AddHandler Me.cbx_P4.KeyPress, AddressOf Me.Cbx_P4KeyPress
		'
		'label6
		'
		Me.label6.Location = New System.Drawing.Point(17, 172)
		Me.label6.Name = "label6"
		Me.label6.Size = New System.Drawing.Size(99, 22)
		Me.label6.TabIndex = 13
		Me.label6.Text = "P4: Sensor offset"
		'
		'cbx_P5
		'
		Me.cbx_P5.Enabled = false
		Me.cbx_P5.FormattingEnabled = true
		Me.cbx_P5.Location = New System.Drawing.Point(207, 196)
		Me.cbx_P5.Name = "cbx_P5"
		Me.cbx_P5.Size = New System.Drawing.Size(56, 21)
		Me.cbx_P5.TabIndex = 16
		Me.cbx_P5.Tag = "5"
		Me.toolTip1.SetToolTip(Me.cbx_P5, "   - - Parameter P5: Delay time before activating the relay"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (From 0 to "& _ 
				"10 minutes)"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (Does not affect relay deactivation, deactivation is immed"& _ 
				"iate)")
		AddHandler Me.cbx_P5.KeyPress, AddressOf Me.Cbx_P5KeyPress
		'
		'label7
		'
		Me.label7.Location = New System.Drawing.Point(17, 199)
		Me.label7.Name = "label7"
		Me.label7.Size = New System.Drawing.Size(122, 22)
		Me.label7.TabIndex = 15
		Me.label7.Text = "P5: Delay timer (min)"
		'
		'cbx_P6
		'
		Me.cbx_P6.Enabled = false
		Me.cbx_P6.FormattingEnabled = true
		Me.cbx_P6.Location = New System.Drawing.Point(207, 223)
		Me.cbx_P6.Name = "cbx_P6"
		Me.cbx_P6.Size = New System.Drawing.Size(56, 21)
		Me.cbx_P6.TabIndex = 18
		Me.cbx_P6.Tag = "6"
		Me.toolTip1.SetToolTip(Me.cbx_P6, "   - - Parameter P6: ON/OFF"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (Alert mode; Need setup Parameter P2 and P3"& _ 
				"; The display flashes when the temperature is outside the configured range.)")
		AddHandler Me.cbx_P6.KeyPress, AddressOf Me.Cbx_P6KeyPress
		'
		'label8
		'
		Me.label8.Location = New System.Drawing.Point(17, 226)
		Me.label8.Name = "label8"
		Me.label8.Size = New System.Drawing.Size(99, 22)
		Me.label8.TabIndex = 17
		Me.label8.Text = "P6: Alert mode"
		'
		'cbx_P7
		'
		Me.cbx_P7.Enabled = false
		Me.cbx_P7.FormattingEnabled = true
		Me.cbx_P7.Location = New System.Drawing.Point(207, 248)
		Me.cbx_P7.Name = "cbx_P7"
		Me.cbx_P7.Size = New System.Drawing.Size(56, 21)
		Me.cbx_P7.TabIndex = 22
		Me.cbx_P7.Tag = "7"
		Me.toolTip1.SetToolTip(Me.cbx_P7, "   - - Parameter P7: ON/OFF"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (Threshold value change access blocking)"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&" "& _ 
				"  - - - (Factory reset lockout with Up ""+"" and Down ""-"" keys)")
		AddHandler Me.cbx_P7.KeyPress, AddressOf Me.Cbx_P7KeyPress
		'
		'label10
		'
		Me.label10.Location = New System.Drawing.Point(17, 251)
		Me.label10.Name = "label10"
		Me.label10.Size = New System.Drawing.Size(99, 22)
		Me.label10.TabIndex = 21
		Me.label10.Text = "P7: Threshold lock"
		'
		'cbx_P8
		'
		Me.cbx_P8.Enabled = false
		Me.cbx_P8.FormattingEnabled = true
		Me.cbx_P8.Location = New System.Drawing.Point(207, 275)
		Me.cbx_P8.Name = "cbx_P8"
		Me.cbx_P8.Size = New System.Drawing.Size(56, 21)
		Me.cbx_P8.TabIndex = 24
		Me.cbx_P8.Tag = "8"
		Me.toolTip1.SetToolTip(Me.cbx_P8, "   - - Parameter P8: ON/OFF"&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)&"   - - - (Automatic brightness reduction after 15 se"& _ 
				"conds)")
		AddHandler Me.cbx_P8.KeyPress, AddressOf Me.Cbx_P8KeyPress
		'
		'label11
		'
		Me.label11.Location = New System.Drawing.Point(17, 278)
		Me.label11.Name = "label11"
		Me.label11.Size = New System.Drawing.Size(99, 22)
		Me.label11.TabIndex = 23
		Me.label11.Text = "P8: Auto brightness"
		'
		'label12
		'
		Me.label12.Location = New System.Drawing.Point(17, 9)
		Me.label12.Name = "label12"
		Me.label12.Size = New System.Drawing.Size(99, 22)
		Me.label12.TabIndex = 25
		Me.label12.Text = "Parameters"
		'
		'label13
		'
		Me.label13.Location = New System.Drawing.Point(145, 9)
		Me.label13.Name = "label13"
		Me.label13.Size = New System.Drawing.Size(61, 22)
		Me.label13.TabIndex = 26
		Me.label13.Text = "Status"
		'
		'label14
		'
		Me.label14.Location = New System.Drawing.Point(207, 9)
		Me.label14.Name = "label14"
		Me.label14.Size = New System.Drawing.Size(61, 22)
		Me.label14.TabIndex = 27
		Me.label14.Text = "Adjust"
		'
		'textBox1
		'
		Me.textBox1.Location = New System.Drawing.Point(145, 60)
		Me.textBox1.Name = "textBox1"
		Me.textBox1.Size = New System.Drawing.Size(56, 20)
		Me.textBox1.TabIndex = 28
		Me.textBox1.Tag = "0"
		AddHandler Me.textBox1.KeyPress, AddressOf Me.TextBox1KeyPress
		'
		'textBox2
		'
		Me.textBox2.Location = New System.Drawing.Point(145, 88)
		Me.textBox2.Name = "textBox2"
		Me.textBox2.Size = New System.Drawing.Size(56, 20)
		Me.textBox2.TabIndex = 29
		Me.textBox2.Tag = "1"
		AddHandler Me.textBox2.KeyPress, AddressOf Me.TextBox2KeyPress
		'
		'textBox3
		'
		Me.textBox3.Location = New System.Drawing.Point(145, 115)
		Me.textBox3.Name = "textBox3"
		Me.textBox3.Size = New System.Drawing.Size(56, 20)
		Me.textBox3.TabIndex = 31
		Me.textBox3.Tag = "2"
		AddHandler Me.textBox3.KeyPress, AddressOf Me.TextBox3KeyPress
		'
		'textBox4
		'
		Me.textBox4.Location = New System.Drawing.Point(145, 142)
		Me.textBox4.Name = "textBox4"
		Me.textBox4.Size = New System.Drawing.Size(56, 20)
		Me.textBox4.TabIndex = 30
		Me.textBox4.Tag = "3"
		AddHandler Me.textBox4.KeyPress, AddressOf Me.TextBox4KeyPress
		'
		'textBox5
		'
		Me.textBox5.Location = New System.Drawing.Point(145, 169)
		Me.textBox5.Name = "textBox5"
		Me.textBox5.Size = New System.Drawing.Size(56, 20)
		Me.textBox5.TabIndex = 35
		Me.textBox5.Tag = "4"
		AddHandler Me.textBox5.KeyPress, AddressOf Me.TextBox5KeyPress
		'
		'textBox6
		'
		Me.textBox6.Location = New System.Drawing.Point(145, 196)
		Me.textBox6.Name = "textBox6"
		Me.textBox6.Size = New System.Drawing.Size(56, 20)
		Me.textBox6.TabIndex = 34
		Me.textBox6.Tag = "5"
		AddHandler Me.textBox6.KeyPress, AddressOf Me.TextBox6KeyPress
		'
		'textBox7
		'
		Me.textBox7.Location = New System.Drawing.Point(145, 222)
		Me.textBox7.Name = "textBox7"
		Me.textBox7.Size = New System.Drawing.Size(56, 20)
		Me.textBox7.TabIndex = 33
		Me.textBox7.Tag = "6"
		AddHandler Me.textBox7.KeyPress, AddressOf Me.TextBox7KeyPress
		'
		'textBox8
		'
		Me.textBox8.Location = New System.Drawing.Point(145, 248)
		Me.textBox8.Name = "textBox8"
		Me.textBox8.Size = New System.Drawing.Size(56, 20)
		Me.textBox8.TabIndex = 37
		Me.textBox8.Tag = "7"
		AddHandler Me.textBox8.KeyPress, AddressOf Me.TextBox8KeyPress
		'
		'textBox9
		'
		Me.textBox9.Location = New System.Drawing.Point(145, 275)
		Me.textBox9.Name = "textBox9"
		Me.textBox9.Size = New System.Drawing.Size(56, 20)
		Me.textBox9.TabIndex = 36
		Me.textBox9.Tag = "8"
		AddHandler Me.textBox9.KeyPress, AddressOf Me.TextBox9KeyPress
		'
		'label15
		'
		Me.label15.Location = New System.Drawing.Point(514, 65)
		Me.label15.Name = "label15"
		Me.label15.Size = New System.Drawing.Size(106, 18)
		Me.label15.TabIndex = 39
		Me.label15.Text = "B/s: (9600 bauds)"
		'
		'textBox10
		'
		Me.textBox10.Location = New System.Drawing.Point(145, 35)
		Me.textBox10.Name = "textBox10"
		Me.textBox10.Size = New System.Drawing.Size(56, 20)
		Me.textBox10.TabIndex = 41
		Me.textBox10.Tag = "9"
		AddHandler Me.textBox10.KeyPress, AddressOf Me.TextBox10KeyPress
		'
		'label16
		'
		Me.label16.Location = New System.Drawing.Point(17, 38)
		Me.label16.Name = "label16"
		Me.label16.Size = New System.Drawing.Size(99, 22)
		Me.label16.TabIndex = 40
		Me.label16.Text = "NTC: Temperature"
		'
		'btn_Set
		'
		Me.btn_Set.Location = New System.Drawing.Point(269, 196)
		Me.btn_Set.Name = "btn_Set"
		Me.btn_Set.Size = New System.Drawing.Size(106, 45)
		Me.btn_Set.TabIndex = 42
		Me.btn_Set.Text = "Send config"
		Me.btn_Set.UseVisualStyleBackColor = true
		AddHandler Me.btn_Set.Click, AddressOf Me.Btn_SetClick
		'
		'btn_Clear
		'
		Me.btn_Clear.Location = New System.Drawing.Point(269, 251)
		Me.btn_Clear.Name = "btn_Clear"
		Me.btn_Clear.Size = New System.Drawing.Size(106, 45)
		Me.btn_Clear.TabIndex = 43
		Me.btn_Clear.Text = "Clear config"
		Me.btn_Clear.UseVisualStyleBackColor = true
		AddHandler Me.btn_Clear.Click, AddressOf Me.Btn_ClearClick
		'
		'btn_Exit
		'
		Me.btn_Exit.Location = New System.Drawing.Point(514, 169)
		Me.btn_Exit.Name = "btn_Exit"
		Me.btn_Exit.Size = New System.Drawing.Size(106, 45)
		Me.btn_Exit.TabIndex = 44
		Me.btn_Exit.Text = "Exit"
		Me.btn_Exit.UseVisualStyleBackColor = true
		AddHandler Me.btn_Exit.Click, AddressOf Me.Btn_ExitClick
		'
		'checkBox1
		'
		Me.checkBox1.Checked = true
		Me.checkBox1.CheckState = System.Windows.Forms.CheckState.Checked
		Me.checkBox1.Location = New System.Drawing.Point(207, 32)
		Me.checkBox1.Name = "checkBox1"
		Me.checkBox1.Size = New System.Drawing.Size(51, 27)
		Me.checkBox1.TabIndex = 45
		Me.checkBox1.Text = "Lock"
		Me.toolTip1.SetToolTip(Me.checkBox1, "Blocks application command selection")
		Me.checkBox1.UseVisualStyleBackColor = true
		AddHandler Me.checkBox1.CheckedChanged, AddressOf Me.CheckBox1CheckedChanged
		'
		'textBox11
		'
		Me.textBox11.Font = New System.Drawing.Font("Consolas", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0,Byte))
		Me.textBox11.Location = New System.Drawing.Point(12, 321)
		Me.textBox11.Multiline = true
		Me.textBox11.Name = "textBox11"
		Me.textBox11.Size = New System.Drawing.Size(608, 120)
		Me.textBox11.TabIndex = 46
		AddHandler Me.textBox11.KeyPress, AddressOf Me.TextBox11KeyPress
		'
		'label9
		'
		Me.label9.ForeColor = System.Drawing.SystemColors.AppWorkspace
		Me.label9.Location = New System.Drawing.Point(514, 222)
		Me.label9.Name = "label9"
		Me.label9.Size = New System.Drawing.Size(106, 18)
		Me.label9.TabIndex = 47
		Me.label9.Text = "by RTEK1000"
		Me.label9.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		'
		'label17
		'
		Me.label17.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
		Me.label17.Font = New System.Drawing.Font("Microsoft Sans Serif", 14.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0,Byte))
		Me.label17.ForeColor = System.Drawing.Color.Red
		Me.label17.Location = New System.Drawing.Point(269, 35)
		Me.label17.Name = "label17"
		Me.label17.Size = New System.Drawing.Size(228, 99)
		Me.label17.TabIndex = 48
		Me.label17.Text = "Warning! Changing data remotely can cause output relay activation."&Global.Microsoft.VisualBasic.ChrW(13)&Global.Microsoft.VisualBasic.ChrW(10)
		Me.label17.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		'
		'btn_LogClear
		'
		Me.btn_LogClear.Location = New System.Drawing.Point(514, 250)
		Me.btn_LogClear.Name = "btn_LogClear"
		Me.btn_LogClear.Size = New System.Drawing.Size(106, 45)
		Me.btn_LogClear.TabIndex = 49
		Me.btn_LogClear.Text = "Clear log"
		Me.btn_LogClear.UseVisualStyleBackColor = true
		AddHandler Me.btn_LogClear.Click, AddressOf Me.Btn_LogClearClick
		'
		'btn_Load
		'
		Me.btn_Load.Location = New System.Drawing.Point(391, 195)
		Me.btn_Load.Name = "btn_Load"
		Me.btn_Load.Size = New System.Drawing.Size(106, 45)
		Me.btn_Load.TabIndex = 50
		Me.btn_Load.Text = "Load file"
		Me.btn_Load.UseVisualStyleBackColor = true
		AddHandler Me.btn_Load.Click, AddressOf Me.Btn_LoadClick
		'
		'btn_Save
		'
		Me.btn_Save.Location = New System.Drawing.Point(391, 251)
		Me.btn_Save.Name = "btn_Save"
		Me.btn_Save.Size = New System.Drawing.Size(106, 45)
		Me.btn_Save.TabIndex = 51
		Me.btn_Save.Text = "Save file"
		Me.btn_Save.UseVisualStyleBackColor = true
		AddHandler Me.btn_Save.Click, AddressOf Me.Btn_SaveClick
		'
		'openFileDialog1
		'
		Me.openFileDialog1.FileName = "openFileDialog1"
		'
		'btn_Default
		'
		Me.btn_Default.Location = New System.Drawing.Point(269, 142)
		Me.btn_Default.Name = "btn_Default"
		Me.btn_Default.Size = New System.Drawing.Size(106, 45)
		Me.btn_Default.TabIndex = 52
		Me.btn_Default.Text = "Load default"
		Me.btn_Default.UseVisualStyleBackColor = true
		AddHandler Me.btn_Default.Click, AddressOf Me.Btn_DefaultClick
		'
		'MainForm
		'
		Me.AutoScaleDimensions = New System.Drawing.SizeF(6!, 13!)
		Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		Me.ClientSize = New System.Drawing.Size(632, 453)
		Me.Controls.Add(Me.btn_Default)
		Me.Controls.Add(Me.btn_Save)
		Me.Controls.Add(Me.btn_Load)
		Me.Controls.Add(Me.btn_LogClear)
		Me.Controls.Add(Me.label17)
		Me.Controls.Add(Me.label9)
		Me.Controls.Add(Me.textBox11)
		Me.Controls.Add(Me.checkBox1)
		Me.Controls.Add(Me.btn_Exit)
		Me.Controls.Add(Me.btn_Clear)
		Me.Controls.Add(Me.btn_Set)
		Me.Controls.Add(Me.textBox10)
		Me.Controls.Add(Me.label16)
		Me.Controls.Add(Me.label15)
		Me.Controls.Add(Me.textBox8)
		Me.Controls.Add(Me.textBox9)
		Me.Controls.Add(Me.textBox5)
		Me.Controls.Add(Me.textBox6)
		Me.Controls.Add(Me.textBox7)
		Me.Controls.Add(Me.textBox3)
		Me.Controls.Add(Me.textBox4)
		Me.Controls.Add(Me.textBox2)
		Me.Controls.Add(Me.textBox1)
		Me.Controls.Add(Me.label14)
		Me.Controls.Add(Me.label13)
		Me.Controls.Add(Me.label12)
		Me.Controls.Add(Me.cbx_P8)
		Me.Controls.Add(Me.label11)
		Me.Controls.Add(Me.cbx_P7)
		Me.Controls.Add(Me.label10)
		Me.Controls.Add(Me.cbx_P6)
		Me.Controls.Add(Me.label8)
		Me.Controls.Add(Me.cbx_P5)
		Me.Controls.Add(Me.label7)
		Me.Controls.Add(Me.cbx_P4)
		Me.Controls.Add(Me.label6)
		Me.Controls.Add(Me.cbx_P3)
		Me.Controls.Add(Me.label5)
		Me.Controls.Add(Me.cbx_P2)
		Me.Controls.Add(Me.label4)
		Me.Controls.Add(Me.tbx_received)
		Me.Controls.Add(Me.btn_connect)
		Me.Controls.Add(Me.cbx_serial_port)
		Me.Controls.Add(Me.label3)
		Me.Controls.Add(Me.cbx_P1)
		Me.Controls.Add(Me.label2)
		Me.Controls.Add(Me.cbx_P0)
		Me.Controls.Add(Me.label1)
		Me.Name = "MainForm"
		Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
		Me.Text = "W1209_Remote_Test"
		AddHandler FormClosing, AddressOf Me.MainFormFormClosing
		AddHandler Load, AddressOf Me.MainFormLoad
		Me.ResumeLayout(false)
		Me.PerformLayout
	End Sub
	Private btn_Default As System.Windows.Forms.Button
	Private openFileDialog1 As System.Windows.Forms.OpenFileDialog
	Private saveFileDialog1 As System.Windows.Forms.SaveFileDialog
	Private btn_Save As System.Windows.Forms.Button
	Private btn_Load As System.Windows.Forms.Button
	Private btn_LogClear As System.Windows.Forms.Button
	Private toolTip1 As System.Windows.Forms.ToolTip
	Private label17 As System.Windows.Forms.Label
	Private label9 As System.Windows.Forms.Label
	Private textBox11 As System.Windows.Forms.TextBox
	Private checkBox1 As System.Windows.Forms.CheckBox
	Private btn_Exit As System.Windows.Forms.Button
	Private btn_Clear As System.Windows.Forms.Button
	Private btn_Set As System.Windows.Forms.Button
	Private label16 As System.Windows.Forms.Label
	Private textBox10 As System.Windows.Forms.TextBox
	Private label15 As System.Windows.Forms.Label
	Private textBox9 As System.Windows.Forms.TextBox
	Private textBox8 As System.Windows.Forms.TextBox
	Private textBox7 As System.Windows.Forms.TextBox
	Private textBox6 As System.Windows.Forms.TextBox
	Private textBox5 As System.Windows.Forms.TextBox
	Private textBox4 As System.Windows.Forms.TextBox
	Private textBox3 As System.Windows.Forms.TextBox
	Private textBox2 As System.Windows.Forms.TextBox
	Private textBox1 As System.Windows.Forms.TextBox
	Private label14 As System.Windows.Forms.Label
	Private label13 As System.Windows.Forms.Label
	Private label12 As System.Windows.Forms.Label
	Private label11 As System.Windows.Forms.Label
	Private cbx_P8 As System.Windows.Forms.ComboBox
	Private label10 As System.Windows.Forms.Label
	Private cbx_P7 As System.Windows.Forms.ComboBox
	Private label8 As System.Windows.Forms.Label
	Private cbx_P6 As System.Windows.Forms.ComboBox
	Private label7 As System.Windows.Forms.Label
	Private cbx_P5 As System.Windows.Forms.ComboBox
	Private label6 As System.Windows.Forms.Label
	Private cbx_P4 As System.Windows.Forms.ComboBox
	Private label5 As System.Windows.Forms.Label
	Private cbx_P3 As System.Windows.Forms.ComboBox
	Private label4 As System.Windows.Forms.Label
	Private cbx_P2 As System.Windows.Forms.ComboBox
	Private tbx_received As System.Windows.Forms.TextBox
	Private timer1 As System.Windows.Forms.Timer
	Private btn_connect As System.Windows.Forms.Button
	Private label3 As System.Windows.Forms.Label
	Private cbx_serial_port As System.Windows.Forms.ComboBox
	Private label2 As System.Windows.Forms.Label
	Private cbx_P1 As System.Windows.Forms.ComboBox
	Private cbx_P0 As System.Windows.Forms.ComboBox
	Private label1 As System.Windows.Forms.Label
End Class
