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

  # homeManagerPackages = import ./home-manager {
  #   inherit self inputs lib;
  # };

  # terraformPackages = import ./terraform {
  #   inherit self inputs lib;
  # };

  # packerPackages = import ./packer {
  #   inherit self inputs lib;
  # };

  # vaultPackages = import ./vault {
  #   inherit self inputs lib;
  # };

  # vimPackages = import ./vim {
  #   inherit self inputs lib;
  # };

  # bootstrap = import ./bootstrap {
  #   inherit self inputs lib;
  # };

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

    # formats = [
    #   {
    #     name = "iso";
    #     package = "img-installer-iso";
    #     configuration = "installer-${system}";
    #     attribute = [ "isoImage" ];
    #   }
    # ]
    # ++ inputs.nixpkgs.lib.optional (system == "aarch64-linux") {
    #   name = "raw-efi";
    #   package = "img-lima-raw-efi";
    #   configuration = "lima";
    #   attribute = [
    #     "images"
    #     "raw-efi"
    #   ];
    # };
  in
  nlib.mergeAttrsList (map (set: set.${system}) packageSets)
  # homeManagerPackages.${system}
  # // terraformPackages.${system}
  # // packerPackages.${system}
  # // vaultPackages.${system}
  # // vimPackages.${system}
  # // bootstrap.${system}
  // {
    brave = (pkgs.extend self.overlays.brave).brave;
    # brave =
    #   let
    #     pkgs = import inputs.nixpkgs {
    #       inherit system;
    #       overlays = [ self.overlays.brave ];
    #     };
    #   in
    #   pkgs.brave;
  }
  # // builtins.listToAttrs (
  #   map (format: {
  #     name = format.package;
  #     value = builtins.foldl' (
  #       attrs: attr: builtins.getAttr attr attrs
  #     ) self.nixosConfigurations.${format.configuration}.config.system.build format.attribute;
  #   }) formats
  # )
  // builtins.listToAttrs (
    map (format: {
      name = format.package;
      value =
        nlib.getAttrFromPath format.attribute
          self.nixosConfigurations.${format.configuration}.config.system.build;
    }) formats
  )
)
