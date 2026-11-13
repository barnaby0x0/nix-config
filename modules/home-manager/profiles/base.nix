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

  _module.args.mkVim =
    (import ../../../lib/vim {
      inherit nixpkgs;
    }).mkVim;

  imports = [
    ../programs/all.nix
  ];
}
