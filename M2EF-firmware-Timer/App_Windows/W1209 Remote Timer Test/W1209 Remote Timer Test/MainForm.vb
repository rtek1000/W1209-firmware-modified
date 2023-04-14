'
' W1209 remote Timer test (serial port 9600 bauds)
' 
' SharpDevelop Version : 4.4.2.9749-39bf891c
' .NET Version         : 4.0.30319.42000
'
' Created by SharpDevelop.
' User: RTEK1000
' Date: 11/04/2023
' Time: 12:25
' 
Imports System.IO
Imports System.IO.Ports.SerialPort
Imports System.Collections
Imports System.Threading.Thread
'Imports System.ComponentModel
'Imports System.Windows.Forms.DataVisualization.Charting

Public Partial Class MainForm	
    Private WithEvents serial As New IO.Ports.SerialPort
    
    dim bauds As Integer = 9600
    Dim received_int As Integer
    Dim received_str1(10) As String
    Dim btn_restart_feedback As String = "Restart"
    Dim received_str As String
    Dim str_log As String = ""
    Dim serial_close As Boolean = False
    Dim timer_counter As Integer = 0
    Dim relayModeStr() As String = {"0", "1", "2", _
    	"3", "4", "5"}
    
    Dim textboxes As TextBox()
    Dim comboboxes As ComboBox()
    
    Dim params_default() As String = {"0", "1", "0", _
    	"0", "1", "0", "0", "OFF", "OFF", "0"}
    
	Public Sub New()
		' The Me.InitializeComponent call is required for Windows Forms designer support.
		Me.InitializeComponent()
		
		'
		' TODO : Add constructor code after InitializeComponents
		'
	End Sub
	
	Sub MainFormLoad(sender As Object, e As EventArgs)	
