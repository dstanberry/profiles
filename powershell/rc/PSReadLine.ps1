if (Get-Module -ListAvailable -Name PSReadLine) {
	Import-Module PSReadLine

	$PSReadlineOptions = @{
		EditMode = "Emacs"
		HistoryNoDuplicates = $true
		HistorySearchCursorMovesToEnd = $true
		Colors = @{
			"Command" = "Green"
			"Parameter" = "White"
			"InlinePrediction" = "#5f5f5f"
		}
	}

	Set-PSReadLineOption @PSReadlineOptions
	Set-PSReadlineOption -BellStyle None
	Set-PSReadLineOption -PredictionSource History

	Set-PSReadlineKeyHandler -Key Ctrl+w -Function BackwardKillWord
	Set-PSReadLineKeyHandler -Key Tab -Function Complete
	Set-PSReadLineKeyHandler -Chord Shift+Tab -Function MenuComplete
	Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
	Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
	Set-PSReadLineKeyHandler -Key Shift+Ctrl+C -Function Copy
	Set-PSReadLineKeyHandler -Key Ctrl+Shift+V -Function Paste
	Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function ShellBackwardWord
	Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ShellNextWord

	if (Get-Module -ListAvailable -Name PSFzf) {
		Set-PSReadLineKeyHandler -Key Ctrl+f -ScriptBlock {
			$mru = @(
				-join ($env:USERPROFILE, "\"),
				$global:basedir,
				-join ($env:hash_notes, "\zettelkasten"),
				-join ($global:basedir, "Git"),
				$env:PROJECTS_DIR,
				-join ($env:PROJECTS_DIR, "\*\*")
			)
			$mru | Sort-Object -Unique | Get-ChildItem -Attributes Directory | Invoke-Fzf | Set-Location
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
