#!/usr/bin/env bash
# Decrypt ~/.config/creds.d/*.cred into the shell secrets cache.
# Run by dotfiles-secrets.service at login; safe to run manually.
# No `set -e`: one undecryptable cred must not empty the whole cache.
set -u

dir="$HOME/.config/creds.d"
cache="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/dotfiles-secrets.env"
stamp="$cache.stamp"

tmp=$(mktemp "${cache}.tmp.XXXXXX") || exit 1
for f in "$dir"/*.cred; do
    [ -f "$f" ] || continue
    v=$(systemd-creds decrypt --user "$f") || continue
    printf "export %s='%s'\n" "$(basename "${f%.cred}")" "$(printf '%s' "$v" | sed -e "s/'/'\\\\''/g")" >>"$tmp"
done
chmod 600 "$tmp"
mv -f "$tmp" "$cache"
# Keep this expression byte-identical to the one in zshrc/bashrc: the stamp
# comparison between service and shells depends on it.
find "$dir" -maxdepth 1 -name '*.cred' -printf '%f %s %T@\n' 2>/dev/null | sort | md5sum | cut -d' ' -f1 >"$stamp"
