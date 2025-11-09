{ inputs, lib, config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      font_size = 12;
      font_family = "JetBrainsMono Nerd Font";
      font_features = "none";
      disable_ligatures = "always";
      copy_on_select = "yes";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      enable_audio_bell = "no";
      shell = "zsh";
      editor = "nvim";
      window_padding_width = 0;
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
      enabled_layouts = "vertical";
    };
    themeFile = "Tango_Dark";
    environment = { "TERM" = "xterm-256color"; };
  };
}
