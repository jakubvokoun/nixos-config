{ inputs, lib, config, pkgs, ... }: {
  home.packages = [ pkgs.bat-extras.batman ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    initContent = ''
      autoload -Uz +X compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' menu select

      eval "$(starship init zsh)"
      eval "$(batman --export-env)"

      # Function to update package versions in Ansible YAML files
      update-ansible-pkg-version() {
        if [[ $# -ne 2 ]]; then
          echo "Usage: update-ansible-pkg-version <package-name> <new-version>"
          return 1
        fi
        
        local package_name="$1"
        local new_version="$2"
        
        # Find files containing the package name and update them
        grep -r -l "^[[:space:]]*-[[:space:]]*$package_name=" . --include="*.yml" --include="*.yaml" 2>/dev/null | \
        xargs -r sed -i "s/^\\([[:space:]]*-[[:space:]]*$package_name=\\).*$/\\1$new_version/"
      }
    '';

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_INSECURE = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      NIX_SKIP_KEYBASE_CHECKS = "1";
      TERM = "xterm-256color";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
    };

    shellAliases = {
      e = "nvim";
      update-nixos = "sudo nix-channel --update && sudo nixos-rebuild switch";
      update-home = "sudo nix-channel --update && home-manager switch";
      gc-nixos = "sudo nix-collect-garbage --delete-older-than 15d";
      gc-home = "home-manager expire-generations '-15 days'";
      git-wt-switch = "cd $(git worktree list | fzf | awk '{ print $1 }')";
      git-branch-switch =
        "git checkout $(git branch | fzf | sed 's/[*+]//' | awk '{ print $1 }')";
      tldrf = ''
        tldr --list | sort | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'';
    };

    plugins = [{
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.8.0";
        sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      };
    }];

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$git_metrics"
        "$package"
        "$python"
        "$golang"
        "$rust"
        "$kubernetes"
        "$aws"
        "$bun"
        "$nodejs"
        "$docker_context"
        "$helm"
        "$php"
        "$terraform"
        "$vagrant"
        "$nix_shell"
        "$line_break"
        "$jobs"
        "$character"
      ];
      kubernetes.disabled = false;
    };
  };
}
