export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

ENABLE_CORRECTION="true"

HIST_STAMPS="mm/dd/yyyy"

plugins=(
    git
    docker
    you-should-use
)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export PATH="$HOME/.composer/vendor/bin:$PATH"

# zsh
alias openzs="open ~/.zshrc"
alias sourcezs="source ~/.zshrc"

# Docker
alias dcb="docker compose build"
alias dcu="docker compose up -d"
alias dcd="docker compose down"

# npm
alias nrd="npm run dev"
alias nrb="npm run build"
alias ni="npm install"
alias nu="npm uninstall"
alias nr="npm run"

# Git
alias gs="git status"
alias gcm="git commit -m"
alias lm="git checkout main && git pull"
alias gp="git pull && git push"
alias ulc='git reset --soft HEAD~1'
alias gst="git stash"
alias pop="git stash pop"
alias gstapp="git stash apply"

export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# ZSH Brew Plugins
source $(brew --prefix)/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Sail aliases
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
alias sdus='sh $(sail down && sail up -d && sail shell)'
alias scparty="sail composer party"
alias scfresh="sail composer fresh"
alias sud="sail up -d"
alias sd="sail down"
alias scstan="sail composer s"
alias scpint="sail composer p"
alias sctest="sail php artisan test"
alias snrd="sail npm run dev"
alias spar="sail php artisan reverb:start"

# Shell aliases
alias ls='eza --icons -F -H --group-directories-first --git -1'
alias ll='ls -alF'

# functions
function sctestf() {
    if [ $1 != "" ]
    then
        sail php artisan test --filter="$1"
    else
        echo No filter argument specified
    fi
}
eval "$(starship init zsh)"