'		With Chart1.ChartAreas(0)
'            .AxisX.MajorGrid.Enabled = False
'            .AxisY.MajorGrid.Enabled = False
'            .AxisX.MajorGrid.LineColor = Color.Coral
'            .AxisY.MajorGrid.LineColor = Color.Coral
'            .BackColor = Color.Transparent
'		End With
'		
'		PlotChart()
		        
		GetSerialPortNames
		
		For i As Integer = 5 To 0 Step -1
			Cbx_P0.Items.Add(relayModeStr(i))
		Next
		
		For i As Integer = 0 To 999 Step 1
			cbx_P1.Items.Add(i.ToString("#0"))
		Next
				
		For i As Integer = 0 To 59 Step 1
			cbx_P2.Items.Add(i.ToString("#0"))
		Next
				
		For i As Integer = 0 To 999 Step 1
			cbx_P3.Items.Add(i.ToString("#0"))
		Next
				
		For i As Integer = 0 To 999 Step 1
			cbx_P4.Items.Add(i.ToString("#0"))
		Next
				
		For i As Integer = 0 To 59 Step 1
			cbx_P5.Items.Add(i.ToString("#0"))
		Next
		
		For i As Integer = 0 To 999 Step 1
			cbx_P6.Items.Add(i.ToString("#0"))
		Next
					
		cbx_P7.Items.Add("ON")
		cbx_P7.Items.Add("OFF")
					
		cbx_P8.Items.Add("ON")
		cbx_P8.Items.Add("OFF")					
					
		textboxes = New TextBox() {textBox1, textBox2, textBox3, _
			textBox4, textBox5, textBox6, textBox7, _
			textBox8, textBox9, textBox10}
		
		comboboxes = New ComboBox() {cbx_P0, cbx_P1, cbx_P2, _
			cbx_P3, cbx_P4, cbx_P5, cbx_P6, cbx_P7, cbx_P8}
		
		For i As Integer = 0 To 8 
			comboboxes(i).Text = params_default(i)
		Next					
		
	End Sub
	
	Sub GetSerialPortNames()
	    For Each sp As String In My.Computer.Ports.SerialPortNames
	        cbx_serial_port.Items.Add(sp)
	    Next
	    
	    If cbx_serial_port.Items.Count > 0 Then
		    cbx_serial_port.Text = cbx_serial_port.Items.Item(0).ToString
	    End If
    
	End Sub
	
    Private Sub serial_DataReceived(ByVal sender As Object, ByVal e As System.IO.Ports.SerialDataReceivedEventArgs) Handles serial.DataReceived
    	Dim strReceived As String = ""
    	Dim int1 As Integer = 0
    	
    	If serial.IsOpen Then
    		Try
		    	strReceived = serial.ReadLine
    		Catch
    			
    		End Try
    	End If
    	
    	Dim max_length As Integer = str_log.Length
    	
    	If max_length > 850 Then
    		max_length = 850
    	End If
    	
    	str_log = strReceived & " " & str_log.Substring(0, max_length)
    	
    	If strReceived.Length = 11 Then    		
    		received_int = received_int + strReceived.Length
    		
    		Dim buff_str As String = strReceived
    		
    		Dim buffer As Byte() = System.Text.Encoding.UTF8.GetBytes(strReceived)
    		calcCheckSum(buff_str, True, int1)
    		
    		Dim value1 As Double = Val(strReceived.Substring(2, 5)) * 10
    		
    		Dim str1 As String = value1.ToString("#0")
    		
    		If int1 >= 0 Then
	    		Dim index As Integer = buffer(1) - 65
	    			    		
	    		If index >= 0 And index <= 8 Then
	    			received_str1(index) = str1 '.Replace(".", "")
	    		Else If index = 9 Then ' J
	    			If str1 = "0" Then
	    				btn_restart_feedback = "Restart"
	    			Else
	    				btn_restart_feedback = "Stop" 
	    			End If
	    		Else If index = 19 Then ' T
	    			received_str1(10) = str1 '.Replace(".", "")
	    		End If
    		End If
    		
			'PA000.0128
			'PB002.0125
			'PC110.0124
			'PD-50.0123
			'PE000.3121
			'PF000.2121
			'PG000.1121
			'PH000.1120
			'PI000.1119
			'PJ024.6107
			'PT025.4098
    	End If
        
    End Sub
	
	Sub MainFormFormClosing(sender As Object, e As FormClosingEventArgs)
        If serial.IsOpen Then serial.Close()
	End Sub
	
	Sub Btn_connectClick(sender As Object, e As EventArgs)
		If cbx_serial_port.Text = "" Then
			MsgBox("Error select port")
			
			Return
		End If
		
		If Btn_connect.Text = "Connect" Then
			serial.BaudRate = bauds
			serial.PortName = cbx_serial_port.Text
			
			Try
				If Not serial.IsOpen Then
					serial.Open()
				End If
				
				Btn_connect.Text = "Disconnect"
				
				Timer1.Enabled = True
			Catch
				MsgBox("Error serial.Open")
			End Try
		Else
			serial_close = True
			Try
				If serial.IsOpen Then
				serial.Close()
				End If
				
				Btn_connect.Text = "Connect"
				
				Timer1.Enabled = False
			Catch
				MsgBox("Error serial.Close")
			End Try
			
		End If
	End Sub
	
	Sub Timer1Tick(sender As Object, e As EventArgs)
		If timer_counter < 10 Then
			timer_counter = timer_counter + 1
		Else
			timer_counter = 0
			
			tbx_received.Text =  received_int.ToString
			
			received_int = 0	
		End If
		
		Dim int1 As Integer = CInt(Val(received_str1(0)) * 10)
		
		textboxes(0).Text = relayModeStr(CInt(int1 / 10))
		
		For i As Integer = 1 To 6
			textboxes(i).Text = received_str1(i)
		Next
		
		For i As Integer = 7 To 8
			If Val(received_str1(i)) > 0 Then
				textboxes(i).Text = "ON"
			Else
				textboxes(i).Text = "OFF"
			End If
		Next
		
		textBox10.Text = received_str1(10)
		
		TextBox11.Text = str_log
		
		btn_restart.Text = btn_restart_feedback
	End Sub
	
	Sub calcCheckSum(ByRef buffer As String, _set_buffer As Boolean, ByRef _result As Integer) 
		Dim result As Integer = 0
		Dim sum As Integer = 0
		Dim sum100 As Integer = 0
		Dim sum10 As Integer = 0
		Dim sum1 As Integer = 0
		
		If buffer.Length < 7 Then
			Return
		End If
	
		For i As Integer = 0 To 6
			sum = sum + Asc(buffer(i))
		Next
		
		sum = sum And &HFF
	
		sum = &HFF - sum
	
		result = sum
	
		If buffer.Length >= 10 Then
			If _set_buffer = True Then
				sum100 = sum \ 100
				sum -= sum100 * 100
				sum10 = sum \ 10
				sum -= sum10 * 10
				sum1 = sum
		
				sum100 = sum100 + 48
				sum10 = sum10 + 48
				sum1 = sum1 + 48
		
				If (sum100 <> Asc(buffer(7))) Or _
					(sum10 <> Asc(buffer(8))) Or (sum1 <> Asc(buffer(9))) Then
						result = -1
				End If
			
				buffer = buffer.Remove(7, 1).Insert(7, Chr(sum100))
				buffer = buffer.Remove(8, 1).Insert(8, Chr(sum10))
				buffer = buffer.Remove(9, 1).Insert(9, Chr(sum1))
		
				'buffer(7) = Chr(sum100)
				'buffer(8) = Chr(sum10)
				'buffer(9) = Chr(sum1)
			End If
		End If
		_result = result
	End Sub
	
	Sub Btn_SetClick(sender As Object, e As EventArgs)
		If serial.IsOpen Then
			btn_restart.Enabled = False
			btn_Set.Enabled = False
			
			Dim cbxTestCnt As Integer = 0
			
			For i As Integer = 0 To 8 
				If comboboxes(i).Text <> "" Then
					cbxTestCnt = cbxTestCnt + 1
				End If
			Next
			
			If cbxTestCnt = 0 Then
				MsgBox("Need to set a command")
			Else
				Dim result As Integer = MsgBox("Confirm command?", vbOKCancel)
				
				If result <> vbOK Then
					Return
				End If
			End If
			
			Dim str1 As String
			Dim int1 As Integer
			
			If Cbx_P0.Text <> "" Then
				str1 = "SA000.0000"
				
				For i As Integer = 5 To 0 Step -1
					If Cbx_P0.Text = relayModeStr(i) Then
						str1 = str1.Remove(6, 1).Insert(6, Chr(i + 48))
					End If
				Next
				
				calcCheckSum(str1, True, int1)
				
