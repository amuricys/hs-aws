# Little snippet from Niv to get our pinned dependencies
{ sources ? import ./nix/sources.nix }:
with { overlay = _: pkgs: { niv = import sources.niv {}; }; };

let
    # We use a nixpkgs version with modified configuration to build static
    # executables. From https://github.com/nh2/static-haskell-nix
    pkgs = (import (sources.static-haskell-nix + "/survey/default.nix") {
      # This is the nixpkgs revision we are modifying.
      # We pinned the revision with 'niv add NixOS/nixpkgs -a rev=<sha256>
      normalPkgs = import sources.nixpkgs {};
    }).pkgs;

    # Nix usually takes all files in the source directory into consideration and
    # busts the cache whenever any of these files change. To avoid that
    # we use hercules-ci/gitignore.nix so that nix will ignore files included in
    # our .gitignore
    gitignoreSource = (import sources.gitignore { lib = pkgs.lib; }).gitignoreSource;

    hs-lambda =
        pkgs.haskell.lib.overrideCabal
            # Create a nix derivation from the cabal package
            (pkgs.haskellPackages.callCabal2nix "hs-lambda" (gitignoreSource ./.) {})
            # Set flags that make sure that we are building a truly static executable
            (old: {
                  configureFlags = [
                    "-flambda"
                    "--ghc-option=-optl=-static"
                    "--extra-lib-dirs=${pkgs.gmp6.override { withStatic = true; }}/lib"
                    "--extra-lib-dirs=${pkgs.zlib.static}/lib"
                    "--extra-lib-dirs=${pkgs.libffi.overrideAttrs (old: { dontDisableStatic = true; })}/lib"
                    "--disable-executable-stripping"
                  ];
            });

    # Create a zip file ready to be sent to AWS lambda
    function-zip = pkgs.runCommandNoCC "hs-lambda.zip" { buildInputs = [ pkgs.zip ]; }
      ''
          mkdir -p $out
          cp ${hs-lambda}/bin/hs-lambda bootstrap
          zip $out/function.zip bootstrap
      '';
in
{ inherit
    hs-lambda
    function-zip ;
}
