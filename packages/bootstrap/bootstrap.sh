
#!/usr/bin/env bash

echo "Initializing user environment..."

: "${SECRETS_FILE:?SECRETS_FILE is not defined}"

# 1. Load secrets
# SECRETS_FILE="${1:-secrets/bootstrap.yaml}"

if [[ ! -f "$SECRETS_FILE" ]]; then
  echo "Secrets file not found: $SECRETS_FILE" >&2
  exit 1
fi

SECRETS="$(sops decrypt "$SECRETS_FILE")"

GITHUB_USERNAME="$(printf '%s' "$SECRETS" | yq -r '.bootstrap.GITHUB_USERNAME')"
GITHUB_TOKEN="$(printf '%s' "$SECRETS" | yq -r '.bootstrap.GITHUB_TOKEN')"

unset SECRETS

export GITHUB_USERNAME GITHUB_TOKEN

echo "GitHub account: $GITHUB_USERNAME"

# 2. Generate a temporary SSH key
SSH_DIR="$(mktemp -d /tmp/bootstrap-ssh.XXXXXX)"
trap 'rm -rf "$SSH_DIR"' EXIT

SSH_KEY="$SSH_DIR/id_ed25519"
KEY_TITLE="bootstrap"

ssh-keygen \
  -t ed25519 \
  -f "$SSH_KEY" \
  -N "" \
  -C "$KEY_TITLE"

PUB_KEY="$(< "$SSH_KEY.pub")"

echo "SSH key generated."

# 3. Register the SSH public key on GitHub
PAYLOAD="$(jq -n \
  --arg title "$KEY_TITLE" \
  --arg key "$PUB_KEY" \
  '{title: $title, key: $key}')"

HTTP_CODE="$(curl -sS \
  -o "$SSH_DIR/github-response.json" \
  -w '%{http_code}' \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  https://api.github.com/user/keys \
  -d "$PAYLOAD")"

if [[ "$HTTP_CODE" != "201" ]]; then
  echo "Failed to register SSH key (HTTP $HTTP_CODE)." >&2
  cat "$SSH_DIR/github-response.json" >&2
  exit 1
fi

KEY_ID="$(jq -r '.id' "$SSH_DIR/github-response.json")"

echo "SSH key successfully added to GitHub (ID: $KEY_ID)."

# 4. Clone private repositories using the generated key
export GIT_SSH_COMMAND="ssh -i $SSH_KEY -o IdentitiesOnly=yes"

git clone git@github.com:barnaby0x0/dot.git /tmp/.dotfiles
git clone git@github.com:barnaby0x0/pass.git /tmp/.password-store

echo "Importing GPG public key..."

gpg --import "$GPG_PUBLIC_KEY"

echo "GPG public key imported."

echo ""
echo "GPG public key successfully imported."
echo ""
echo "Next steps:"
echo "  1. Trust the imported GPG key (set its ownertrust)."
echo "  2. Enable KeySmart for your YubiKey using with gpg --card-status"
echo ""

echo "Bootstrap completed."
