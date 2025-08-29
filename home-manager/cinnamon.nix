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
    };

    "desktop/interface" = {
      cursor-size = 24;
      cursor-theme = "Bibata-Modern-Classic";
      font-name = "DejaVu Sans 10";
      gtk-theme = "Mint-Y-Blue";
      icon-theme = "Mint-Y-Blue";
      text-scaling-factor = 1.0;
    };

    "desktop/media-handling" = { autorun-never = false; };

    "desktop/peripherals/keyboard" = { numlock-state = true; };

    "desktop/peripherals/mouse" = {
      double-click = 400;
      drag-threshold = 8;
      speed = 0.0;
    };

    "desktop/peripherals/touchpad" = {
      natural-scroll = false;
      speed = 0.0;
    };

    "desktop/session" = { idle-delay = mkUint32 300; };

    "desktop/sound" = { event-sounds = false; };

    "desktop/wm/preferences" = { titlebar-font = "DejaVu Sans Bold 10"; };

    "settings-daemon/peripherals/keyboard" = { numlock-state = "on"; };

    "settings-daemon/plugins/power" = {
      lid-close-ac-action = "suspend";
      lid-close-battery-action = "suspend";
      sleep-display-ac = 1800;
      sleep-display-battery = 1800;
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-battery-timeout = 0;
    };

    "settings-daemon/plugins/xsettings" = { hinting = "full"; };

    "theme" = { name = "Mint-Y-Blue"; };

  };

  # TODO
  xdg.autostart = {
    enable = true;
    entries = [ ];
  };
}
