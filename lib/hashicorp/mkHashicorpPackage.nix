{
  pkgs,
  pname,
  version,
  platform,
  hash,
  extension ? "zip",
  installPhase ? ''
    install -Dm755 ${pname} $out/bin/${pname}
  '',
}:

pkgs.stdenv.mkDerivation {
  inherit pname version;

  src = pkgs.fetchurl {
    url = "https://releases.hashicorp.com/${pname}/${version}/${pname}_${version}_${platform}.${extension}";
    inherit hash;
  };

  nativeBuildInputs = [ pkgs.unzip ];

  sourceRoot = ".";

  inherit installPhase;
}
