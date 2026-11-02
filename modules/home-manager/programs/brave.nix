{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      {
        id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      } # dark-reader
    ];
    commandLineArgs = [
      "--disk-cache-dir=/tmp/brave/cache"
      "--gpu-cache-dir=/tmp/brave/gpu-cache"
    ];
  };
}
