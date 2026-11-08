{ self, ... }:

{
  nixpkgs.overlays = [
    # À réactiver seulement si tu réintroduis cette dépendance.
    # nix-cachyos-kernel.overlays.pinned

    # Overlay pour corriger Lazarus
    (final: prev: {
      lazarus-qt6 = prev.lazarus-qt6.overrideAttrs (old: {
        postInstall =
          builtins.replaceStrings
            [
              ''
                --prefix NIX_LDFLAGS ' ' "$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')" \
              ''
              ''
                --prefix NIX_LDFLAGS_x86_64_unknown_linux_gnu ' ' "$(echo "$NIX_LDFLAGS" | sed -re 's/-rpath [^ ]+//g')" \
              ''
            ]
            [
              ""
              ""
            ]
            old.postInstall;
      });
    })

    self.overlays.brave
  ];
}
