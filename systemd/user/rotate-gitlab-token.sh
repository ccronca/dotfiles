#!/usr/bin/env bash
# Rotate the GitLab personal access token (self_rotate scope) and re-encrypt
# it into creds.d, then refresh the secrets service.
# Triggered by rotate-gitlab-token.timer; safe to run manually.
# GITLAB_HOST comes from ~/.env (EnvironmentFile in the service unit).
# Only metadata (username, expiry) is ever printed or logged.
set -euo pipefail

cred="$HOME/.config/creds.d/GITLAB_TOKEN.cred"
host="${GITLAB_HOST:?GITLAB_HOST is not set (add it to ~/.env)}"
api="https://$host/api/v4"

fail() {
    echo "ERROR: $1" >&2
    notify-send -u critical "GitLab token rotation failed" "$1" >/dev/null 2>&1 || true
    exit 1
}
trap 'fail "unexpected error — see journalctl --user -u rotate-gitlab-token"' ERR

old=$(systemd-creds decrypt --user "$cred")

resp=$(curl -sS -f -X POST -H "PRIVATE-TOKEN: $old" \
    "$api/personal_access_tokens/self/rotate") ||
    fail "rotation API call failed"

new=$(jq -r .token <<<"$resp")
expires=$(jq -r .expires_at <<<"$resp")
[ -n "$new" ] && [ "$new" != null ] || fail "rotation response contained no token"

user=$(curl -sS -f -H "PRIVATE-TOKEN: $new" "$api/user" | jq -r .username) || true
[ -n "$user" ] && [ "$user" != null ] || fail "new token failed verification"

printf '%s' "$new" | systemd-creds encrypt --user - "$cred"
systemctl --user restart --wait dotfiles-secrets.service

echo "GitLab token rotated for $user, expires $expires"
