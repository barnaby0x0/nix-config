{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cmus
    mpc
    mpd
  ];
}
