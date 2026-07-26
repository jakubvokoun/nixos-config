{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Enable AppIndicator extension at the user level + dconf tweaks.
  # Requires `programs.dconf.enable = true` on the NixOS side.

  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    wl-clipboard
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf.settings = {
    # Enable the extension
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" ];
    };

    # Fixed number of workspaces = 4
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      # Optional but handy on multi-monitor setups:
      # workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 4;
      button-layout = "appmenu:minimize,maximize,close";
      titlebar-font = "Adwaita Sans Bold 11";
    };

    # Optional: keybindings to jump straight to workspace N
    "org/gnome/desktop/wm/keybindings" = {
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
    };

    "org/gnome/desktop/interface" = {
      cursor-theme = "Adwaita";
      cursor-size = 24;
      color-scheme = "default";
      icon-theme = "Papirus";
      accent-color = "blue"; # blue | teal | green | yellow | orange | red | pink | purple | slate
      font-name = "Adwaita Sans 11";
      document-font-name = "Adwaita Sans 12";
      monospace-font-name = "Adwaita Mono 11";
      # Wayland renders fonts grayscale regardless of "rgba"; subpixel would
      # only fringe. grayscale + full hinting is the practical AA ceiling here.
      font-antialiasing = "grayscale";
      font-hinting = "full";
      text-scaling-factor = 1.0;
    };
  };
}
