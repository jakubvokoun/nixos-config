{ inputs, lib, config, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "editor.fontFamily" = "JetBrainsMono Nerd Font";
        "editor.fontLigatures" = false;
        "editor.fontSize" = 14;
        "editor.formatOnSave" = false;
        "editor.lineNumbers" = "on";
        "editor.minimap.enabled" = false;
        "editor.renderWhitespace" = "all";

        "telemetry.telemetryLevel" = "off";

        "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
        "terminal.integrated.fontSize" = 14;

        "files.associations" = {
          "**/roles/**/tasks/*.yml" = "ansible";
          "**/roles/**/vars/*.yml" = "ansible";
          "**/roles/**/defaults/*.yml" = "ansible";
          "**/playbooks/**/*.yml" = "ansible";
          "site.yml" = "ansible";
          "**/site.yml" = "ansible";
        };

        "[templ]" = { "editor.defaultFormatter" = "a-h.templ"; };

        "[helm-template]" = {
          "yaml.validate" = false;
          "yaml.format.enable" = false;
        };

        "workbench.colorTheme" = "Default Dark+";

        "claudeCode" = {
          "preferredLocation" = "panel";
          "claudeProcessWrapper" =
            "${config.home.homeDirectory}/.nix-profile/bin/claude";
        };

        "ansible.python.interpreterPath" =
          "${config.home.homeDirectory}/.nix-profile/bin/python3";
      };
      extensions = with pkgs.vscode-extensions;
        [
          # Extensions
          golang.go
          ms-python.python
          ms-python.pylint
          ms-python.black-formatter
          ms-vscode.makefile-tools
          ms-vscode-remote.remote-containers
          ms-azuretools.vscode-docker
          ms-kubernetes-tools.vscode-kubernetes-tools
          ms-toolsai.jupyter
          redhat.vscode-yaml
          redhat.ansible
          esbenp.prettier-vscode
          jnoortheen.nix-ide
          bmewburn.vscode-intelephense-client
          tim-koehler.helm-intellisense
          hashicorp.terraform
          hashicorp.hcl
          coolbear.systemd-unit-file
          eamodio.gitlens
          foxundermoon.shell-format
          rust-lang.rust-analyzer
          editorconfig.editorconfig
          mikestead.dotenv
          matthewpi.caddyfile-support
          nefrob.vscode-just-syntax
          fill-labs.dependi
          bierner.markdown-mermaid
          yzane.markdown-pdf
          myriad-dreamin.tinymist
          arrterian.nix-env-selector
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "latte";
            publisher = "kasik96";
            version = "0.18.2";
            sha256 = "sha256-olgoG2VMqk7IupwVm02AauqqGy6jzZdbu5YZfH11zo0=";
          }
          {
            name = "vscode-laravel";
            publisher = "laravel";
            version = "1.7.0";
            sha256 = "sha256-5PVbv5hWIdsOHvYttnf2BPeqfPXsOVENrnRyiUf/Hlg=";
          }
          {
            name = "vscode-blade-formatter";
            publisher = "shufo";
            version = "0.26.3";
            sha256 = "sha256-Ccjh8dgOPW3+uM9fQ7mloMsHEs3zP3fEE9BxQxorpf8=";
          }
          {
            name = "templ";
            publisher = "a-h";
            version = "0.0.35";
            sha256 = "sha256-WIBJorljcnoPUrQCo1eyFb6vQ5lcxV0i+QJlJdzZYE0=";
          }
          {
            name = "claude-code";
            publisher = "anthropic";
            version = "2.1.123";
            sha256 = "sha256-8vJHvwYdCdQb0kHNbM6KNp27BJh8RGrBmw++Zz7nLf4=";
          }
          {
            name = "mermaid-markdown-syntax-highlighting";
            publisher = "bpruitt-goddard";
            version = "1.8.0";
            sha256 = "sha256-JATdvLubjfQ1oFXIkXrui6cSHmssgtd2o8l21DMU5B8=";
          }
        ];
    };
  };
}
