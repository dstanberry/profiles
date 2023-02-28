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
--bind=tab:toggle-out
--bind=shift-tab:toggle-in
--prompt=" "
--pointer=""
--marker=""
--color=dark
--color=fg:#bebebe,bg:-1,hl:#93b379
--color=fg+:#dfe3ec,bg+:-1,hl+:#93b379
--color=info:#5f5f5f,prompt:#93b379,pointer:#bebebe
--color=marker:#b04b57,spinner:#4c566a,header:#4c566a
'
$env:FZF_CTRL_T_OPTS = "
--select-1
--exit-0
--preview '(bat --color ""always"" {} || cat {} || tree -C {}) | head -200'
"

$env:PROJECTS_DIR = $global:basedir + "Projects"

$env:hash_notes = $global:basedir + "Documents\_notes"
$env:ZK_NOTEBOOK_DIR = $global:basedir + "Documents\_notes\zettelkasten\vault"
