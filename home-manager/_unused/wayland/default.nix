{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./sway.nix
    ./mako.nix
    ./rofi.nix
    ./wlogout.nix
    ./waybar.nix
    ./wlsunset.nix
  ];
}
