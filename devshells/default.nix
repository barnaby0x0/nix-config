{
  self,
  pkgs,
  system,
  ...
}:
{
  home-manager = import ./home-manager.nix { inherit self pkgs system; };
  devops = import ./devops.nix { inherit pkgs; };
  go = import ./go.nix { inherit pkgs; };
  test = import ./test.nix { inherit pkgs; };
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
