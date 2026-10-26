{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    docker
    docker-buildx
    docker-compose
    dive
    lxc
    lxd
  ];
}
