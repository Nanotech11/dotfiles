HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt autocd
setopt extendedglob
setopt nomatch
setopt notify
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

bindkey -v
bindkey -M viins 'jj' vi-cmd-mode

autoload -Uz compinit && compinit

zstyle :compinstall filename '/home/noah/.zshrc'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

eval "$(zoxide init zsh --cmd cd)"

precmd() {
	PROMPT="%F{cyan}"$CONDA_PROMPT_MODIFIER"%F{green}%n@%m %F{blue}%~ %F{red}"$(git branch --show-current 2>/dev/null)"%F{red}"$'\n> '"%f"
	RPROMPT="%F{red}%*"
}

alias 'ls'='eza -F'
alias 'll'='eza -laF'
alias 'vim'='nvim'
alias 'c'='clear'
alias 'sudo'='sudo '
alias 'grep'='rg'
alias 'cat'='batcat'
alias 'find'='fdfind'

export PATH=/usr/local/bin/nvim-linux-x86_64/bin:$PATH

