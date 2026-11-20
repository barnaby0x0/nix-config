{
  apps = import ./apps;
  cachyos = import ./cachyos.nix;
  desktop = import ./desktop.nix;
  gaming = import ./gaming.nix;
  garbage = import ./garbage.nix;
  hardening = import ./hardening.nix;
  home-manager = import ./home-manager;
  niri = import ./niri.nix;
  performance = import ./performance.nix;
  plasma = import ./desktop/plasma.nix;
  services = import ./services;
  sops = import ./sops.nix;
  virt = import ./virt.nix;
  disk = import ./disk.nix;
}
