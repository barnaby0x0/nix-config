{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "veracrypt"
    ];

  environment.systemPackages = with pkgs; [
    gparted
    # veracrypt
  ];
}
