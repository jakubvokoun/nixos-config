{ inputs, lib, config, pkgs, ... }: {
  services.gnome-keyring.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.enable = true;
    config = rec {
      modifier = "Mod4";
      #terminal = "alacritty"; 
      #startup = [];
      fonts = {
        names = [ "DejaVu Sans Mono" ];
        size = 10.0;
      };
      bars = [{
        command = "${pkgs.sway}/bin/swaybar";
        statusCommand = "${pkgs.i3status}/bin/i3status";
        fonts = {
          names = [ "DejaVu Sans Mono" ];
          size = 10.0;
        };
      }];
      startup = [
        #{ command = "xss-lock --transfer-sleep-lock -- i3lock"; }
        { command = "nm-applet"; }
      ];
    };
  };

  services.mako = {
    enable = true;
    defaultTimeout = 4500;
    ignoreTimeout = true;
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 295;
        command =
          "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
      }
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        timeout = 360;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
    events = [{
      event = "before-sleep";
      command = "${pkgs.swaylock}/bin/swaylock";
    }];
  };

  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
    };
  };

  home.packages = with pkgs; [ wdisplays ];
}
