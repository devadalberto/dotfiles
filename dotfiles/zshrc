# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  extract
  git-extras
  docker
  zsh-autosuggestions
  zsh-syntax-highlighting
#  vi-mode
#
)

source $ZSH/oh-my-zsh.sh

# User configuration
# Don't beep
unsetopt beep

# Hide initial partial prompt (not really sure why it appears 🤷‍♂️)
# This issue seems relevant https://github.com/vercel/hyper/issues/2144
PROMPT_EOL_MARK=''

# Configure shell history
setopt HIST_REDUCE_BLANKS  # Remove superfluous blanks
setopt SHARE_HISTORY  # Share history file between multiple shells (incrementally append history and use extended format)
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=10000  # Store 10000 lines of history
HISTSIZE=$SAVEHIST  # Load all lines of history for completion

# Configure shell autocorrection
setopt CORRECT
setopt CORRECT_ALL
setopt DVORAK

# Allow comments even in interactive shells
setopt INTERACTIVE_COMMENTS
# export MANPATH="/usr/local/man:$MANPATH"

# aliases
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias getupdate='sudo apt-get update -y && sudo apt-get upgrade -y'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias rmdjextras='rm -rf .git/ .mypy_cache/ .vscode/ local/ venv/'
alias cat='bat -p --wrap=never --paging=never'
alias batt='bat -p --paging=never'
alias getip="grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'"
alias cdpt9="cd /home/saitama/dev/repos/django/pt9"
alias cfc="xclip -sel c < $1"
alias cdaziac="cd /home/${USER}/dev/repos/terraform-az-iac"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Docker PS Prettify Function
function dock() {
  if [[ "$@" == "ps" ]]; then
    command docker ps --format 'table {{.Names}}\t{{.Status}} : {{.RunningFor}}\t{{.ID}}\t{{.Image}}'
  elif [[ "$@" == "psa" ]]; then
    # docker ps -a includes all containers
    command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Size}}\n{{.ID}}\t{{.Image}}{{if .Ports}}{{with $p := split .Ports ", "}}\t{{len $p}} port(s) on {{end}}{{- .Networks}}{{else}}\tNo Ports on {{ .Networks }}{{end}}\n'
  elif [[ "$@" == "psnet" ]]; then
    # docker ps with network information
    command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Networks}}\n{{.ID}}{{if .Ports}}{{with $p := split .Ports ", "}}{{range $p}}\t\t{{println .}}{{end}}{{end}}{{else}}\t\t{{println "No Ports"}}{{end}}'
  else
    command docker "$@"
  fi
}

# = = = = = = = = = = = = = = = = = = = = =
# REMEMBER TO UPDATE ALL PATHS '/home/user'
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# = = = = = = = = = = = = = = = = = = = = =


# Set up Poetry
# export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/home/saitama/.local/bin:$PATH"

# antigen
source ~/antigen.zsh

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# golang
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# pyenv
# Load pyenv automatically
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# kubectl
# this way I use the same file for WSL and for windows
#######################################################
############ REMEMBER TO UPDATE THIS PATH ############
#######################################################
export KUBECONFIG="/mnt/c/Users/javalace/.kube/config"

## kubelogin
export KL_ROOT=/usr/local/bin/kubelogin
export KL_PATH=$HOME/kubelogin
export PATH=$KL_PATH/bin:$KL_ROOT/bin:$PATH