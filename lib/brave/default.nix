{ ... }:

final: prev: {
  brave = prev.brave.override {
    commandLineArgs = [
      "--disk-cache-dir=/tmp/brave/cache"
      "--gpu-cache-dir=/tmp/brave/gpu-cache"
    ];
  };
}