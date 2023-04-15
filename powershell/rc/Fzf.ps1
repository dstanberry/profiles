$script:ShellCmd = 'cmd.exe /S /C {0}'
$script:DefaultFileSystemFdCmd = "fd.exe --hidden --color always . --full-path `"{0}`" --fixed-strings"
$script:PreviewCmd = "(bat --color ""always"" {} || cat {} || tree -C {}) | head -200"

function Get-FileSystemCmd {
	param($dir, [switch]$dirOnly = $false)

	if ($dirOnly -or [string]::IsNullOrWhiteSpace($env:FZF_DEFAULT_COMMAND)) {
		if ($script:UseFd) {
			if ($dirOnly) {
				"$($script:DefaultFileSystemFdCmd -f $dir) --type directory"
			}
			else {
				$script:DefaultFileSystemFdCmd -f $dir
			}
		}
		else {
			$cmd = $script:DefaultFileSystemCmd
			if ($dirOnly) {
				$cmd = $script:DefaultFileSystemCmdDirOnly
			}
			$script:ShellCmd -f ($cmd -f $dir)
		}
	}
	else {
		$script:ShellCmd -f ($env:FZF_DEFAULT_COMMAND -f $dir)
	}
}

function Invoke-CustomFuzzyEdit() {
	param($Directory = ".", [switch]$Wait)

	$files = @()
	try {
		if ( Test-Path $Directory) {
			if ( (Get-Item $Directory).PsIsContainer ) {
				$prevDir = $PWD.ProviderPath
				Set-Location $Directory
				Invoke-Expression (Get-FileSystemCmd .) | Invoke-Fzf -Multi -Preview "$script:PreviewCmd" | ForEach-Object { $files += "$_" }
			}
			else {
				$files += $Directory
				$Directory = Split-Path -Parent $Directory
			}
		}
	}
	catch {
	}
	finally {
		if ($prevDir) {
			Set-Location $prevDir
		}
	}

	$Editor = $env:EDITOR
	if ($files.Count -gt 0) {
		try {
			if ($Directory) {
				$prevDir = $PWD.Path
				Set-Location $Directory
			}
			$cmd = Invoke-Editor -FileList $files
            ($Editor, $Arguments) = $cmd.Split(' ')
			Start-Process $Editor -ArgumentList $Arguments -Wait:$Wait -NoNewWindow
		}
		catch {
		}
		finally {
			if ($prevDir) {
				Set-Location $prevDir
			}
		}
	}
}
