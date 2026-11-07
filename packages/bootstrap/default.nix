{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) forAllSystems;
in
forAllSystems (
  system:
  let
    pkgs = mkPkgs system;
    gpgPublicKey = ./keys/public-key.asc;
    secretsFile = ../../secrets/bootstrap.yaml;
  in
  {
    inherit pkgs;

    bootstrap = pkgs.writeShellApplication {
      name = "bootstrap";

      runtimeInputs = with pkgs; [
        git
        openssh
        sops
    yq-go
    jq
    curl
    gnupg
      ];

      text = ''
        export GPG_PUBLIC_KEY=${gpgPublicKey}
        export SECRETS_FILE="${secretsFile}"

        ${builtins.readFile ./bootstrap.sh}
      '';
      # text = ''
      #   echo "Initializing user environment..."

      #   SECRETS_FILE="/home/user/Workspace/nix-config/secrets/bootstrap.yaml"
      #   SECRETS="$(sops decrypt "$SECRETS_FILE")"

      #   GITHUB_USERNAME="$(
      #     printf '%s' "$SECRETS" | yq -r '.bootstrap.GITHUB_USERNAME'
      #   )"

      #   GITHUB_TOKEN="$(
      #     printf '%s' "$SECRETS" | yq -r '.bootstrap.GITHUB_TOKEN'
      #   )"

      #   unset SECRETS

      #   export GITHUB_USERNAME
      #   export GITHUB_TOKEN

      #   # Utilisation
      #   echo "GitHub username: $GITHUB_USERNAME"

      #   SSH_DIR="$(mktemp -d /tmp/bootstrap-ssh.XXXXXX)"

      #   trap 'rm -rf "$SSH_DIR"' EXIT

      #   SSH_KEY="$SSH_DIR/id_ed25519"

      #   ssh-keygen \
      #     -t ed25519 \
      #     -f "$SSH_KEY" \
      #     -N "" \
      #     -C "bootstrap"

      #   echo "SSH key generated:"
      #   echo "$SSH_KEY.pub"

      #   PUB_KEY=$(cat "$SSH_KEY.pub")

      #   echo "$PUB_KEY"
      #   KEY_TITLE="bootstrap"

      #   RESPONSE=$(curl -L -s -w "\n%{http_code}" \
      #     -X POST \
      #     -H "Accept: application/vnd.github+json" \
      #     -H "Authorization: Bearer $GITHUB_TOKEN" \
      #     -H "X-GitHub-Api-Version: 2026-03-10" \
      #     https://api.github.com/user/keys \
      #     -d "{\"title\":\"$KEY_TITLE\",\"key\":\"$PUB_KEY\"}")

      #   # Séparer le body et le code HTTP
      #   HTTP_BODY=$(echo "$RESPONSE" | head -n -1)
      #   HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

      #   echo "HTTP Status: $HTTP_CODE"

      #   if [ "$HTTP_CODE" = "201" ]; then
      #     echo "✅ SSH key successfully added to GitHub!"
      #     echo "Title: $KEY_TITLE"
      #     echo "Key ID: $(echo "$HTTP_BODY" | grep -o '"id":[^,}]*' | cut -d: -f2)"
      #   else
      #     echo "❌ Failed to add SSH key."
      #     echo "HTTP Status: $HTTP_CODE"
      #     echo "Response: $HTTP_BODY"
      #     exit 1
      #   fi

      #   git clone git@github.com:barnaby0x0/dot.git /tmp/.dotfiles
      #   git clone git@github.com:barnaby0x0/pass.git /tmp/.password-store
      # '';
    };
  }
)
