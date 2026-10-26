{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    bmon
    btop
    htop
    mc
    tree
    tmux
    zsh
    rlwrap
    lynx
    hexedit
    jq
    uv
    zip
    p7zip
  ];
}
