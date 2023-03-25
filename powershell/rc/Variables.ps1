# poor man's |hash -d| utility

$ad = $env:APPDATA
$env:hash_ad = $ad

$lad = $env:LOCALAPPDATA
$env:hash_lad = $lad

$pf = $env:ProgramFiles
$env:hash_pf = $pf

$pfe = ${env:ProgramFiles(x86)}
$env:hash_pfe = $pfe

$c = $HOME
$env:hash_c = $c

if ((Get-Volume).DriveLetter -contains "D") {
	$d = (Resolve-Path "D:").ToString()	
	$env:hash_d = $d
}

$notes = $env:hash_notes
$env:hash_notes = $notes

$projects = $env:PROJECTS_DIR
$env:hash_projects = $projects
