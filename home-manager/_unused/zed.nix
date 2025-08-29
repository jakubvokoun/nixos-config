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
      "xml"
      "terraform"
      "toml"
      "pylsp"
      "make"
      "justfile"
      "jinja2"
      "awk"
      "dockerfile"
      "docker-compose"
      "blade"
      "templ"
      "catppuccin"
      "catppuccin-icons"
    ];
    userSettings = {
      features = { copilot = false; };
      telemetry = { metrics = false; };
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "Zed Plex Mono";
      buffer_font_weight = 500;
      ui_font_family = "Zed Plex Sans";
      ui_font_weight = 500;
      theme = {
        mode = "system";
        light = "Catppuccin Mocha";
        dark = "Catppuccin Mocha";
      };
      icon_theme = {
        mode = "system";
        light = "Catppuccin Mocha";
        dark = "Catppuccin Mocha";
      };
      terminal = {
        font_size = 16;
        font_family = "Zed Plex Mono";
      };
      file_types = {
        Ansible = [
          "**.ansible.yml"
          "**.ansible.yaml"
          "**/defaults/*.yml"
          "**/defaults/*.yaml"
          "**/meta/*.yml"
          "**/meta/*.yaml"
          "**/tasks/*.yml"
          "**/tasks/*.yaml"
          "**/handlers/*.yml"
          "**/handlers/*.yaml"
          "**/group_vars/*.yml"
          "**/group_vars/*.yaml"
          "**/playbooks/*.yml"
          "**/playbooks/*.yaml"
          "**playbook*.yml"
          "**playbook*.yaml"
        ];
        Dockerfile = [ "Dockerfile.*" ];
      };
    };
  };
}
