let
  # Récupère les inputs verrouillés par le flake du dépôt.
  flake = builtins.getFlake (toString ../.);
  nixpkgs = flake.inputs.nixpkgs;

  # Évaluateur NixOS fourni par cette version de nixpkgs.
  evalConfig = import (nixpkgs.outPath + "/nixos/lib/eval-config.nix");

  # Construit un système de test pour une valeur donnée.
  mkCase =
    enableVirt:
    let
      evaluated = evalConfig {
        system = "x86_64-linux";

        specialArgs.users = {
          alice = {
            inherit enableVirt;
          };
        };

        modules = [
          ../modules/nixos/virt.nix

          ({ ... }: {
            system.stateVersion = "26.05";

            # Déclare l'utilisateur dans le système de test.
            users.users.alice.isNormalUser = true;
          })
        ];
      };

      config = evaluated.config;
    in
    {
      libvirtd = config.virtualisation.libvirtd.enable;
      groups = config.users.users.alice.extraGroups;
    };

  enabled = mkCase true;
  disabled = mkCase false;

in

# Assertions : si une condition échoue, l'évaluation échoue.
assert enabled.libvirtd;
assert builtins.elem "libvirtd" enabled.groups;
assert builtins.elem "kvm" enabled.groups;

assert !disabled.libvirtd;
assert !(builtins.elem "libvirtd" disabled.groups);
assert !(builtins.elem "kvm" disabled.groups);

# Valeurs retournées pour rendre les résultats lisibles.
{
  enabled = {
    inherit (enabled) libvirtd groups;
  };

  disabled = {
    inherit (disabled) libvirtd groups;
  };
}
