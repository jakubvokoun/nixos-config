{ inputs, lib, config, pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 12;
      font-family = "CaskaydiaMono Nerd Font";
      theme = "Builtin Tango Dark";
      window-decoration = "server";
    };
  };
}
