{
  self,
  inputs,
  lib,
}:

let
  inherit (lib.commons.system) forAllSystems;

  homeManagerPackages = import ./home-manager {
    inherit self inputs lib;
  };

  terraformPackages = import ./terraform {
    inherit self inputs lib;
  };

  vimPackages = import ./vim {
    inherit self inputs lib;
  };

in
forAllSystems (
  system:

  let
    formats = [
      {
        name = "iso";
        package = "img-installer-iso";
        configuration = "installer-${system}";
        attribute = [ "isoImage" ];
      }
    ]
    ++ inputs.nixpkgs.lib.optional (system == "x86_64-linux") {
      name = "raw-efi";
      package = "img-lima-raw-efi";
      configuration = "lima";
      attribute = [
        "images"
        "raw-efi"
      ];
    };
  in

  homeManagerPackages.${system}
  // terraformPackages.${system}
  // vimPackages.${system}
  # // inputs.nixpkgs.lib.optionalAttrs (system == "x86_64-linux") {
  #   iso-installer = self.nixosConfigurations."installer-${system}".config.system.build.isoImage;
  # }
  # // {
  #   iso-installer = self.nixosConfigurations."installer-${system}".config.system.build.isoImage;
  # }
  # // builtins.listToAttrs (
  #   map (format: {
  #     name = "image-${format}";
  #     value = self.nixosConfigurations."installer-${system}".config.system.build.images.${format};
  #   }) formats
  # )
  // builtins.listToAttrs (
    map (format: {
      name = format.package;
      value = builtins.foldl' (
        attrs: attr: builtins.getAttr attr attrs
      ) self.nixosConfigurations.${format.configuration}.config.system.build format.attribute;
    }) formats
  )
)
