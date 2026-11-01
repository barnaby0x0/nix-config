{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    packer
    terraform
    vault
    yamlfmt
    yamllint
  ];
}
