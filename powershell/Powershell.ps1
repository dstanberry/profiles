using namespace System.Management.Automation
using namespace System.Management.Automation.Language

function U {
	param([int] $Code)
	if ((0 -le $Code) -and ($Code -le 0xFFFF)) {
		return [char] $Code
	}

	if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF)) {
		return [char]::ConvertFromUtf32($Code)
	}

	throw "Invalid character code $Code"
}

function Test-Administrator {
	$user = [Security.Principal.WindowsIdentity]::GetCurrent();
	(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function prompt {
	function Initialize-Profile {
		Import-Module -Name Terminal-Icons
		Import-Module PSReadLine

		$PSReadlineOptions = @{
			EditMode                      = "Emacs"
			HistoryNoDuplicates           = $true
			HistorySearchCursorMovesToEnd = $true
			Colors                        = @{
				"Command"          = "Green"
				"Parameter"        = "White"
				"InlinePrediction" = "#5f5f5f"
			}
		}

		Set-PSReadLineOption @PSReadlineOptions
		Set-PSReadlineOption -BellStyle None
		Set-PSReadLineOption -PredictionSource History

		Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
		Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
		Set-PSReadLineKeyHandler -Key Shift+Ctrl+C -Function Copy
		Set-PSReadLineKeyHandler -Key Ctrl+Shift+V -Function Paste
		Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function ShellBackwardWord
		Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ShellNextWord

		# Add-Type '
		# using System.Management.Automation;
		# using System.Management.Automation.Runspaces;
		#
		# [Cmdlet("Reload", "Profile")]
		# public class ReloadProfileCmdlet : PSCmdlet {
		# 	protected override void EndProcessing()
		# 	{
		# 		InvokeCommand.InvokeScript(". $profile", false, PipelineResultTypes.Output | PipelineResultTypes.Error, null);
		# 	}
		# }' -PassThru | Select-Object -First 1 -ExpandProperty Assembly | Import-Module -DisableNameChecking;
		#
		# Set-Alias reload Reload-Profile

		$env:ZK_NOTEBOOK_DIR = "D:\Documents\_notes\zettelkasten\vault"

		$env:FZF_DEFAULT_COMMAND = "fd -H --follow --type f --color=always -E .git -E 'ntuser.dat\*' -E 'NTUSER.DAT\*'"
		$env:FZF_DEFAULT_OPTS = '
		--ansi
		--border
		--cycle
		--header-first
		--height=40%
		--layout=reverse
		--preview-window border-left
		--scroll-off=3
		--bind=ctrl-d:preview-down
		--bind=ctrl-f:preview-up
		--color=dark
		--color=fg:#bebebe,bg:-1,hl:#93b379
		--color=fg+:#dfe3ec,bg+:-1,hl+:#93b379
		--color=info:#5f5f5f,prompt:#6f8fb4,pointer:#b04b57
		--color=marker:#e5c179,spinner:#4c566a,header:#4c566a
		'
		Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
		Set-PSReadLineKeyHandler -Key Ctrl+f -ScriptBlock {
			Get-ChildItem -Path C:\Users\Demaro, D:\, D:\Git, D:\Documents\_notes\zettelkasten, D:\Projects, D:\Projects\*\* -Attributes Directory | Invoke-Fzf | Set-Location
			$previousOutputEncoding = [Console]::OutputEncoding
			[Console]::OutputEncoding = [Text.Encoding]::UTF8

			try {
				[Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
			}
			finally {
				[Console]::OutputEncoding = $previousOutputEncoding
			}
		}
	}

	if ($global:profile_initialized -ne $true) {
		$global:profile_initialized = $true
		Initialize-Profile
	}

	$retval = $?

	$history = Get-History -Count 1

	if ($history) {
		$command = $($history) -split " "
		$host.ui.RawUI.WindowTitle = "$(Get-Location) | $($command[0])"
	}

	if (Test-Administrator) {
		# Highlight if elevated
		Write-Host " $(U 0xE0A2) " -NoNewline -ForegroundColor Red -BackgroundColor Black
	}

	if ((Get-Location).providerpath -eq ($env:USERPROFILE)) {
		$cwd = "~"
	}
	else {
		$cwd = $(Get-Location | Split-Path -Leaf)
	}
	Write-Host $cwd -NoNewline -ForegroundColor DarkBlue -BackgroundColor Black

	if ($status = Get-GitStatus -Force) {
		Write-Host " $(U 0xE725)" -NoNewline -ForegroundColor Cyan 
		Write-Host "$(Write-GitBranchName $status)" -NoNewline -ForegroundColor Cyan

		if ($status.HasIndex) {
			Write-Host "$(U 0x25AA)" -NoNewline -ForegroundColor Green 
		}
		if ($status.HasWorking) {
			if ($status.HasUntracked -and $status.Working.length -gt 1) {
				Write-Host "$(U 0x25AA)" -NoNewline -ForegroundColor Red 
			}
			elseif ($status.HasUntracked -eq $false) {
				Write-Host "$(U 0x25AA)" -NoNewline -ForegroundColor Red 
			}
		}
		if ($status.HasUntracked) {
			Write-Host "$(U 0x25AA)" -NoNewline -ForegroundColor Blue 
		}
	}

	if ($retval) {
		Write-Host " $(U 0x276F)" -NoNewline -ForegroundColor Green -BackgroundColor Black
	}
	else {
		Write-Host " $(U 0x276F)" -NoNewline -ForegroundColor Red -BackgroundColor Black
	}
	
	Remove-Variable retval

	Write-Host "" -NoNewline -ForegroundColor White
	Write-Host -NoNewLine "`e[2 q"
	return " "
}
