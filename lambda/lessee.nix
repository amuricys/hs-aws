{ mkDerivation, aeson, aeson-pretty, aws-lambda-haskell-runtime
, base, bytestring, http-types, stdenv, text
}:
mkDerivation {
  pname = "hs-lambda";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson aeson-pretty aws-lambda-haskell-runtime base bytestring
    http-types text
  ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
