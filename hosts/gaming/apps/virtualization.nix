{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dnsmasq
    ebtables
    # edk2-ovmf
    guestfs-tools
    libguestfs
    libvirt
    netcat-openbsd
    # qemu_full
    # qemu-user
    vde2
    virt-manager
    virt-viewer
  ];
}
