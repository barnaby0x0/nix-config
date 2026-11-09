{
  apps = import ./apps;
  cachyos = import ./cachyos.nix;
  desktop = import ./desktop.nix;
  gaming = import ./gaming.nix;
  garbage = import ./garbage.nix;
  performance = import ./performance.nix;
  plasma = import ./desktop/plasma.nix;
  virt = import ./virt.nix;
  sops = import ./sops.nix;
  home-manager = import ./home-manager;
  services = import ./services;
}
