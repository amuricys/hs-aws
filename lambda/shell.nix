{ pkgs ? import <nixpkgs> {} }:

let 
  poetry2nix = pkgs.poetry2nix;
  python3 = pkgs.python3;
in
poetry2nix.mkPoetryApplication {
  python = python3;
  projectDir = ./.;
}
