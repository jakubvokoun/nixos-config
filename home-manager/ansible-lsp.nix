{ inputs, lib, config, pkgs, ... }: {
  home.packages = [
    (pkgs.callPackage
      "${config.home.homeDirectory}/.config/home-manager/packages/ansible-language-server"
      { })
  ];
}
