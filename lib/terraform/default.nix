{
  pkgs,
  version ? "1.16.6",
  platform,
  hash,
}:

pkgs.stdenv.mkDerivation {
  pname = "terraform";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_${platform}.zip";
    inherit hash;
  };

  nativeBuildInputs = [ pkgs.unzip ];

  sourceRoot = ".";

  installPhase = ''
    install -Dm755 terraform $out/bin/terraform
  '';
}
