{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dnsmasq
    ebtables
    edk2-ovmf
    guestfs-tools
    libguestfs
    libvirt
    openbsd-netcat
    qemu-full
    qemu-user-static
    vde2
    virt-manager
    virt-viewer
  ];
}