'				Dim result As Integer = MsgBox("Confirm command?" & _
'					vbCrLf & vbCrLf & str1, vbOKCancel)
'				
'				If result <> vbOK Then
'					Return
'				End If
				
				str1 = str1 & vbCrLf
				
				serial.WriteLine(str1)
			End If
			
			Sleep(50)
			
			If Cbx_P1.Text <> "" Then
				str1 = "SB000.0000"
				
				For i As Integer = 999 To 0 Step -1
					If Cbx_P1.Text = i.ToString("#0") Then
						Dim i_dbl As Double = 0
						If i > 0 Then
							i_dbl = i / 10
						End If
						str1 = str1.Remove(3, 4).Insert(3, i_dbl.ToString("00.0"))
						str1 = str1.Replace(",", ".")
						'MsgBox(str1)
					End If
				Next
				
				calcCheckSum(str1, True, int1)
				
'				Dim result As Integer = MsgBox("Confirm command?" & _
'					vbCrLf & vbCrLf & str1, vbOKCancel)
'				
'				If result <> vbOK Then
'					Return
'				End If
				
				str1 = str1 & vbCrLf
				
				serial.WriteLine(str1)
			End If
			
			Sleep(50)
			
			If Cbx_P2.Text <> "" Then
				str1 = "SC000.0000"
				
				For i As Integer = 59 To 0 Step -1
					If Cbx_P2.Text = i.ToString("#0") Then
						Dim i_dbl As Double = 0
						If i > 0 Then
							i_dbl = i / 10
						End If
						
						If i >= 0 Then
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("000.0"))
						Else
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("#00.0"))
						End If
						
						str1 = str1.Replace(",", ".")
						
					End If
				Next
				
				calcCheckSum(str1, True, int1)
				
