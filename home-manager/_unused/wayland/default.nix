{ inputs, lib, config, pkgs, ... }: {
  imports = [ ./sway.nix ./mako.nix ./waybar.nix ./wlsunset.nix ];
}
