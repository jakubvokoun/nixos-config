{ inputs, lib, config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      font_size = 14;
      font_family = "CaskaydiaMono Nerd Font";
      copy_on_select = "yes";
      cursor_shape = "block";
      cursor_blink_interval = 0;
      enable_audio_bell = "no";
      shell = "zsh";
      editor = "nvim";
      window_padding_width = 0;
      tab_title_template = "{index}";
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
      enabled_layouts = "vertical";
    };
    themeFile = "Tango_Dark";
    environment = { "TERM" = "xterm-256color"; };
  };
}
