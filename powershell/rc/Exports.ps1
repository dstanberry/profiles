$CONFIG_HOME = "$CONFIG_HOME"
$CACHE_HOME = "$env:TEMP"
$DATA_HOME = "$env:LOCALAPPDATA"

# define the default editor
$env:EDITOR = "nvim"

# set fd as the default source for fzf
$env:FZF_DEFAULT_COMMAND = "fd -H --follow --type f --color=always -E .git -E 'ntuser.dat\*' -E 'NTUSER.DAT\*'"
# define default options for fzf
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
--color=marker:#b04b57,spinner:#516882,header:#97b6e5
'
# define default behaviour for ctrl-t
$env:FZF_CTRL_T_OPTS = "
--select-1
--exit-0
--preview '(bat --color ""always"" {} || cat {} || tree -C {}) | head -200'
"

# define default name of primary upstream git branch
$env:GIT_REVIEW_BASE = "main"

# enable terminal colors in output
$env:GH_FORCE_TTY = "100%"
# define path to configuration files
$env:GH_CONFIG_DIR = "$CONFIG_HOME/gh"

# set sane default options for less
$env:LESS = "-iFMRX -x4"
# define the default pager
$env:PAGER = "less"

# define the default manpager
$env:MANPAGER='nvim +Man!'

# define location for local projects
$env:PROJECTS_DIR = $global:basedir + "Projects"

# |compat| define location of notes directory
$env:hash_notes = $global:basedir + "Documents\_notes"
# define location of zettelkasten vault
$env:ZK_NOTEBOOK_DIR = $global:basedir + "Documents\_notes\zettelkasten\vault"
