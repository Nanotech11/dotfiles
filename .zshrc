export PATH=/snap/nvim/current/usr/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt auto_cd
setopt append_history
setopt extended_glob
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt ignore_eof
setopt nomatch
setopt notify
setopt share_history

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

autoload -Uz compinit && compinit
autoload -U add-zsh-hook

zstyle :compinstall filename '/home/noah/.zshrc'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

eval "$(zoxide init zsh --cmd cd)"

precmd() {
	PROMPT='%F{cyan}'$VIRTUAL_ENV_PROMPT'%F{green}%n@%m %F{blue}%~ %F{red}'$(git branch --show-current 2>/dev/null)$'\n> %f'
	RPROMPT='%F{red}%*'
}

python_venv() {
    VENV_DIR=./.venv
    [[ -d $VENV_DIR ]] && source $VENV_DIR/bin/activate
}
add-zsh-hook chpwd python_venv

alias 'c'='clear'
alias 'cat'='batcat'
alias 'cd..'='cd ..'
alias 'find'='fdfind'
alias 'gdb-gef'='gdb -x ~/.gdb/gef/gef.py'
alias 'gdb-pwn'='gdb -x ~/.gdb/pwndbg/gdbinit.py'
alias 'grep'='rg'
alias 'history'='history 0'
alias 'll'='eza -laF'
alias 'ls'='eza -F'
alias 'python'='python3'
alias 'sudo'='sudo '
alias 'vim'='nvim'

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
