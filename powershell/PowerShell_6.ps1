####################################################################################
# Remove Powershell aliases
####################################################################################
remove-item alias:cp
remove-item alias:ls
remove-item alias:rm
remove-item alias:where -Force

####################################################################################
# Symlink Linux commands
####################################################################################
$WslDefaultParameterValues = @{ }
$WslDefaultParameterValues["ls"] = "--ignore='ntuser\.*' --ignore='NTUSER\.*' --almost-all --color=auto --group-directories-first"
$WslDefaultParameterValues["grep"] = "--color=auto"

Import-WslCommand "awk", "colordiff", "cp", "curl", "cut", "diff", "emacs", "grep", "head", "less", "lnav", "ls", "man", "mv", "nano", "rm", "sed", "seq", "sh", "tail", "tmux", "tree", "vim", "wget", "which", "xargs"

Import-Module DirColors
Import-Module PSReadLine

Update-DirColors ~\.dircolors

####################################################################################
# Enable Bash/Emacs key bindings
####################################################################################
$PSReadlineOptions = @{
	EditMode                      = "Emacs"
	HistoryNoDuplicates           = $true
	HistorySearchCursorMovesToEnd = $true
	Colors                        = @{
		"Command" = "White"
		"Parameter" = "White"
	}
}

Set-PSReadLineOption @PSReadlineOptions

####################################################################################
# Extend key bindings
####################################################################################
Set-PSReadLineKeyHandler -Key Shift+Ctrl+C -Function Copy
Set-PSReadLineKeyHandler -Key Ctrl+Shift+V -Function Paste
Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ShellNextWord

####################################################################################
# Set dir to use the new Get-ChildItemColor cmdlets
####################################################################################
Set-Alias dir Get-ChildItemColor -Option AllScope

####################################################################################
# Reboot Machine
####################################################################################
Set-Alias reboot Restart-Computer

####################################################################################
# Helper function to change directory to my development workspace
####################################################################################
function chome { Set-Location C:\Users\Demaro }
function dhome { Set-Location D:\ }

####################################################################################
# Helper function to set location to the User Profile directory
####################################################################################
function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

####################################################################################
# Helper function to show Unicode character
####################################################################################
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

####################################################################################
# Helper function to check for admin privileges
####################################################################################
function Test-Administrator {
	$user = [Security.Principal.WindowsIdentity]::GetCurrent();
	(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function prompt {
	$realLASTEXITCODE = $LASTEXITCODE

	$host.ui.RawUI.WindowTitle = "Powershell Core | $(Get-Location)"

	if (Test-Administrator) {
		# Highlight if elevated
		Write-Host " $(U 0xE70F) $ENV:USERNAME " -NoNewline -ForegroundColor Red -BackgroundColor White
		Write-Host "$(U 0xE0B0)" -NoNewline -ForegroundColor White -BackgroundColor Red
		Write-Host "$(U 0xE0B0)" -NoNewline -ForegroundColor Red -BackgroundColor DarkBlue
		}
	else {
		Write-Host " $(U 0xE70F) $ENV:USERNAME " -NoNewline -ForegroundColor Black -BackgroundColor White
		Write-Host "$(U 0xE0B0)" -NoNewline -ForegroundColor White -BackgroundColor Black
		Write-Host "$(U 0xE0B0)" -NoNewline -ForegroundColor Black -BackgroundColor DarkBlue
		}

	if ($null -ne $s) {
		# color for PSSessions
		Write-Host " (`$s: " -NoNewline -ForegroundColor DarkGray
		Write-Host "$($s.Name)" -NoNewline -ForegroundColor White
		Write-Host ") " -NoNewline -ForegroundColor DarkGray
	}

	Write-Host " $(U 0xF413) " -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
	Write-Host $($(Get-Location) -replace ($env:USERPROFILE).Replace('\', '\\'), "~") -NoNewline -ForegroundColor White -BackgroundColor DarkBlue
	Write-Host " " -NoNewline -BackgroundColor DarkBlue
	Write-Host "$(U 0xE0B0)" -NoNewline -ForegroundColor DarkBlue -BackgroundColor DarkGray
	Write-Host " $(U 0xF017) " -NoNewline -ForegroundColor White -BackgroundColor DarkGray
	Write-Host (Get-Date -Format "h:mm tt") -NoNewline -ForegroundColor White -BackgroundColor DarkGray
	Write-Host " " -NoNewline -BackgroundColor DarkGray

	$global:LASTEXITCODE = $realLASTEXITCODE

	Write-Host "$(U 0xE0B0)" -NoNewline -ForegroundColor DarkGray
	Write-Host "" -NoNewline -ForegroundColor White
	return " "
}

####################################################################################
# Default Directory
####################################################################################
dhome

####################################################################################
# Chocolatey profile
####################################################################################
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
	Import-Module "$ChocolateyProfile"
}

####################################################################################
# Disable bell
####################################################################################
Set-PSReadlineOption -BellStyle None