{ inputs, lib, config, pkgs, ... }: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "ansible"
      "csv"
      "helm"
      "html"
      "nix"
      "php"
      "sql"
      "terraform"
      "toml"
      "pylsp"
      "make"
      "dockerfile"
    ];
    userSettings = {
      features = { copilot = false; };
      telemetry = { metrics = false; };
      vim_mode = false;
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "Zed Plex Mono";
      ui_font_family = "Zed Plex Sans";
      theme = {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };
    };
  };
}
