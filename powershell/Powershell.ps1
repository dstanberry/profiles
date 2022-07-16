if ((Get-Volume).DriveLetter -Contains "D")
{
	$global:basedir = (Resolve-Path "D:").ToString()
} else
{
	$global:basedir = (Resolve-Path $env:USERPROFILE).ToString() + "\"
}

if(!(Test-Path variable:global:profile_initialized))
{
	Get-ChildItem $PSScriptRoot/rc/extras/*.ps1 | ForEach-Object { . $_.FullName }
	Get-ChildItem $PSScriptRoot/rc/cmd/*.ps1 | ForEach-Object { . $_.FullName }
	Get-ChildItem $PSScriptRoot/rc/*.ps1 | ForEach-Object { . $_.FullName }

	$global:profile_initialized = $true
}

function RPrompt
{
	$pos = $Host.UI.RawUI.CursorPosition
	$status = (Get-GitStatus -Force)
	$b = $status.Branch
	$l = $b.Length

	if ($l -gt 0)
	{
		$l = $b.Length + 3

		$text = (Write-Prompt " $(Get-Glyph 0xE725)" -ForegroundColor ([ConsoleColor]::Cyan))
		$text += (Write-Prompt " $b" -ForegroundColor ([ConsoleColor]::Cyan))
		if ($status.HasIndex)
		{
			$text += (Write-Prompt "$(Get-Glyph 0x25AA)" -ForegroundColor ([ConsoleColor]::Green))
			$l += 1
		}
		if ($status.HasWorking)
		{
			if ($status.HasUntracked -and $status.Working.length -gt 1)
			{
				$text += (Write-Prompt "$(Get-Glyph 0x25AA)" -ForegroundColor ([ConsoleColor]::Red))
				$l += 1
			} elseif ($status.HasUntracked -eq $false)
			{
				$text += (Write-Prompt "$(Get-Glyph 0x25AA)" -ForegroundColor ([ConsoleColor]::Red))
				$l += 1
			}
		}
		if ($status.HasUntracked)
		{
			$text += (Write-Prompt "$(Get-Glyph 0x25AA)" -ForegroundColor ([ConsoleColor]::Blue))
			$l += 1
		}
	}

	if ($last = Get-History -Count 1)
	{
		$elapsed = ""
		$delta = $last.EndExecutionTime.Subtract($last.StartExecutionTime).TotalMilliseconds
		$timespan = [TimeSpan]::FromMilliseconds($delta)
		if ($timespan.Days -gt 0)
		{
			$elapsed = "{0}d" -f $timespan.Days
		}
		if ($timespan.Hours -gt 0)
		{
			$elapsed += "{0}h" -f $timespan.Hours
		}
		if ($timespan.Minutes -gt 0)
		{
			$elapsed += "{0}m" -f $timespan.Minutes
		}
		if ($elapsed -eq "")
		{
			$seconds = [int]$timespan.Seconds + ([int]$timespan.Milliseconds / 1000)
			$elapsed += "{0:N2}s" -f $seconds
		} else
		{
			if($timespan.Days -eq 0)
			{
				$elapsed += "{0}s" -f $timespan.Seconds 
			}
		}
		$l += 1 + $elapsed.Length
		$text += (Write-Prompt " $elapsed" -ForegroundColor "#808080")
	}

	$Host.UI.RawUI.CursorPosition = New-Object `
		System.Management.Automation.Host.Coordinates ($Host.UI.RawUI.WindowSize.Width - $l),$Host.UI.RawUI.CursorPosition.Y

	Write-Host $text -NoNewline
	$Host.UI.RawUI.CursorPosition = $pos
}

function Prompt
{
	$retval = $?

	$history = Get-History -Count 1
	if ($history)
	{
		$command = $($history) -split " "
		$Host.ui.RawUI.WindowTitle = "$(Get-Location) | $($command[0])"
	}

	if (Test-Administrator)
	{
		Write-Host " $(Get-Glyph 0xE0A2) " -NoNewline -ForegroundColor Red -BackgroundColor Black
	}

	if ((Get-Location).providerpath -eq ($env:USERPROFILE))
	{
		$cwd = "~"
	} else
	{
		$cwd = $(Get-Location | Split-Path -Leaf)
	}
	Write-Host $cwd -NoNewline -ForegroundColor DarkBlue -BackgroundColor Black

	if ($retval)
	{
		Write-Host " $(Get-Glyph 0x276F)" -NoNewline -ForegroundColor Green -BackgroundColor Black
	} else
	{
		Write-Host " $(Get-Glyph 0x276F)" -NoNewline -ForegroundColor Red -BackgroundColor Black
	}
	Remove-Variable retval

	RPrompt

	Write-Host "" -NoNewline -ForegroundColor White
	Write-Host -NoNewLine "`e[2 q"
	return " "
}
