{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/g3.yaml;

    age.keyFile = "/var/lib/sops-nix/keys.txt";

    secrets = {
      "github/token" = {
        owner = "root";
        mode = "0400";
      };

      "database/password" = {
        owner = "root";
        mode = "0400";
      };

      "api/key" = {
        owner = "root";
        mode = "0400";
      };
    };
  };

}
