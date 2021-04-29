{ lambda-version ? "0.0.1",
  haskellNix ? import (builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz") {} }:

with (import ./default.nix {}) // (import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs);

let
  packages = (import ./. {});
  exePath = hs-lambda.components.exes.hs-lambda;
  executable-name = "hs-lambda";
  lambda-name = "i-have-the-godly-lambda-name-of-hs-lambda";
    in
      stdenv.mkDerivation {
        name = lambda-name;

        dontPatchShebangs = true;

        buildPhase = "";

        buildInputs = [ hs-lambda.components.exes.hs-lambda zip patchelf ];

        src = ./.;

        phases = [ "installPhase" ];

        installPhase = ''
            mkdir $out/

            cp ${exePath}/bin/${executable-name} $out/.bootstrap

            chmod +w $out/.bootstrap

            # patchelf --set-interpreter /var/task/ld-linux-x86-64.so.2 $out/.bootstrap

            cat > $out/bootstrap <<EOF
            #! /bin/sh -e
            cd "\''${0%/*}"
            export LD_LIBRARY_PATH='/var/task'\''${LD_LIBRARY_PATH:+':'}\$LD_LIBRARY_PATH
            exec -a "\$0" "./.bootstrap"  "\$@"
            EOF

            chmod +x $out/bootstrap

            zip -qrj $out/${lambda-name}_${lambda-version}.zip \
              $out/bootstrap \
              $out/.bootstrap
              

            rm $out/bootstrap
          '';
      }