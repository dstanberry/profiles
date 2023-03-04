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
				cd $Directory
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
			cd $prevDir
		}
	}

	# TODO: add override option
	$editor = "nvim"
	if ($files.Count -gt 0) {
		try {
			if ($Directory) {
				$prevDir = $PWD.Path
				cd $Directory
			}
			$cmd = Invoke-Editor -FileList $files
			Write-Host "Executing '$cmd'..."
            ($Editor, $Arguments) = $cmd.Split(' ')
			Start-Process $Editor -ArgumentList $Arguments -Wait:$Wait -NoNewWindow
		}
		catch {
		}
		finally {
			if ($prevDir) {
				cd $prevDir
			}
		}
	}
}

function Get-GitStashes() {
	$result = @()
	$out = ""
	$q = ""
	$k = ""
	$sha = ""
	$ref = ""
	$fzfArguments = @{
		Ansi = $true
		NoSort = $true
		Query = "$q"
		PrintQuery = $true
		Expect = 'alt-b,alt-d,alt-s'
		Header = "alt-b: apply selected, alt-d: see diff, alt-s: drop selected"
		Preview = 'git stash show -p {1} --color=always'
	}
	git stash list --pretty="%C(auto)%gD%Creset %C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs%Creset" |
	Invoke-Fzf @fzfArguments | ForEach-Object { $result += $_ }
	if ($result.Count -gt 0) {
		$out = $result.Split(@("`r`n", "`r", "`n"), [StringSplitOptions]::None)
		if ($out.Count -ne 3) {
			return
		}
		$q = $out[0]
		$k = $out[1]
		$ref = $out[2].Substring(0, $out[2].IndexOf(" "))
		$sha = $out[2].Substring($ref.Length + 1)
		$sha = $sha.Substring(0, $sha.IndexOf(" "))

		FixInvokePrompt

		if ($null -ne $sha -and $null -ne $ref) {
			if ($k -eq "alt-b") {
				git stash branch "stash-$sha" "$sha"
			}
			elseif ($k -eq "alt-d") {
				git diff "$sha"
			}
			elseif ($k -eq "alt-s") {
				[Microsoft.PowerShell.PSConsoleReadLine]::ShellBackwardWord()
				[Microsoft.PowerShell.PSConsoleReadLine]::ShellKillWord()
				Remove-GitStash -Stash "$ref"
			}
			else {
				git stash show -p "$sha"
			}
		}
	}
}

function Remove-GitStash {
	[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
	param(
		[Parameter(Mandatory = $true)]
		[string] $Stash
	)
	Process {
		try {
			Write-Warning "Stash $Stash will be deleted"
			if ($PSCmdlet.ShouldProcess(
                        ("Deleting stash {0}" -f $Stash),
                        ("Would you like to drop stash {0}?" -f $Stash),
					"Drop stash"
				)
			) {
				Invoke-Expression "git stash drop ""$Stash"""
			}
		}
		catch {
			Throw "$($_.Exception.Message)"
		}
	}
}
