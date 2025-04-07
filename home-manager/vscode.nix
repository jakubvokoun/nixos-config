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

      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;

      "terminal.integrated.fontFamily" = "CaskaydiaMono Nerd Font";
      "terminal.integrated.fontSize" = 16;

      "github.copilot.enable" = { "*" = false; };

      "workbench.fontAliasing" = "antialiased";
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
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [ ];
  };
}
