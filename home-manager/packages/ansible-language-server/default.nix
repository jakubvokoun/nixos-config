{ pkgs ? import <nixpkgs> { } }:

pkgs.mkYarnPackage {
  name = "ansible-language-server";
  src = ./.;
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  yarnNix = ./yarn.nix;

  # Make binaries available
  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/libexec/ansible-language-server/node_modules/.bin/* $out/bin
  '';
}
