{ pkgs, self, ... }:

{
  environment.systemPackages = with pkgs; [
    self.packages.${pkgs.stdenv.hostPlatform.system}.terraform
    self.packages.${pkgs.stdenv.hostPlatform.system}.packer
    self.packages.${pkgs.stdenv.hostPlatform.system}.vault
    yamlfmt
    yamllint
  ];
}
