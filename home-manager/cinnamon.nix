{ inputs, lib, config, pkgs, ... }:
with lib.hm.gvariant; {
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  dconf.settings = {
    "org/cinnamon" = {
      panels-enabled = [ "1:0:top" ];
      panels-height = [ "1:40" ];
      panels-autohide = [ "1:false" ];
      panels-resizable = [ "1:false" ];
    };

    "org/cinnamon/desktop/interface" = {
      cursor-size = 24;
      cursor-theme = "Bibata-Modern-Classic";
      font-name = "DejaVu Sans 10";
      gtk-theme = "Mint-Y-Blue";
      icon-theme = "Mint-Y-Blue";
      text-scaling-factor = 1.0;
    };

    "org/cinnamon/desktop/media-handling" = { autorun-never = false; };

    "org/cinnamon/desktop/peripherals/keyboard" = { numlock-state = true; };

    "org/cinnamon/desktop/peripherals/mouse" = {
      double-click = 400;
      drag-threshold = 8;
      speed = 0.0;
    };

    "org/cinnamon/desktop/peripherals/touchpad" = {
      natural-scroll = false;
      speed = 0.0;
    };

    "org/cinnamon/desktop/session" = { idle-delay = mkUint32 300; };

    "org/cinnamon/desktop/screensaver" = {
      idle-activation-enabled = true;
      lock-enabled = true;
      lock-delay = mkUint32 0;
      ask-for-away-message = false;
      show-info-panel = true;
    };

    "org/cinnamon/desktop/sound" = { event-sounds = false; };

    "org/cinnamon/desktop/wm/preferences" = {
      titlebar-font = "DejaVu Sans Bold 10";
    };

    "org/cinnamon/settings-daemon/peripherals/keyboard" = {
      numlock-state = "on";
    };

    "org/cinnamon/settings-daemon/plugins/power" = {
      lid-close-ac-action = "suspend";
      lid-close-battery-action = "suspend";
      sleep-display-ac = 1800;
      sleep-display-battery = 1800;
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-battery-timeout = 0;
    };

    "org/cinnamon/settings-daemon/plugins/xsettings" = {
      hinting = "full";
      antialiasing = "rgba";
    };

    "org/cinnamon/theme" = { name = "Mint-Y-Blue"; };

    "org/gnome/terminal/legacy" = { theme-variant = "system"; };

    "org/gnome/terminal/legacy/profiles:" = {
      default = "b1dcc9dd-5262-4d8d-a863-c897e6d979b9";
      list = [ "b1dcc9dd-5262-4d8d-a863-c897e6d979b9" ];
    };

    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" =
      {
        background-color = "rgb(0,0,0)";
        foreground-color = "rgb(255,255,255)";
        bold-is-bright = true;
        font = "JetBrainsMono Nerd Font Mono 12";
        use-system-font = false;
        use-theme-colors = false;
        palette = [
          "rgb(46,52,54)"
          "rgb(204,0,0)"
          "rgb(78,154,6)"
          "rgb(196,160,0)"
          "rgb(52,101,164)"
          "rgb(117,80,123)"
          "rgb(6,152,154)"
          "rgb(211,215,207)"
          "rgb(85,87,83)"
          "rgb(239,41,41)"
          "rgb(138,226,52)"
          "rgb(252,233,79)"
          "rgb(114,159,207)"
          "rgb(173,127,168)"
          "rgb(52,226,226)"
          "rgb(238,238,236)"
        ];
      };

  };
}
