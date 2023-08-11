# support custom sub-commands
function cargo {
	try {
		$PKG = "$env:CONFIG_HOME/shared/packages/cargo.txt"
		if ($args[0] -eq "load") {
			Get-Content $PKG | ForEach-Object { cargo.exe install $_ }
		}
		elseif ($args[0] -eq "save") {
			cargo.exe install --list | grep -E '^\w+' | awk '{ print $1 }' | Set-Content -Path $PKG
		}
		else { cargo.exe @args }
	}
	catch { Throw "$($_.Exception.Message)" }
}

# support custom sub-commands
function go {
	try {
		$PKG = "$env:CONFIG_HOME/shared/packages/go.txt"
		if ($args[0] -eq "load") {
			Get-Content $PKG | ForEach-Object { go.exe install $_ }
		}
		else { go.exe @args }
	}
	catch { Throw "$($_.Exception.Message)" }
}

