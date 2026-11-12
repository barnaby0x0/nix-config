# { pkgs, ... }:

# {
#   imports = [
#     ../programs/shell.nix
#     ../programs/vim.nix
#     ../programs/tmux.nix
#     ../programs/git.nix
#     # ../options/opt-git.nix
#   ];

#   home.file.".terraformrc".source = ../files/commons/terraform/terraformrc;
#   home.file.".config/bashtop.cfg".source = ../files/commons/btop/bashtop.cfg;

#   home.packages = with pkgs; [
#     btop
#     htop
#   ];
# }

{ self, lib, ... }:

{

  imports = [
    self.homeModules.args
  ]
  ++ lib.attrValues self.homeModules.programs;
}
