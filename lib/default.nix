{ inputs, ... }:

{
  commons = import ./commons {
    inherit inputs;
  };

  homeManager = import ./home-manager {
    inherit inputs;
    inherit (inputs) nixpkgs;
  };
}