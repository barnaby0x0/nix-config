{
  self,
  inputs,
  lib,
}:

{
  home-manager = import ./home-manager {
    inherit self inputs lib;
  };
}
