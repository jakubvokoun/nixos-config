{ inputs, lib, config, pkgs, ... }: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor-fhs;
    extraPackages = [ pkgs.nixd pkgs.ruff pkgs.nil pkgs.ty ];
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
      "opentofu"
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
      "typst"
      "mermaid"
      "perl"
      "dependi"
      "gotmpl"
      "django"
      "git-firefly"
      "tokyo-night"
    ];
    userSettings = {
      features = { copilot = false; };
      telemetry = { metrics = false; };
      vim_mode = true;
      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 14;
      buffer_font_weight = 500;
      ui_font_family = "Zed Plex Sans";
      ui_font_size = 16;
      ui_font_weight = 500;
      buffer_font_features = { calt = false; };
      theme = {
        mode = "system";
        light = "Tokyo Night";
        dark = "Tokyo Night";
      };
      icon_theme = {
        mode = "system";
        light = "Tokyo Night";
        dark = "Tokyo Night";
      };
      terminal = {
        font_size = 14;
        font_family = "JetBrainsMono Nerd Font";
      };
      languages = {
        Rust = {
          language_servers = [ "rust-analyzer" ];
          inlay_hints = { enabled = true; };
        };
        Go = {
          language_servers = [ "gopls" ];
          inlay_hints = { enabled = true; };
        };
        Python = { language_servers = [ "ty" "!basedpyright" ]; };
      };
      lsp = {
        rust-analyzer = {
          initialization_options = {
            inlayHints = {
              lifetimeElisionHints = { enable = "skip_trivial"; };
              closureReturnTypeHints = { enable = "with_block"; };
            };
          };
        };
        gopls = {
          initialization_options = {
            hints = {
              assignVariableTypes = true;
              compositeLiteralFields = true;
              compositeLiteralTypes = true;
              constantValues = true;
              functionTypeParameters = true;
              parameterNames = true;
              rangeVariableTypes = true;
            };
          };
        };
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
        Helm = [
          "**/templates/**/*.tpl"
          "**/templates/**/*.yaml"
          "**/templates/**/*.yml"
          "**/helmfile.d/**/*.yaml"
          "**/helmfile.d/**/*.yml"
          "**/values*.yaml"
        ];
        Dockerfile = [ "*.Dockerfile" "Dockerfile.*" ];
      };
    };
  };
}
