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
    };
  };
}