'				Dim result As Integer = MsgBox("Confirm command?" & _
'					vbCrLf & vbCrLf & str1, vbOKCancel)
'				
'				If result <> vbOK Then
'					Return
'				End If
				
				str1 = str1 & vbCrLf
				
				serial.WriteLine(str1)
			End If
			
			Sleep(50)
			
			If Cbx_P3.Text <> "" Then
				str1 = "SD000.0000"
				
				For i As Integer = 999 To 0 Step -1
					If Cbx_P3.Text = i.ToString("#0") Then
						Dim i_dbl As Double = 0
						If i > 0 Then
							i_dbl = i / 10
						End If
						
						If i >= 0 Then
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("000.0"))
						Else
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("#00.0"))
						End If
						
						str1 = str1.Replace(",", ".")
						
					End If
				Next
				
				calcCheckSum(str1, True, int1)
				
'				Dim result As Integer = MsgBox("Confirm command?" & _
'					vbCrLf & vbCrLf & str1, vbOKCancel)
'				
'				If result <> vbOK Then
'					Return
'				End If
				
				str1 = str1 & vbCrLf
				
				serial.WriteLine(str1)
			End If
			
			Sleep(50)
			
			If Cbx_P4.Text <> "" Then
				str1 = "SE000.0000"
				
				For i As Integer = 999 To 0 Step -1
					If Cbx_P4.Text = i.ToString("#0") Then
						Dim i_dbl As Double = 0
						If i > 0 Then
							i_dbl = i / 10
						End If
						
						If i >= 0 Then
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("000.0"))
						Else
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("#00.0"))
						End If
						
						str1 = str1.Replace(",", ".")
						
					End If
				Next
				
				calcCheckSum(str1, True, int1)
				
'				Dim result As Integer = MsgBox("Confirm command?" & _
'					vbCrLf & vbCrLf & str1, vbOKCancel)
'				
'				If result <> vbOK Then
'					Return
'				End If
				
				str1 = str1 & vbCrLf
				
				serial.WriteLine(str1)
			End If
			
			Sleep(50)
			
			If Cbx_P5.Text <> "" Then
				str1 = "SF000.0000"
				
				For i As Integer = 59 To 0 Step -1
					If Cbx_P5.Text = i.ToString("#0") Then
						Dim i_dbl As Double = 0
						If i > 0 Then
							i_dbl = i / 10
						End If
						
						If i >= 0 Then
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("000.0"))
						Else
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("#00.0"))
						End If
						
						str1 = str1.Replace(",", ".")
						
					End If
				Next
				
				calcCheckSum(str1, True, int1)
				
'				Dim result As Integer = MsgBox("Confirm command?" & _
'					vbCrLf & vbCrLf & str1, vbOKCancel)
'				
'				If result <> vbOK Then
'					Return
'				End If
				
				str1 = str1 & vbCrLf
				
				serial.WriteLine(str1)
			End If
			
			Sleep(50)
			
			If Cbx_P6.Text <> "" Then
				str1 = "SG000.0000"
				
				For i As Integer = 999 To 0 Step -1
					If Cbx_P6.Text = i.ToString("#0") Then
						Dim i_dbl As Double = 0
						If i > 0 Then
							i_dbl = i / 10
						End If
						
						If i >= 0 Then
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("000.0"))
						Else
							str1 = str1.Remove(2, 5).Insert(2, i_dbl.ToString("#00.0"))
						End If
						
						str1 = str1.Replace(",", ".")
						
					End If
				Next
				
				calcCheckSum(str1, True, int1)
				
'				Dim result As Integer = MsgBox("Confirm command?" & _
'					vbCrLf & vbCrLf & str1, vbOKCancel)
'				
'				If result <> vbOK Then
'					Return
'				End If
				
				str1 = str1 & vbCrLf
				
				serial.WriteLine(str1)
			End If
			
			Sleep(50)
			
			If Cbx_P7.Text <> "" Then
				str1 = "SH000.0000"
				
				If Cbx_P7.Text = "ON" Then
					str1 = str1.Remove(6, 1).Insert(6, "1")
				Else If Cbx_P7.Text = "OFF" Then
					str1 = str1.Remove(6, 1).Insert(6, "0")
				End If
				
				calcCheckSum(str1, True, int1)
				
