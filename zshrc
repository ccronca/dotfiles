# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:${KREW_ROOT:-$HOME/.krew}/bin:$PATH:`go env GOPATH`/bin:$HOME/.npm-global/bin:$HOME/.local/bin/

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(colorize common-aliases dnf gcloud git kubectl oc sudo tmux z)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

export KUBE_EDITOR='vim'

python_venv() {
  local VENV_DIR=./.venv
  echo $VENV_DIR
  [[ -d $VENV_DIR ]] && source $VENV_DIR/bin/activate > /dev/null 2>&1
}

# Make directory and change into it.
function mcd() {
  mkdir -p "$1" && cd "$1";
}

# Load environment variables from .env
if [ -f ~/.env ]; then
  set -a  # Automatically export all variables
  source ~/.env
  set +a  # Stop automatically exporting
fi

# Load secrets from systemd-creds (TPM2-encrypted, one NAME.cred per var).
# dotfiles-secrets.service decrypts them into a tmpfs cache at login; shells
# only source it. The stamp (cred names+sizes+mtimes) is a ~5ms check: on
# mismatch (new/changed .cred, or a shell racing the service at login) we
# delegate the rebuild to the service and wait — this rc never runs TPM
# decrypts itself.
_creds_cache="${XDG_RUNTIME_DIR:-/run/user/$UID}/dotfiles-secrets.env"
_creds_stamp="$_creds_cache.stamp"
_creds_now=$(find ~/.config/creds.d -maxdepth 1 -name '*.cred' -printf '%f %s %T@\n' 2>/dev/null | sort | md5sum | cut -d' ' -f1)
if [[ -s $_creds_cache ]] && [[ $(cat $_creds_stamp 2>/dev/null) == "$_creds_now" ]]; then
  source $_creds_cache
else
  timeout 60 systemctl --user start --wait dotfiles-secrets.service 2>/dev/null
  [[ $(cat $_creds_stamp 2>/dev/null) == "$_creds_now" ]] || timeout 60 systemctl --user restart --wait dotfiles-secrets.service 2>/dev/null
  [[ -s $_creds_cache ]] && source $_creds_cache
fi
unset _creds_cache _creds_stamp _creds_now

# Local config (for shell-specific configurations)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# https://github.com/anthropics/claude-code/issues/2407#issuecomment-3013345884
claude() {
  SHELL=/bin/bash command claude "$@"
}

# Added by codebase-memory-mcp install
export PATH="$HOME/.local/bin:$PATH"

# opencode
export PATH=$HOME/.opencode/bin:$PATH
[ -f "$HOME/.config/claude-code-vertex/env.sh" ] && . "$HOME/.config/claude-code-vertex/env.sh"
