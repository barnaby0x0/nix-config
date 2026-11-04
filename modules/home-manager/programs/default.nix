{
  common = import ./common.nix;
  git = import ./git.nix;
  shell = import ./shell.nix;
  vim = import ./vim.nix;
  terminator = import ./terminator.nix;
  tmux = import ./tmux.nix;
  brave = import ./brave.nix;
}

# {
#   imports = [
#     ./common.nix
#     ./git.nix
#     ./shell.nix
#     ./vim.nix
#     ./terminator.nix
#     ./tmux.nix
#     ./brave.nix
#   ];
# }
