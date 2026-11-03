{
  pkgs,
  version ? "1.17.0",
  platform,
  hash,
}:

pkgs.stdenv.mkDerivation {
  pname = "vault";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://releases.hashicorp.com/vault/${version}/vault_${version}_${platform}.zip";
    inherit hash;
  };

  nativeBuildInputs = [ pkgs.unzip ];

  sourceRoot = ".";

  installPhase = ''
    install -Dm755 vault $out/bin/vault
  '';
}
