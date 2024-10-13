{ inputs, lib, config, pkgs, ... }: {
  home.packages = [ pkgs.powerline ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initExtra = ". ${pkgs.powerline}/share/zsh/powerline.zsh";
    dotDir = ".config/zsh";

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_INSECURE = "1";
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

  programs.powerline-go = {
    enable = true;
    modules = [
      "aws"
      "docker"
      "venv"
      "nix-shell"
      #"user"
      #"host"
      "ssh"
      "cwd"
      "perms"
      "git"
      "hg"
      "jobs"
      "exit"
      "root"
    ];
  };
}