{ ... }:

final: prev: {
  brave = prev.brave.override {
    commandLineArgs = [
      "--disk-cache-dir=/tmp/brave/cache"
      "--gpu-cache-dir=/tmp/brave/gpu-cache"
    ];
  };
}

## It could be simply AS configuration instead of overlay
# programs.chromium = {
#   enable = true;
#   package = pkgs.brave;
#   extensions = [
#     { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
#   ];
#   commandLineArgs = [
#     "--disable-features=WebRtcAllowInputVolumeAdjustment"
#   ];
# }
