{
  cachyos = import ./cachyos.nix;
  desktop = import ./desktop.nix;
  gaming = import ./gaming.nix;
  performance = import ./performance.nix;
  virt = import ./virt.nix;
  plasma = import ./desktop/plasma.nix;
  apps = import ./apps;
}
