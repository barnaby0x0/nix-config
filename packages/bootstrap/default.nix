# packages/bootstrap/default.nix
{ pkgsFor, ... }:

let
  gpgPublicKey = ./keys/public-key.asc;
  secretsFile = ../../secrets/bootstrap.yaml;
in

builtins.mapAttrs (_: pkgs: {
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
  };
}) pkgsFor
