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

  };
}
