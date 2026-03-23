# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ── oh-my-zsh plugins ─────────────────────────────────────────────────────────
plugins=(
  git
  extract
  git-extras
  docker
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# ── shell options ─────────────────────────────────────────────────────────────
unsetopt beep
PROMPT_EOL_MARK=''
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
SAVEHIST=10000
HISTSIZE=$SAVEHIST
setopt CORRECT
setopt CORRECT_ALL
setopt INTERACTIVE_COMMENTS

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# ── golang ────────────────────────────────────────────────────────────────────
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

# ── uv (replaces pyenv + poetry + pip) ───────────────────────────────────────
# uv python install 3.13 | uv run | uv add | uvx <tool>
# ruff check . | ruff format .

# ── fnm (replaces nvm) ────────────────────────────────────────────────────────
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd --shell zsh)"

# ── neovim ────────────────────────────────────────────────────────────────────
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# ── starship ──────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── kubectl (WSL mirrors Windows kube config) ─────────────────────────────────
export KUBECONFIG="/mnt/c/Users/$USER/.kube/config"

# ── aliases ───────────────────────────────────────────────────────────────────
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cat='bat -p --wrap=never --paging=never'
alias batt='bat -p --paging=never'
alias getupdate='sudo apt-get update -y && sudo apt-get upgrade -y'
alias rmdjextras='rm -rf .git/ .mypy_cache/ .vscode/ local/ .venv/'
alias getip="grep -m 1 nameserver /etc/resolv.conf | awk '{print \$2}'"
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ── docker ────────────────────────────────────────────────────────────────────
function dock() {
  if [[ "$*" == "ps" ]]; then
    command docker ps --format 'table {{.Names}}\t{{.Status}} : {{.RunningFor}}\t{{.ID}}\t{{.Image}}'
  elif [[ "$*" == "psa" ]]; then
    command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Size}}\n{{.ID}}\t{{.Image}}{{if .Ports}}{{with $p := split .Ports ", "}}\t{{len $p}} port(s) on {{end}}{{- .Networks}}{{else}}\tNo Ports on {{ .Networks }}{{end}}\n'
  elif [[ "$*" == "psnet" ]]; then
    command docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Networks}}\n{{.ID}}{{if .Ports}}{{with $p := split .Ports ", "}}{{range $p}}\t\t{{println .}}{{end}}{{end}}{{else}}\t\t{{println "No Ports"}}{{end}}'
  else
    command docker "$@"
  fi
}
