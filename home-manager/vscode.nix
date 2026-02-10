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

        "workbench.colorTheme" = "Tokyo Night";

        "claudeCode.useTerminal" = true;
        "claudeCode.claudeProcessWrapper" =
          "${config.home.homeDirectory}/.nix-profile/bin/claude";

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
          # Themes
          enkia.tokyo-night
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
            version = "1.3.1";
            sha256 = "sha256-2k+9xjIa4ikJ8qXn7BvB3w6yzrbDSISqT4UMyA8geFQ=";
          }
          {
            name = "vscode-blade-formatter";
            publisher = "shufo";
            version = "0.26.2";
            sha256 = "sha256-p0SedhmABPSXKXO4nZ6YU2y/IIGxwzgtfXAwA7olhz4=";
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
            version = "2.0.75";
            sha256 = "sha256-LXUIp+Rqh0prvFLgmbiSVJYHNY2ECVAfK8GLmDRMcxU=";
          }
          {
            name = "mermaid-markdown-syntax-highlighting";
            publisher = "bpruitt-goddard";
            version = "1.7.6";
            sha256 = "sha256-vBqMclDOI0LYIsFyTBKW+cZ7Hjcnl6N5Z8Qlx0ez4SQ=";
          }
        ];
    };
  };
}
