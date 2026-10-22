{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.homeManager) mkPkgs;
  inherit (lib.commons.system) terraform_platforms terraform_hashes forAllSystems;

  version = "1.16.6";
  platforms = terraform_platforms;
  hashes = terraform_hashes;
  # platforms = {
  #   x86_64-linux = "linux_amd64";
  #   aarch64-linux = "linux_arm64";
  #   x86_64-darwin = "darwin_amd64";
  #   aarch64-darwin = "darwin_arm64";
  # };

  # hashes = {
  #   x86_64-linux = "sha256-OANLONAwljmaehJkoUVhqAKbK0lv0fFpRSZW5Tlo8bc=";
  #   aarch64-linux = "sha256-p1C1oRA48WWEayZYxAyIzXBwqmemG6tDGhS6J5KOqeo=";
  #   x86_64-darwin = "sha256-eUo2w/fr9sWPIInCJgaKU50XBbo1ilZ5tRZxyNx+vHs=";
  #   aarch64-darwin = "sha256-heG8eKtFvcX4KnusOSnjfQcoNKWE0iWDokmNxnu2JM0=";
  # };

  mkTerraform = import ../../lib/terraform;
in
forAllSystems (system: {
  terraform = mkTerraform {
    pkgs = mkPkgs system;
    inherit version;
    platform = platforms.${system};
    hash = hashes.${system};
  };
})
