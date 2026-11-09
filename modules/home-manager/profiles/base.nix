{
  imports = [
    ../programs/shell.nix
    ../programs/vim.nix
    ../programs/tmux.nix
    ../programs/git.nix
    ../options/opt-git.nix
  ];

  home.file.".terraformrc".source = ../files/commons/terraform/terraformrc;
}
