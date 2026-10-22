{
  self,
  pkgs,
  system,
  inputs,
  ...
}:
let
  devshellLib = import ./templates/dev.nix {
    inherit pkgs;
  };
in
{
  home-manager = import ./home-manager.nix { inherit self pkgs system; };
  devops = import ./devops.nix { inherit pkgs; };
  work = import ./work.nix {
    inherit
      self
      pkgs
      system
      inputs
      ;
  };
  go = import ./go.nix {
    inherit pkgs;
    lib = devshellLib;
  };
}

# { pkgs, ... }:

# (import ./devops { inherit pkgs; })
# //
# (import ./nix { inherit pkgs; })
# must import such thing:
# { pkgs, ... }:

# {
#   devops = pkgs.mkShell {
#     packages = [ pkgs.git ];
#   };
# }
