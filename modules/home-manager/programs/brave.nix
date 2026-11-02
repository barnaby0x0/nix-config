{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;

    commandLineArgs = [
      "--disk-cache-dir=/tmp/brave/cache"
      "--gpu-cache-dir=/tmp/brave/gpu-cache"
    ];
  };

  # systemd.user.tmpfiles.rules = [
  #   "d /tmp/brave 0700 - - -"
  #   "d /tmp/brave/cache 0700 - - -"
  #   "d /tmp/brave/gpu-cache 0700 - - -"
  # ];
}
