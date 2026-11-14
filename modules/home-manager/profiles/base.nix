{ nixpkgs, ... }:

{

  # imports = [
  #   self.homeModules.args
  # ]
  # ++ lib.attrValues self.homeModules.programs;
  # OR
  # imports = [
  #   # self.homeModules.args
  #   # self.homeModules.programs.all
  #   # ../../../lib/vim
  #   ../programs/all.nix
  # ];

  imports = [
    ../programs/all.nix
  ];
}
