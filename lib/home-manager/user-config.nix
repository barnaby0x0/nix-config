{ nixpkgs }:

let
  inherit (nixpkgs) lib;

  defaultUserConfig = {
    username = "user";
    homeDirectory = "/home/user";

    git = {
      name = "User";
      email = "user@example.com";
    };
  };

  loadUserConfig =
    let
      path = builtins.getEnv "NIXDOT_CONFIG";
    in
    lib.recursiveUpdate defaultUserConfig (if path == "" then { } else import (/. + path));
in
{
  inherit defaultUserConfig loadUserConfig;
}
