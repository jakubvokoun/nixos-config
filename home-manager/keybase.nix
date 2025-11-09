{ inputs, lib, config, pkgs, ... }: {
  services.keybase.enable = true;

  home.packages = with pkgs; [ keybase keybase-gui ];
}
