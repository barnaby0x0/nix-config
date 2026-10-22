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

  # get hashes
  # nix store prefetch-file --json https://releases.hashicorp.com/terraform/1.17.0/terraform_1.17.0_linux_amd64.zip
  # nix store prefetch-file --json https://releases.hashicorp.com/terraform/1.17.0/terraform_1.17.0_linux_arm64.zip
  terraform_hashes = {
    x86_64-linux = "sha256-wWjKt8Y3qHaf25AInd0Z3nAbxv+KymTcLiGF/kb1n2c=";
    aarch64-linux = "sha256-8yR4E0/8bXEO7EdLvTFmUs3dwPTjNpc6N0Xo06MwnN8=";
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
