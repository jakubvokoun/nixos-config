{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  binding = "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vicinae/";
in
{
  # Home Manager ships `programs.vicinae` itself, so the flake's
  # homeManagerModules.default is not imported (it declares the same options).
  # The package comes from the vicinae flake, cached on vicinae.cachix.org
  # (see system/cachix/vicinae.nix); nixpkgs' vicinae lags behind.
  programs.vicinae = {
    enable = true;
    package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd = {
      enable = true;
      autoStart = true;
    };
  };

  # Alt+Space toggles the launcher. Super+Space stays on input-source
  # switching; GNOME's window menu loses Alt+Space so the two don't collide.
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [ binding ];
    ${lib.removePrefix "/" (lib.removeSuffix "/" binding)} = {
      name = "Vicinae";
      command = "${lib.getExe' config.programs.vicinae.package "vicinae"} toggle";
      binding = "<Alt>space";
    };
    "org/gnome/desktop/wm/keybindings".activate-window-menu = [ ];
  };
}
