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

		Set-PSReadLineKeyHandler -Key Shift+Ctrl+C -Function Copy
		Set-PSReadLineKeyHandler -Key Ctrl+Shift+V -Function Paste
		Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function ShellBackwardWord
		Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ShellNextWord

		Add-Type '
		using System.Management.Automation;
		using System.Management.Automation.Runspaces;

		[Cmdlet("Reload", "Profile")]
		public class ReloadProfileCmdlet : PSCmdlet {
			protected override void EndProcessing()
			{
				InvokeCommand.InvokeScript(". $profile", false, PipelineResultTypes.Output | PipelineResultTypes.Error, null);
			}
		}' -PassThru | Select-Object -First 1 -ExpandProperty Assembly | Import-Module -DisableNameChecking;

		Set-Alias reload Reload-Profile
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

	Write-Host $($(Get-Location) -replace ($env:USERPROFILE).Replace('\', '\\'), "~") -NoNewline -ForegroundColor DarkBlue -BackgroundColor Black

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
