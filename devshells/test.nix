
{ pkgs, lib }:

lib.mkDevShell {
  name = "go";

  packages = with pkgs; [
    go
    gopls
    gotools
    golangci-lint
  ];

  shellHook = ''
    go version
  '';
}
