{ inputs, lib, config, pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        font = wezterm.font("CaskaydiaMono Nerd Font", { weight = 'Regular', italic = false }),
        font_size = 14.0,
        window_padding = {
          left = 0,
          right = 0,
          top = 0,
          bottom = 0,
        },
        color_scheme = "Tango (terminal.sexy)",
        hide_tab_bar_if_only_one_tab = true,
        audible_bell = "Disabled"
      };
    '';
  };
}
