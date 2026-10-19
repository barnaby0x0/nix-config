{ inputs }:

{
  homeManager = import ./home-manager {
    inherit (inputs) nixpkgs home-manager;
  };
}
