{ inputs, ... }:

let
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    #"x86_64-darwin"
    #"aarch64-darwin"
  ];

  terraform_platforms = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    # x86_64-darwin = "darwin_amd64";
    # aarch64-darwin = "darwin_arm64";
  };

  terraform_hashes = {
    x86_64-linux = "sha256-OANLONAwljmaehJkoUVhqAKbK0lv0fFpRSZW5Tlo8bc=";
    aarch64-linux = "sha256-p1C1oRA48WWEayZYxAyIzXBwqmemG6tDGhS6J5KOqeo=";
    # x86_64-darwin = "sha256-eUo2w/fr9sWPIInCJgaKU50XBbo1ilZ5tRZxyNx+vHs=";
    # aarch64-darwin = "sha256-heG8eKtFvcX4KnusOSnjfQcoNKWE0iWDokmNxnu2JM0=";
  };

in
{
  inherit systems;
  inherit terraform_platforms;
  inherit terraform_hashes;

  forAllSystems = inputs.nixpkgs.lib.genAttrs systems;
}
