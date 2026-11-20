{ config, lib, ... }:
let
  cfg = config.custom.disk;

  nixFs = {
    type = "filesystem";
    format = "ext4";
    mountpoint = "/nix";
  };
in
{
  options.custom.disk = {
    encrypt = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Chiffrer la partition /nix avec LUKS.";
    };

    luksPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str; # str, pas path : évite la copie dans le store
      default = null;
      example = "/tmp/luks.key";
      description = "Fichier de passphrase lu par disko au formatage. null = saisie interactive.";
    };

    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/nvme0n1";
      example = "/dev/disk/by-id/nvme-Samsung_SSD_980_PRO_1TB_S123456789";
      description = "Disque cible, entièrement effacé par disko.";
    };

    swapSize = lib.mkOption {
      type = lib.types.str;
      default = "8G";
      description = "Taille du swap.";
    };

  };

  config = {
    disko.devices.disk.main = {
      type = "disk";
      device = cfg.device;

      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "EFI";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "fmask=0077"
                "dmask=0077"
              ];
            };
          };

          swap = {
            # size = "8G";
            size = cfg.swapSize;
            content = {
              type = "swap";
              resumeDevice = false;
              randomEncryption = true;
            };
          };

          nix = {
            name = "NIXOS";
            size = "100%";
            content =
              if cfg.encrypt then
                {
                  type = "luks";
                  name = "cryptnix";
                  settings.allowDiscards = true;
                  content = nixFs;
                }
                // lib.optionalAttrs (cfg.luksPasswordFile != null) {
                  passwordFile = cfg.luksPasswordFile;
                }
              else
                nixFs;
          };
        };
      };
    };

    # Réglages qui n'ont de sens qu'avec LUKS (déverrouillage TPM2, par exemple)
    boot.initrd.systemd.enable = lib.mkIf cfg.encrypt true;
  };
}
