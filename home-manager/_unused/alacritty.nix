{ inputs, lib, config, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 0;
          y = 0;
        };
        decorations = "full";
        opacity = 1;
        startup_mode = "Windowed";
        title = "Alacritty";
        dynamic_title = true;
        decorations_theme_variant = "None";
      };
      font = {
        size = 12;
        normal.family = "JetBrainsMono Nerd Font";
        bold.family = "JetBrainsMono Nerd Font";
        italic.family = "JetBrainsMono Nerd Font";
      };
      selection = { save_to_clipboard = true; };
      env = {
        WINIT_X11_SCALE_FACTOR = "1.0";
        TERM = "xterm-256color";
      };
    };
  };
}
