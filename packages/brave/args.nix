# packages/brave/args.nix
[
  "--disk-cache-dir=/tmp/brave/cache"
  "--gpu-cache-dir=/tmp/brave/gpu-cache"
  "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder"
  "--disable-features=OutdatedBuildDetector,UseChromeOSDirectVideoDecoder,AllowQt"
]
