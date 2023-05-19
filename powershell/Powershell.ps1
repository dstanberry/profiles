if ((Get-Volume).DriveLetter -Contains "D") {
	$global:basedir = "D:\"
}
else {
	$global:basedir = $env:USERPROFILE.ToString() + "\"
}

if (!(Test-Path variable:global:profile_initialized)) {
	[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8

	$content = Get-ChildItem "$PSScriptRoot\rc\extras\*.ps1" | ForEach-Object {
		[System.IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8) + [Environment]::NewLine
	}
	$content += Get-ChildItem "$PSScriptRoot\rc\cmd\*.ps1" | ForEach-Object {
		[System.IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8) + [Environment]::NewLine
	}
	$content += Get-ChildItem "$PSScriptRoot\rc\*.ps1" | ForEach-Object {
		[System.IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8) + [Environment]::NewLine
	}
	$ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create($content)), $null, $null)

	$global:profile_initialized = $true
}

$ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create([io.file]::ReadAllText("$PSScriptRoot/Prompt.ps1"))), $null, $null)
