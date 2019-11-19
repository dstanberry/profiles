####################################################################################
# Remove Powershell aliases
####################################################################################
remove-item alias:cp
remove-item alias:ls
remove-item alias:rm
remove-item alias:where -Force

####################################################################################
# Powershell implementation of GNU coreutils' dircolors
####################################################################################
Import-Module DirColors

Update-DirColors ~\.dircolors

####################################################################################
# WSL Interpop
####################################################################################
Import-WslCommand "awk", "colordiff", "cp", "curl", "cut", "diff", "emacs", "grep", "head", "less", "lnav", "ls", "man", "mv", "nano", "rm", "sed", "seq", "sh", "tail", "tmux", "tree", "vim", "wget", "which", "xargs"

$WslDefaultParameterValues = @{ }
$WslDefaultParameterValues["ls"] = "--ignore='ntuser\.*' --ignore='NTUSER\.*' --almost-all --color=auto --group-directories-first"
$WslDefaultParameterValues["grep"] = "--color=auto"

$WslEnvironmentVariables = @{ }
$WslEnvironmentVariables["LANG"] = "en_US.utf8"
$WslEnvironmentVariables["HISTCONTROL"] = "erasedups:ignoreboth"
$WslEnvironmentVariables["EDITOR"] = "/usr/bin/vim"
$WslEnvironmentVariables["PWD"] = "/mnt/d"
$WslEnvironmentVariables["MANPAGER"] = "manpager"
$WslEnvironmentVariables["SHELL"] = "/bin/bash"
$WslEnvironmentVariables["TERM"] = "xterm-256color"
$WslEnvironmentVariables["LESS"] = "-R -M --shift 5"
$WslEnvironmentVariables["LESSCOLOR"] = "alwaysPAGER=/usr/bin/less"
$WslEnvironmentVariables["LESSCOLORIZER"] = "/usr/bin/src-hilite-lesspipe.sh"
$WslEnvironmentVariables["LS_COLORS"] = "no=00:rs=0:fi=00:di=01;34:ln=36:mh=04;36:pi=04;01;36:so=04;33:do=04;01;36:bd=01;33:cd=33:or=31:mi=01;37;41:ex=01;36:su=01;04;37:sg=01;04;37:ca=01;37:tw=01;37;44:ow=01;04;34:st=04;37;44:*.7z=01;32:*.ace=01;32:*.alz=01;32:*.arc=01;32:*.arj=01;32:*.bz=01;32:*.bz2=01;32:*.cab=01;32:*.cpio=01;32:*.deb=01;32:*.dz=01;32:*.ear=01;32:*.gz=01;32:*.jar=01;32:*.lha=01;32:*.lrz=01;32:*.lz=01;32:*.lz4=01;32:*.lzh=01;32:*.lzma=01;32:*.lzo=01;32:*.rar=01;32:*.rpm=01;32:*.rz=01;32:*.sar=01;32:*.t7z=01;32:*.tar=01;32:*.taz=01;32:*.tbz=01;32:*.tbz2=01;32:*.tgz=01;32:*.tlz=01;32:*.txz=01;32:*.tz=01;32:*.tzo=01;32:*.tzst=01;32:*.war=01;32:*.xz=01;32:*.z=01;32:*.Z=01;32:*.zip=01;32:*.zoo=01;32:*.zst=01;32:*.aac=32:*.au=32:*.flac=32:*.m4a=32:*.mid=32:*.midi=32:*.mka=32:*.mp3=32:*.mpa=32:*.mpeg=32:*.mpg=32:*.ogg=32:*.opus=32:*.ra=32:*.wav=32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.doc=32:*.docx=32:*.dot=32:*.odg=32:*.odp=32:*.ods=32:*.odt=32:*.otg=32:*.otp=32:*.ots=32:*.ott=32:*.pdf=32:*.ppt=32:*.pptx=32:*.xls=32:*.xlsx=32:*.app=01;36:*.bat=01;36:*.btm=01;36:*.cmd=01;36:*.com=01;36:*.exe=01;36:*.reg=01;36:*~=02;37:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:*.bmp=32:*.cgm=32:*.dl=32:*.dvi=32:*.emf=32:*.eps=32:*.gif=32:*.jpeg=32:*.jpg=32:*.JPG=32:*.mng=32:*.pbm=32:*.pcx=32:*.pgm=32:*.png=32:*.PNG=32:*.ppm=32:*.pps=32:*.ppsx=32:*.ps=32:*.svg=32:*.svgz=32:*.tga=32:*.tif=32:*.tiff=32:*.xbm=32:*.xcf=32:*.xpm=32:*.xwd=32:*.xwd=32:*.yuv=32:*.anx=32:*.asf=32:*.avi=32:*.axv=32:*.flc=32:*.fli=32:*.flv=32:*.gl=32:*.m2v=32:*.m4v=32:*.mkv=32:*.mov=32:*.MOV=32:*.mp4=32:*.mpeg=32:*.mpg=32:*.nuv=32:*.ogm=32:*.ogv=32:*.ogx=32:*.qt=32:*.rm=32:*.rmvb=32:*.swf=32:*.vob=32:*.webm=32:*.wmv=32:"

####################################################################################
# Enable Bash/Emacs key bindings
####################################################################################
Import-Module PSReadLine

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