{ inputs, lib, config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    initExtra = ''
      # Nix shell
      if [[ -n "$IN_NIX_SHELL" ]]; then
        label="nix-shell"
        if [[ "$name" != "$label" ]]; then
          label="$label:$name"
        fi
        export PS1=$'%{$fg[green]%}'"$label $PS1"
        unset label
      fi
    '';

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_INSECURE = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      TERM = "xterm-256color";
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

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "aws"
        "bun"
        "composer"
        "docker"
        "docker-compose"
        "fzf"
        "git"
        "golang"
        "helm"
        "history"
        "kind"
        "kubectl"
        "kubectx"
        "laravel"
        "minikube"
        "pip"
        "poetry"
        "pre-commit"
        "python"
        "rust"
        "shrink-path"
        "ssh"
        "sudo"
        "terraform"
        "vagrant"
      ];
    };

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";
  };
}
