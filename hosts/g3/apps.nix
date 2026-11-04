{ self, ... }:
{
  imports = with self.nixosModules.apps; [
    backup
    cli
    desktop
    devops
    media
    network
    security
    storage
    system
  ];
}
