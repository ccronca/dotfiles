# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

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
_creds_cache="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/dotfiles-secrets.env"
_creds_stamp="$_creds_cache.stamp"
_creds_now=$(find "$HOME/.config/creds.d" -maxdepth 2 -name '*.cred' -printf '%P %s %T@\n' 2>/dev/null | sort | md5sum | cut -d' ' -f1)
if [ -s "$_creds_cache" ] && [ "$(cat "$_creds_stamp" 2>/dev/null)" = "$_creds_now" ]; then
    . "$_creds_cache"
else
    timeout 60 systemctl --user start --wait dotfiles-secrets.service 2>/dev/null
    [ "$(cat "$_creds_stamp" 2>/dev/null)" = "$_creds_now" ] || timeout 60 systemctl --user restart --wait dotfiles-secrets.service 2>/dev/null
    [ -s "$_creds_cache" ] && . "$_creds_cache"
fi
unset _creds_cache _creds_stamp _creds_now

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local
[ -f "$HOME/.config/claude-code-vertex/env.sh" ] && . "$HOME/.config/claude-code-vertex/env.sh"
