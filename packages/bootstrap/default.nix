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
  }
)
