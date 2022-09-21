function Get-ChildItemEx
{
	[CmdletBinding()]
	param(
		[Parameter(Position=1, ValueFromRemainingArguments)]
		[string[]] ${PassthruArgs}
	)

	Process
	{
		exa --ignore-glob='ntuser.*|NTUSER.*' --all --group-directories-first --group $PassthruArgs
	}
}

function Get-ChildItemExLong
{
	[CmdletBinding()]
	param(
		[Parameter(Position=1, ValueFromRemainingArguments)]
		[string[]] ${PassthruArgs}
	)

	Process
	{
		exa --ignore-glob='ntuser.*|NTUSER.*' --long --git-ignore --icons --git --tree $PassthruArgs
	}
}
