$ad = $env:APPDATA
$lad = $env:LOCALAPPDATA
$pf = $env:ProgramFiles
$pfe = ${env:ProgramFiles(x86)}
$c = $HOME
if ((Get-Volume).DriveLetter -contains "D")
{
	$d = (Resolve-Path "D:").ToString()	
}
$notes = "$global:basedir/Documents/_notes"
