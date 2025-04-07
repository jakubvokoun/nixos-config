{ inputs, lib, config, pkgs, ... }: {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      fonts = {
        names = [ "DejaVu Sans Mono" ];
        size = 10.0;
      };
      bars = [{
        command = "${pkgs.i3}/bin/i3bar";
        statusCommand = "${pkgs.i3status}/bin/i3status";
        fonts = {
          names = [ "DejaVu Sans Mono" ];
          size = 10.0;
        };
      }];
      startup = [
        {
          command = "xss-lock --transfer-sleep-lock -- i3lock";
        }
        #{ command = "xsetroot -solid '#477084'"; }
        { command = "nitrogen --restore"; }
        { command = "nm-applet"; }
      ];
    };
    extraConfig = ''

      # Move workspace
      bindsym Mod4+m move workspace to output left
      bindsym Mod4+Shift+m move workspace to output right

      # Reset wallpaper
      bindsym Mod4+b exec --no-startup-id nitrogen --restore

      # Run rofi -show drun
      bindsym Mod1+space exec --no-startup-id rofi -show drun

      # Run rofi -show window
      #bindsym Mod1+Tab exec --no-startup-id rofi -show window
      bindsym Mod1+Tab exec --no-startup-id rofi -modi combi -combi-modi window -show combi

      # Mouse focus
      focus_follows_mouse no

      # Exit mode
      set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (d) shutdown
      mode "$mode_system" {
          bindsym l exec --no-startup-id i3lock, mode "default"
          bindsym e exec --no-startup-id "i3-nagbar -t warning -m 'You pressed the exit shortcut. All unsaved data will be lost.' -b 'Yes, exit i3' 'i3-msg exit'", mode "default"
          bindsym s exec --no-startup-id i3lock, mode default; exec --no-startup-id systemctl suspend, mode "default"
          bindsym h exec --no-startup-id i3lock, mode default; exec --no-startup-id systemctl hibernate, mode "default"
          bindsym r exec --no-startup-id "i3-nagbar -t warning -m 'You pressed the reboot shortcut. All unsaved data will be lost.' -b 'Yes, reboot' 'systemctl reboot'", mode "default"
          bindsym d exec --no-startup-id "i3-nagbar -t warning -m 'You pressed the shutdown shortcut. All unsaved data will be lost.' -b 'Yes, shutdown' 'systemctl poweroff'", mode "default"

          # back to normal: Enter or Escape
          bindsym Return mode "default"
          bindsym Escape mode "default"
      }
      bindsym Mod4+Shift+x mode "$mode_system"
    '';
  };

  home.packages = with pkgs; [
    dmenu
    rofi
    i3status
    i3lock
    xss-lock
    arandr
    pavucontrol
    libnotify
    nitrogen
  ];

  services.dunst.enable = true;

  services.picom.enable = true;

  xsession = {
    enable = true;
    profileExtra = ''
      export $(${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
    '';
  };
}
