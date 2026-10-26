{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git-crypt
    gitg
    # myrepos
    tig
  ];
}
