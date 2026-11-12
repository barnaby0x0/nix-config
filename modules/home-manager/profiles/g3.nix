{ pkgs, ... }:

{
  imports = [
    ../programs
  ];

  my.programs.terminator.enable = true;
}
