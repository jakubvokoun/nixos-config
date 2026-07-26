{ config, pkgs, ... }:

{
  # Enable X11 + GDM + GNOME
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "cz,us";
        options = "grp:alt_shift_toggle";
      };
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  # Extra packages useful for GNOME
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    adwaita-icon-theme
    adw-gtk3 # GTK3 apps follow libadwaita theme
    papirus-icon-theme # nicer icons (optional)

    # GNOME Shell extensions used below
    gnomeExtensions.appindicator # tray icons (AppIndicator/KStatusNotifier)

    # Provides org.gnome.keyring.SystemPrompter
    gcr
  ];

  # Required for AppIndicator extension to actually see tray items
  services.udev.packages = [ pkgs.gnome-settings-daemon ];

  # Enable dconf (Home Manager dconf settings need this)
  programs.dconf.enable = true;

  # Fonts — GNOME defaults assume Cantarell etc. are present
  fonts.packages = with pkgs; [
    cantarell-fonts
    noto-fonts
    noto-fonts-color-emoji
  ];
}
