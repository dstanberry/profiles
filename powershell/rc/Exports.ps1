$env:FZF_DEFAULT_COMMAND = "fd -H --follow --type f --color=always -E .git -E 'ntuser.dat\*' -E 'NTUSER.DAT\*'"
$env:FZF_DEFAULT_OPTS = '
--ansi
--border
--cycle
--header-first
--height=40%
--layout=reverse
--preview-window border-left
--scroll-off=3
--bind=ctrl-d:preview-down
--bind=ctrl-f:preview-up
--color=dark
--color=fg:#bebebe,bg:-1,hl:#93b379
--color=fg+:#dfe3ec,bg+:-1,hl+:#93b379
--color=info:#5f5f5f,prompt:#6f8fb4,pointer:#b04b57
--color=marker:#e5c179,spinner:#4c566a,header:#4c566a
'

$env:ZK_NOTEBOOK_DIR = $global:basedir + "Documents\_notes\zettelkasten\vault"
