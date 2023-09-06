# better cd
Set-Item Alias:cd Set-LocationEx

# better cat
if (Get-Command bat -ErrorAction SilentlyContinue) {
	Set-Item Alias:cat bat
}

# better ls (eza)
Set-Item Alias:ls Get-ChildItemEx
Set-Item Alias:ll Get-ChildItemExLong

# fzf utilities
if (Get-Module -ListAvailable -Name PSFzf) {
	Set-Item Alias:fe Invoke-CustomFuzzyEdit
	Set-Item Alias:gstash Get-GitStashes
}
