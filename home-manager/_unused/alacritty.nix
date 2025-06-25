{ inputs, lib, config, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 14;
        normal.family = "CaskaydiaMono Nerd Font";
        bold.family = "CaskaydiaMono Nerd Font";
        italic.family = "CaskaydiaMono Nerd Font";
      };
      env = {
        WINIT_X11_SCALE_FACTOR = "1.0";
        TERM = "xterm-256color";
      };
    };
  };
}