'				Dim result As Integer = MsgBox("Confirm command?" & _
'					vbCrLf & vbCrLf & str1, vbOKCancel)
'				
'				If result <> vbOK Then
'					Return
'				End If

				'MsgBox(str1)
				
				str1 = str1 & vbCrLf
				
				serial.WriteLine(str1)
			End If
			
			Sleep(50)
			
			If Cbx_P8.Text <> "" Then
				str1 = "SI000.0000"
				
				If Cbx_P8.Text = "ON" Then
					str1 = str1.Remove(6, 1).Insert(6, "1")
				Else If Cbx_P8.Text = "OFF" Then
					str1 = str1.Remove(6, 1).Insert(6, "0")
				End If
				
				calcCheckSum(str1, True, int1)
				
'				Dim result As Integer = MsgBox("Confirm command?" & _
'					vbCrLf & vbCrLf & str1, vbOKCancel)
'				
'				If result <> vbOK Then
'					Return
'				End If

				'MsgBox(str1)
				
				str1 = str1 & vbCrLf
				
					Try
						serial.WriteLine(str1)
					Catch
						MsgBox("Error Serial Write")
					End Try
			End If
			
'		cbx_P6.Items.Add("ON")
'		cbx_P6.Items.Add("OFF")
'					
'		cbx_P7.Items.Add("ON")
'		cbx_P7.Items.Add("OFF")
'					
'		cbx_P8.Items.Add("ON")
'		cbx_P8.Items.Add("OFF")	

			For i As Integer = 0 To 8 
				comboboxes(i).Text = ""
			Next
			
			btn_Set.Enabled = True
			btn_restart.Enabled = True
		Else 
			MsgBox("Disconnected")
		End If
	End Sub
	
	Sub Btn_ClearClick(sender As Object, e As EventArgs)
		For i As Integer = 0 To 8 
			comboboxes(i).Text = ""
		Next
	End Sub
	
	Sub Cbx_P0KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Cbx_P1KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Cbx_P2KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Cbx_P3KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Cbx_P4KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Cbx_P5KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Cbx_P6KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Cbx_P7KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Cbx_P8KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub TextBox10KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub TextBox1KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)	
	End Sub
	
	Sub TextBox2KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub TextBox3KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub TextBox4KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub TextBox5KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub TextBox6KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub TextBox7KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub TextBox8KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub TextBox9KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Cbx_serial_portKeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Tbx_receivedKeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Btn_ExitClick(sender As Object, e As EventArgs)
		Me.Close
	End Sub
	
	Sub CheckBox1CheckedChanged(sender As Object, e As EventArgs)
		If CheckBox1.Checked = False Then
			Dim result As Integer = MsgBox("Confirm command?", vbOKCancel)
				If result <> vbOK Then
					CheckBox1.Checked = True
				Return
			End If	
		End If
		
		For i As Integer = 0 To 8
			comboboxes(i).Enabled = Not CheckBox1.Checked
		Next
	End Sub
	
	Sub TextBox11KeyPress(sender As Object, e As KeyPressEventArgs)
		e.KeyChar = Chr(0)
	End Sub
	
	Sub Btn_LogClearClick(sender As Object, e As EventArgs)
		textBox11.Text = ""		
	End Sub
	
	Sub Btn_SaveClick(sender As Object, e As EventArgs)
        Dim myStream As Stream
        Dim saveFileDialog1 As New SaveFileDialog()
        
        Dim paramsTest As Integer = 0
        
        For i As Integer = 0 To 8
			If textboxes(i).Text = "" Then
				paramsTest = paramsTest + 1
			End If
		Next
        
        If paramsTest > 0 Then
			MsgBox("Connect to the device to load its parameters")
			
			Return
		End If

        saveFileDialog1.Filter = "dat files (*.dat)|*.dat|All files (*.*)|*.*"
        saveFileDialog1.FilterIndex = 2
        saveFileDialog1.RestoreDirectory = True
        saveFileDialog1.FileName = "W1209_Timer_setup.dat"

        If saveFileDialog1.ShowDialog() = DialogResult.OK Then
            myStream = saveFileDialog1.OpenFile()
            If (myStream IsNot Nothing) Then
            	For i As Integer = 0 To 8
            		If textboxes(i).Text <> "" Then
            			Dim str1 As String = "P" & Chr(i + 65) & textboxes(i).Text & vbCrLf
		            	Dim bytes As Byte() = System.Text.Encoding.Unicode.GetBytes(str1)
		            	myStream.Write(bytes, 0, bytes.Length)
					End If
            	Next
            	        
            	myStream.Flush
            	myStream.Close()
            	myStream.Dispose()
            End If
        End If			
	End Sub
	
	Sub Btn_LoadClick(sender As Object, e As EventArgs)
        Dim myStream As Stream
        Dim openFileDialog1 As New OpenFileDialog()
        
        openFileDialog1.Filter = "dat files (*.dat)|*.dat|All files (*.*)|*.*"
        openFileDialog1.FilterIndex = 2
        openFileDialog1.RestoreDirectory = True
        openFileDialog1.FileName = "W1209_setup.dat"

        If openFileDialog1.ShowDialog() = DialogResult.OK Then
            myStream = openFileDialog1.OpenFile()
            If (myStream IsNot Nothing) Then
            	Dim bytes(200) As Byte 
            	myStream.Read(bytes, 0, 200)
            	Dim str1 As String = System.Text.Encoding.Unicode.GetString(bytes)
            	
            	'MsgBox(str1)
            	
            	If str1.Contains(vbCrLf) Then
            		Dim lines As String() = str1.Split(Chr(13))
            		'MsgBox(lines.Length)
            		If lines.Length = 10 Then
            			For i As Integer = 0 To 8
            				If str1.Contains(vbCr) Then
	            				lines(i) = lines(i).Replace(vbCr, "")
            				End If
            				
            				If str1.Contains(vbLf) Then
	            				lines(i) = lines(i).Replace(vbLf, "")
            				End If
            				
                      		If lines(i) <> "" Then
                      			'MsgBox(lines(i))
          		  				comboboxes(i).Text = lines(i).Substring(2)
							End If
            			Next
            		End If
            	Else
            		MsgBox("File not valid")
            	End If
            	
