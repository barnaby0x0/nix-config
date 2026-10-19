{
  self,
  inputs,
  lib,
}:

let
  homeManagerPackages = import ./home-manager {
    inherit self inputs lib;
  };
in
homeManagerPackages
