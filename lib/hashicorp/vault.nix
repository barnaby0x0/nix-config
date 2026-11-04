{ mkHashicorpPackage }:

{
  pkgs,
  version,
  platform,
  hash,
}:

mkHashicorpPackage {
  inherit
    pkgs
    version
    platform
    hash
    ;
  pname = "vault";
}
