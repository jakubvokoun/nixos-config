{ inputs, lib, config, pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        font = wezterm.font("JetBrainsMono Nerd Font", { weight = 'Regular', italic = false }),
        font_size = 12.0,
        front_end = "WebGpu",
        harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
        window_padding = {
          left = 0,
          right = 0,
          top = 0,
          bottom = 0,
        },
        color_scheme = "iTerm2 Tango Dark",
        hide_tab_bar_if_only_one_tab = true,
        audible_bell = "Disabled"
      };
    '';
  };
}
