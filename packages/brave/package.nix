# packages/brave/package.nix
{ brave, lib }:

brave.override {
  commandLineArgs = lib.concatStringsSep " " (import ./args.nix);
}
