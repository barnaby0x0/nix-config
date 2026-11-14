# packages/default.nix

{
  self,
  inputs,
  lib,
}:

let

  inherit (lib.commons) mkPkgs;
  inherit (lib.commons.system) forAllSystems;
  nlib = inputs.nixpkgs.lib;

  pkgsFor = forAllSystems mkPkgs;

  packageSets =
    map
      (
        path:
        import path {
          inherit
            self
            inputs
            lib
            pkgsFor
            ;
        }
      )
      [
        ./home-manager
        ./terraform
        ./packer
        ./vault
        ./vim
        ./bootstrap
      ];
in
forAllSystems (
  system:

  let

    pkgs = pkgsFor.${system};

    formats = [
      {
        name = "iso";
        package = "img-installer-iso";
        configuration = "installer-${system}";
        attribute = [ "isoImage" ];
      }
    ]
    ++ nlib.optional (system == "aarch64-linux") {
      name = "raw-efi";
      package = "img-lima-raw-efi";
      configuration = "lima";
      attribute = [
        "images"
        "raw-efi"
      ];
    };

  in
  nlib.mergeAttrsList (map (set: set.${system}) packageSets)
  // {
    brave = (pkgs.extend self.overlays.brave).brave;
  }
  // builtins.listToAttrs (
    map (format: {
      name = format.package;
      value =
        nlib.getAttrFromPath format.attribute
          self.nixosConfigurations.${format.configuration}.config.system.build;
    }) formats
  )
)
