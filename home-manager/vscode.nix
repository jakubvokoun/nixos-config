{ inputs, lib, config, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    userSettings = {
      "editor.fontFamily" = "CaskaydiaMono Nerd Font";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;
      "editor.formatOnSave" = false;
      "editor.lineNumbers" = "on";
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "all";

      "telemetry.telemetryLevel" = "off";

      "terminal.integrated.fontFamily" = "CaskaydiaMono Nerd Font";
      "terminal.integrated.fontSize" = 16;

      "github.copilot.enable" = { "*" = false; };

      "files.associations" = {
        "**/roles/**/tasks/*.yml" = "ansible";
        "**/roles/**/vars/*.yml" = "ansible";
        "**/roles/**/defaults/*.yml" = "ansible";
        "**/playbooks/**/*.yml" = "ansible";
      };

      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.iconTheme" = "catppuccin-mocha";
    };
    extensions = with pkgs.vscode-extensions;
      [
        golang.go
        ms-python.python
        ms-python.pylint
        ms-python.black-formatter
        ms-vscode.makefile-tools
        ms-vscode-remote.remote-containers
        ms-azuretools.vscode-docker
        ms-kubernetes-tools.vscode-kubernetes-tools
        redhat.vscode-yaml
        redhat.ansible
        esbenp.prettier-vscode
        jnoortheen.nix-ide
        bmewburn.vscode-intelephense-client
        tim-koehler.helm-intellisense
        hashicorp.terraform
        coolbear.systemd-unit-file
        eamodio.gitlens
        foxundermoon.shell-format
        rust-lang.rust-analyzer
        editorconfig.editorconfig
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "latte";
          publisher = "kasik96";
          version = "0.18.0";
          sha256 = "sha256-gxnjUUtkeTlbASCoBMbyGuVEtTvp027Gx5+ngHwEms0=";
        }
        {
          name = "vscode-laravel";
          publisher = "laravel";
          version = "1.0.7";
          sha256 = "sha256-HPvuEYCk59tPUCTKqX5tOWuhXhsHim4+fOrZoreRB8Q=";
        }
      ];
  };
}
