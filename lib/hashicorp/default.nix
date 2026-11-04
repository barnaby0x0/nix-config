let
  mkHashicorpPackage = import ./mkHashicorpPackage.nix;

  packages = [
    "terraform"
    "packer"
    "vault"
  ];

in
builtins.listToAttrs (
  map (pname: {
    name = pname;
    value = args: mkHashicorpPackage (args // { inherit pname; });
  }) packages
)
