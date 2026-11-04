{ inputs, ... }:

let
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  terraform_platforms = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
  };

  hashicorp_platforms = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
  };

  # get hashes
  # nix store prefetch-file --json https://releases.hashicorp.com/terraform/1.17.0/terraform_1.17.0_linux_amd64.zip
  # nix store prefetch-file --json https://releases.hashicorp.com/terraform/1.17.0/terraform_1.17.0_linux_arm64.zip
  terraform_hashes = {
    x86_64-linux = "sha256-wWjKt8Y3qHaf25AInd0Z3nAbxv+KymTcLiGF/kb1n2c=";
    aarch64-linux = "sha256-8yR4E0/8bXEO7EdLvTFmUs3dwPTjNpc6N0Xo06MwnN8=";
  };

  packer_hashes = {
    x86_64-linux = "sha256-q7/gz3SYUIQRJlm1PjVl8mT3CiCRTDt8T3ifVPYcJBQ=";
    aarch64-linux = "sha256-XX1t6GpJstZPPA7vV2aFW1gOEKfEW9ZgW6jx3q14Feo=";
  };

  vault_hashes = {
    x86_64-linux = "sha256-B5Q13o/xRr3sTNvjvnHWcu9OWeTfavDy26Zy5xviGmg=";
    aarch64-linux = "sha256-uNOnYRzpltythwI1WJWj+GV9q3MxH9j38beX4lGropo=";
  };

in
{
  inherit systems;
  inherit hashicorp_platforms;
  inherit terraform_hashes;
  inherit packer_hashes;
  inherit vault_hashes;

  forAllSystems = inputs.nixpkgs.lib.genAttrs systems;
}
