{ self, ... }:
{
  imports = with self.nixosModules.apps; [
    backup
    bashtop
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
