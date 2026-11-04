{
  backup = import ./backup.nix;
  cli = import ./cli.nix;
  desktop = import ./desktop.nix;
  devops = import ./devops.nix;
  git = import ./git.nix;
  network = import ./network.nix;
  security = import ./security.nix;
  development = import ./development.nix;
  media = import ./media.nix;
  storage = import ./storage.nix;
  system = import ./system.nix;
  virtualization = import ./virtualization.nix;
}
