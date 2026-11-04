{
  imports = [
    # ./apps/development.nix
    # ./apps/git.nix
    ./apps/backup.nix
    ./apps/cli.nix
    ./apps/desktop.nix
    ./apps/devops.nix
    ./apps/media.nix
    ./apps/network.nix
    ./apps/security.nix
    ./apps/storage.nix
    ./apps/system.nix
  ];
}

#{
#imports = with self.nixosModules.apps; #[
#cli
#desktop
#devops
#network
#security
#];
#}
