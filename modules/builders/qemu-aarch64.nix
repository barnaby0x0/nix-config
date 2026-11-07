{ ... }:

{
  # Enregistrement de QEMU dans binfmt_misc
  boot.binfmt = {
    emulatedSystems = [
      "aarch64-linux"
    ];

    # Utiliser les émulateurs statiques quand disponibles
    preferStaticEmulators = true;
  };
}
