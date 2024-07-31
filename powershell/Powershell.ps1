# NOTE: Ensure $global:basedir is defined prior to sourcing this script 
# Eg: $global:basedir = "C:\"

$null = New-Module ds {
	$content = ""
	[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

	$content += Get-ChildItem "$PSScriptRoot\rc\extras\*.ps1" | ForEach-Object {
		[System.IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8) + [Environment]::NewLine
	}

	$content += Get-ChildItem "$PSScriptRoot\rc\cmd\*.ps1" | ForEach-Object {
		[System.IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8) + [Environment]::NewLine
	}

	$content += Get-ChildItem "$PSScriptRoot\rc\*.ps1" | ForEach-Object {
		[System.IO.File]::ReadAllText($_.FullName, [Text.Encoding]::UTF8) + [Environment]::NewLine
	}

	$content += [io.file]::ReadAllText("$PSScriptRoot/Prompt.ps1")

	$ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create($content)), $null, $null)

	Export-ModuleMember -Function @(
		"FixInvokePrompt"
		"Get-ChildItemEx"
		"Get-ChildItemExLong"
		"Get-GitStashes"
		"Invoke-CustomFuzzyEdit"
		"Invoke-CustomFuzzyEdit"
		"Invoke-FuzzyGrep"
		"Invoke-ProjectSwitcher"
		"Set-LocationEx"
	)
}
