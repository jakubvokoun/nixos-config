{ inputs, lib, config, pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      fonts = {
        names = [ "DejaVu Sans Mono" ];
        size = 10.0;
      };
      bars = [{ command = "${pkgs.waybar}/bin/waybar"; }];

      startup = [
        { command = "waypaper --restore"; }
        { command = "nm-applet"; }
        { command = "sleep 5; systemctl --user start kanshi.service"; }
      ];
    };
    extraConfig = ''

      # Keyboard
      input type:keyboard {
        xkb_layout "cz"
      }

      # Move workspace
      bindsym Mod4+m move workspace to output left
      bindsym Mod4+Shift+m move workspace to output right

      # Run rofi -show drun
      bindsym Mod1+space exec --no-startup-id rofi -show drun

      # Run rofi -show window
      bindsym Mod1+Tab exec --no-startup-id rofi -modi combi -combi-modi window -show combi

      # Logout
      bindsym Mod4+Shift+x exec --no-startup-id wlogout

      # XF86 keys
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SOURCE@ toggle
      bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
      bindsym XF86MonBrightnessUp exec brightnessctl set 5%+
    '';
  };

  programs.swaylock = {
    enable = true;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
    };
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "sh -c '(sleep 0.5s; ${pkgs.swaylock}/bin/swaylock)'";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  programs.zsh = {
    sessionVariables = { "SSH_AUTH_SOCK" = "/run/user/1000/keyring/ssh"; };
  };

  home.packages = with pkgs; [
    swaybg
    waypaper
    wdisplays
    grim
    slurp
    wl-clipboard
    mako
    libnotify
    pavucontrol
    xfce.thunar
    xfce.thunar-volman
    xfce.ristretto
    networkmanagerapplet
  ];

  services.gnome-keyring.enable = true;

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
}
