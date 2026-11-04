{
  pkgs,
  pname,
  version,
  platform,
  hash,
  binaryName ? pname,
}:

pkgs.stdenv.mkDerivation {
  inherit pname version;

  src = pkgs.fetchurl {
    url = "https://releases.hashicorp.com/${pname}/${version}/${pname}_${version}_${platform}.zip";
    inherit hash;
  };

  nativeBuildInputs = [ pkgs.unzip ];

  sourceRoot = ".";

  installPhase = ''
    install -Dm755 ${pname} $out/bin/${binaryName}
  '';
}
