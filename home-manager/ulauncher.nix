{ inputs, lib, config, pkgs, ... }: {
  # Plugins:
  # - https://github.com/tjquillan/ulauncher-system

  home.packages = with pkgs; [ ulauncher ];

  systemd.user.services.ulauncher = {
    Unit = {
      Description = "Linux Application Launcher";
      Documentation = [ "https://ulauncher.io/" ];
    };

    Service = {
      Type = "Simple";
      Restart = "Always";
      RestartSec = 1;
      ExecStart = pkgs.writeShellScript "ulauncher-env-wrapper.sh" ''
        if [ -e "$HOME/.nix-profile/share/" ]; then
          export XDG_DATA_DIRS="$HOME/.nix-profile/share:$XDG_DATA_DIRS"
        fi
        export PATH="''${XDG_BIN_HOME}:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
        export GDK_BACKEND=x11
        exec ${pkgs.ulauncher}/bin/ulauncher --hide-window
      '';
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
