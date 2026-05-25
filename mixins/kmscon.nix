{ config, pkgs, lib, ... }: {
  services.kmscon = {
    enable = true;
    fonts = [{
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
    }];
    extraConfig = ''
      font-engine=pango
      font-size=14
      font-name=JetBrainsMono Nerd Font
    '';
  };
}
