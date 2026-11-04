{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cargo
    nodejs
    python3Packages.argcomplete
    python3Packages.pdftotext
    python3Packages.virtualenv
    patchelf
    expect
  ];
}
