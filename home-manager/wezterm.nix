{ inputs, lib, config, pkgs, ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        -- Fonts
        font = wezterm.font("JetBrainsMono Nerd Font", { weight = 'Regular', italic = false }),
        font_size = 12.0,
        front_end = "WebGpu",
        harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

        -- Window
        window_padding = {
          left = 0,
          right = 0,
          top = 0,
          bottom = 0,
        },

        -- Color scheme
        color_scheme = "iTerm2 Tango Dark",

        -- Tab bar
        hide_tab_bar_if_only_one_tab = true,
        use_fancy_tab_bar = false,
        tab_and_split_indices_are_zero_based = true,

        -- Bell
        audible_bell = "Disabled",
        
        -- Confirm closing
        skip_close_confirmation_for_processes_named = {},
        window_close_confirmation = "AlwaysPrompt",

        -- Keybord shortcuts
        leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 },
        keys = {
          {
            mods = "LEADER",
            key = "c",
            action = wezterm.action.SpawnTab "CurrentPaneDomain",
          },
          {
            mods = "LEADER",
            key = "x",
            action = wezterm.action.CloseCurrentPane { confirm = true }
          },
          {
            mods = "LEADER",
            key = "p",
            action = wezterm.action.ActivateTabRelative(-1)
          },
          {
            mods = "LEADER",
            key = "n",
            action = wezterm.action.ActivateTabRelative(1)
          },
          {
            mods = "LEADER",
            key = "/",
            action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
          },
          {
            mods = "LEADER",
            key = "-",
            action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
          },
          {
            mods = "LEADER",
            key = "h",
            action = wezterm.action.ActivatePaneDirection "Left"
          },
          {
            mods = "LEADER",
            key = "j",
            action = wezterm.action.ActivatePaneDirection "Down"
          },
          {
            mods = "LEADER",
            key = "k",
            action = wezterm.action.ActivatePaneDirection "Up"
          },
          {
            mods = "LEADER",
            key = "l",
            action = wezterm.action.ActivatePaneDirection "Right"
          },
          {
            mods = "LEADER",
            key = "LeftArrow",
            action = wezterm.action.AdjustPaneSize { "Left", 5 }
          },
          {
            mods = "LEADER",
            key = "RightArrow",
            action = wezterm.action.AdjustPaneSize { "Right", 5 }
          },
          {
            mods = "LEADER",
            key = "DownArrow",
            action = wezterm.action.AdjustPaneSize { "Down", 5 }
          },
          {
            mods = "LEADER",
            key = "UpArrow",
            action = wezterm.action.AdjustPaneSize { "Up", 5 }
          },
        },
      };
    '';
  };
}
