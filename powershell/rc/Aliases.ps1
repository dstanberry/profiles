# better cd
Set-Item Alias:cd Set-LocationEx

# better ls (exa)
Set-Item Alias:ls Get-ChildItemEx
Set-Item Alias:ll Get-ChildItemExLong

# fzf utilities
if(Get-Module -ListAvailable -Name PSFzf)
{
	Set-Item Alias:fe Invoke-CustomFuzzyEdit
}
