{ inputs, lib, config, pkgs, ... }: {
  config = {
    gtk = {
      enable = true;
      gtk4.extraConfig = { gtk-application-prefer-dark-theme = "0"; };
      theme = { name = "Adwaita"; };
      #cursorTheme = {
      #  package = pkgs.adwaita-icon-theme;
      #  name = "Adwaita";
      #};
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style = {
        name = "adwaita";
        package = pkgs.adwaita-qt;
      };
    };
  };
}
