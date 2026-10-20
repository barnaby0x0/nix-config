{ inputs, ... }:

{
  system = import ./system.nix {
    inherit inputs;
  };
}
