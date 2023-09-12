if (Get-Module -ListAvailable -Name PSReadLine) {
	Import-Module PSReadLine

	$PSReadlineOptions = @{
		EditMode = "Emacs"
		HistoryNoDuplicates = $true
		HistorySearchCursorMovesToEnd = $true
		Colors = @{
			"Command" = "Green"
			"InlinePrediction" = "#5f5f5f"
			"Operator" = "White"
			"Parameter" = "White"
		}
	}

	Set-PSReadLineOption @PSReadlineOptions
	Set-PSReadlineOption -BellStyle None
	Set-PSReadLineOption -HistoryNoDuplicates
	Set-PSReadlineOption -ShowToolTips:$false
	try {
		Set-PSReadLineOption -PredictionSource History
		Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
	}
	catch {
		Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ShellNextWord
	}

	# save executed commands to global variable
	# see |Prompt()| for truncating history file
	Set-PSReadLineOption -AddToHistoryHandler {
		param($line)
		$global:LASTHIST = $line
		return $true
	}

	# change |history| behaviour to show PSReadline history instead of  Get-History
	Remove-Item Alias:\history -Force *> $null -ErrorAction SilentlyContinue
	function history {
		Get-Content (Get-PSReadLineOption).HistorySavePath
	}

	# basic editing
	Set-PSReadlineKeyHandler -Key Ctrl+u -Function BackwardKillInput
	Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord
	Set-PSReadlineKeyHandler -Key Alt+u -Function KillLine
	Set-PSReadlineKeyHandler -Key Alt+w -Function KillWord
	Set-PSReadLineKeyHandler -Key Shift+Ctrl+C -Function Copy
	Set-PSReadLineKeyHandler -Key Ctrl+Shift+V -Function Paste
	# completion
	Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
	Set-PSReadLineKeyHandler -Chord Shift+Tab -Function MenuComplete
	# history
	Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
	Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
	# cursor movement
	Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
	Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
	Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function ShellBackwardWord

	# custom
	if (Get-Module -ListAvailable -Name PSFzf) {
		Set-PSReadLineKeyHandler -Key Ctrl+f -ScriptBlock {
			$previewer = @"
(glow -s dark {1}/README.md || bat --style=plain {1}/README.md || cat {1}/README.md || eza -lh --icons {1} || ls -lh {1}) 2> Nul
"@
			$mru = @(
				-join ($env:USERPROFILE, "\"),
				$global:basedir,
				-join ($env:hash_notes, "\zettelkasten"),
				-join ($global:basedir, "Git"),
				$env:PROJECTS_DIR,
				-join ($env:PROJECTS_DIR, "\*\*")
			)
			$mru |`
				Sort-Object -Unique |`
				Get-ChildItem -Attributes Directory |`
				Invoke-Fzf -Height "50%" -Preview "$previewer" |`
				Set-Location
			FixInvokePrompt
		}
		Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
		Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
	}

	Set-PSReadLineKeyHandler -Key Ctrl+g -ScriptBlock {
		Write-Host "`e[2J`e[3J"
		[Microsoft.PowerShell.PSConsoleReadLine]::ClearScreen()
	}
}
