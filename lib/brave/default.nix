{ ... }:

final: prev: {
  brave = prev.brave.override {
    commandLineArgs = [
      "--disk-cache-dir=/tmp/brave/cache"
    ];
  };
}
