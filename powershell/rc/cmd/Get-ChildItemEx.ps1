if(Get-Module -ListAvailable -Name Terminal-Icons)
{
	Import-Module -Name Terminal-Icons
}

function Get-ChildItemEx
{
	[CmdletBinding(
		DefaultParameterSetName = 'Path',
		SupportsTransactions = $true)
	]
	param(
		[Parameter(ParameterSetName = 'Path', Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
		[string] ${Path}
	)

	begin
	{
		if ($PSBoundParameters.Count -eq 0 -and !$myInvocation.ExpectingInput)
		{
			$Path = $PWD
		} elseif ($PSCmdlet.ParameterSetName -eq 'Path')
		{
			if (
			($dirs = $Path | RemoveTrailingSeparator | Expand-Path -Directory) -and
			(@($dirs).Count -eq 1 -or ($dirs = $dirs | Where-Object Name -eq $Path).Count -eq 1)
			)
			{
				$Path = $dirs | Resolve-Path | Select-Object -Expand ProviderPath
			} elseif (
			($vpath = Get-Variable $Path -ValueOnly -ErrorAction Ignore) -and
			(Test-Path $vpath -PathType Container -ErrorAction Ignore)
			)
			{
				$Path = $vpath
			}
		}
		
		$Content = $Path
		if ($Path -and !$myInvocation.ExpectingInput)
		{
			if (Resolve-Path $Path -ErrorAction Ignore)
			{
				$Content = Get-ChildItem -Path $Path
				# $PSBoundParameters['Path'] = $Path
			} elseif (Resolve-Path -LiteralPath $Path -ErrorAction Ignore)
			{
				$Content = Get-ChildItem -LiteralPath $Path
				# $PSBoundParameters['LiteralPath'] = $Path
				# $null = $PSBoundParameters.Remove('Path')
			}

			$PSBoundParameters['InputObject'] = $Content
			$PSBoundParameters['AutoSize'] = $true
		}

		# Get-ChildItem $Path | Format-Wide -AutoSize
		$wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand(
			'Format-Wide',
			[System.Management.Automation.CommandTypes]::Cmdlet
		)
		$scriptCmd = { & $wrappedCmd @PSBoundParameters }
		$steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
		$steppablePipeline.Begin($PSCmdlet)
	}

	process
	{
		if ($steppablePipeline)
		{
			$steppablePipeline.Process($_)
		}
	}
}