'            	For i As Integer = 0 To 8
'            		If textboxes(i).Text <> "" Then
'            			Dim str1 As String = "P" & Chr(i + 65) & textboxes(i).Text & vbCrLf
'		            	Dim bytes As Byte() = System.Text.Encoding.Unicode.GetBytes(str1)
'		            	myStream.Write(bytes, 0, bytes.Length)
'					End If
'            	Next
'            	        
'            	myStream.Flush
            	myStream.Close()
            	myStream.Dispose()
            End If
        End If	
        
        checkBox1.Checked = True
	End Sub
	
	Sub Btn_DefaultClick(sender As Object, e As EventArgs)
		For i As Integer = 0 To 8 
			comboboxes(i).Text = params_default(i)
		Next			
	End Sub
	
	Sub Cbx_serial_portSelectedIndexChanged(sender As Object, e As EventArgs)

	End Sub
	
	Sub Timer2Tick(sender As Object, e As EventArgs)
		If cbx_serial_port.Items.Count = 0 Then
			GetSerialPortNames
		End If		
	End Sub
	
	Sub Btn_restartClick(sender As Object, e As EventArgs)
		Dim str1 As String = "SJ000.1000"
		Dim int1 As Integer
		
		If serial.IsOpen Then
			Btn_restart.Enabled = False
			btn_Set.Enabled = False
			
			'str1 = str1.Remove(6, 1).Insert(6, "1")
				
			calcCheckSum(str1, True, int1)
					
					str1 = str1 & vbCrLf
					
					Try
						serial.WriteLine(str1)
					Catch
						MsgBox("Error Serial Write")
					End Try
					
			
					
			btn_Set.Enabled = True
					
			Btn_restart.Enabled = True
		Else
			MsgBox("Disconnected")
		End If
	End Sub
End Class
