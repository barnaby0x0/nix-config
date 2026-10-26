{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    arp-scan
    ipset
    net-tools
    speedtest-cli
    wireguard-tools
  ];
}
