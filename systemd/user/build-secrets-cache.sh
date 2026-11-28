#!/usr/bin/env bash
# Decrypt ~/.config/creds.d/*.cred into the shell secrets cache.
# ~/.config/creds.d/files/*.cred are decrypted as whole files into
# $XDG_RUNTIME_DIR/dotfiles-secrets-files/ (e.g. the AWS credentials INI,
# pointed at by AWS_SHARED_CREDENTIALS_FILE in ~/.env).
# Run by dotfiles-secrets.service at login; safe to run manually.
# No `set -e`: one undecryptable cred must not empty the whole cache.
set -u

dir="$HOME/.config/creds.d"
runtime="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
cache="$runtime/dotfiles-secrets.env"
stamp="$cache.stamp"
filesdir="$runtime/dotfiles-secrets-files"

tmp=$(mktemp "${cache}.tmp.XXXXXX") || exit 1
for f in "$dir"/*.cred; do
    [ -f "$f" ] || continue
    v=$(systemd-creds decrypt --user "$f") || continue
    printf "export %s='%s'\n" "$(basename "${f%.cred}")" "$(printf '%s' "$v" | sed -e "s/'/'\\\\''/g")" >>"$tmp"
done
chmod 600 "$tmp"
mv -f "$tmp" "$cache"

mkdir -p "$filesdir" && chmod 700 "$filesdir"
for f in "$dir"/files/*.cred; do
    [ -f "$f" ] || continue
    name="$(basename "${f%.cred}")"
    out="$filesdir/$name"
    tmpf=$(mktemp "${out}.tmp.XXXXXX") || continue
    if systemd-creds decrypt --user "$f" >"$tmpf"; then
        chmod 600 "$tmpf"
        mv -f "$tmpf" "$out"
    else
        rm -f "$tmpf"
    fi
done

# Keep this expression byte-identical to the one in zshrc/bashrc: the stamp
# comparison between service and shells depends on it.
find "$dir" -maxdepth 2 -name '*.cred' -printf '%P %s %T@\n' 2>/dev/null | sort | md5sum | cut -d' ' -f1 >"$stamp"
