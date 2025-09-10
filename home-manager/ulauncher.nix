{ inputs, lib, config, pkgs, ... }: {
  # Plugins:
  # - https://github.com/tjquillan/ulauncher-system

  home.packages = with pkgs; [ ulauncher ];

  xdg.configFile = {
    "autostart/ulauncher.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Ulauncher
      Exec=${pkgs.ulauncher}/bin/ulauncher
      Hidden=false
      NoDisplay=false
      X-GNOME-Autostart-enabled=true
      StartupNotify=false
    '';
  };
}
