{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    duplicity
    rclone
    restic
    syncthing
  ];
}
