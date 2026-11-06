{
  apps = import ./apps;
  cachyos = import ./cachyos.nix;
  desktop = import ./desktop.nix;
  gaming = import ./gaming.nix;
  garbage = import ./garbage.nix;
  performance = import ./performance.nix;
  plasma = import ./desktop/plasma.nix;
  virt = import ./virt.nix;
}
