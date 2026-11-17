{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.unprivileged_bpf_disabled" = 2;
    "net.core.bpf_jit_harden" = 2;
    "kernel.yama.ptrace_scope" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_hardlinks" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv4.tcp_syncookies" = 1;
  };

  boot.kernelParams = [
    "slab_nomerge"
    "init_on_alloc=1"
    "page_alloc.shuffle=1"
  ];

  boot.blacklistedKernelModules = [
    "dccp"
    "sctp"
    "rds"
    "tipc"
    "cramfs"
  ];

  security.protectKernelImage = true;
  security.forcePageTableIsolation = true;

  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     PermitRootLogin = "no";
  #     PasswordAuthentication = false;
  #     KbdInteractiveAuthentication = false;
  #     X11Forwarding = false;
  #     MaxAuthTries = 3;
  #     LoginGraceTime = 30;
  #   };
  # };

  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPorts = [ 22 ];
  #   logRefusedConnections = true;
  # };

  # services.fail2ban = {
  #   enable = true;
  #   maxretry = 3;
  #   bantime = "10m";
  #   bantime-increment.enable = true;
  #   ignoreIP = [ "192.168.122.0/24" ];
  # };
}
