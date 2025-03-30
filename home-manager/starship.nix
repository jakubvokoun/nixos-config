{ inputs, lib, config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      eval "$(starship init zsh)"
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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        #"$username"
        #"$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$package"
        "$python"
        "$golang"
        "$kubernetes"
        "$aws"
        "$bun"
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
