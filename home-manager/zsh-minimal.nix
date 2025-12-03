{ inputs, lib, config, pkgs, ... }: {
  home.packages = [ pkgs.bat-extras.batman ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    initContent = ''
        autoload -Uz +X compinit && compinit
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' menu select

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

      # Git prompt function
      git_prompt() {
        local branch
        local status_symbols=""
        local color="%F{green}"
        
        # Check if we're in a git repo
        if git rev-parse --git-dir > /dev/null 2>&1; then
          # Get branch name
          branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
          
          # Check for changes
          if ! git diff --quiet 2>/dev/null; then
            status_symbols="''${status_symbols}*"
            color="%F{yellow}"
          fi
          
          # Check for staged changes
          if ! git diff --cached --quiet 2>/dev/null; then
            status_symbols="''${status_symbols}+"
            color="%F{yellow}"
          fi
          
          # Check for untracked files
          if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
            status_symbols="''${status_symbols}?"
            color="%F{yellow}"
          fi
          
          echo " ''${color}[''${branch}''${status_symbols}]%f"
        fi
      }

      # Python virtualenv prompt
      venv_prompt() {
        if [ -n "$VIRTUAL_ENV" ]; then
          echo " ($(basename $VIRTUAL_ENV))"
        fi
      }

      # AWS profile prompt
      aws_prompt() {
        if [ -n "$AWS_VAULT" ]; then
          echo " [aws:''${AWS_VAULT}]"
        elif [ -n "$AWS_PROFILE" ]; then
          echo " [aws:''${AWS_PROFILE}]"
        fi
      }

      # Nix shell prompt
      nix_prompt() {
        if [ -n "$IN_NIX_SHELL" ]; then
          if [ -n "$name" ]; then
            echo " [nix:''${name}]"
          else
            echo " [nix-shell]"
          fi
        fi
      }

      # Enable prompt substitution
      setopt PROMPT_SUBST

      # Build the prompt
      PROMPT='%F{blue}%3~%f$(git_prompt)%F{green}$(venv_prompt)%f%F{cyan}$(aws_prompt)%f%F{magenta}$(nix_prompt)%f
      %(?..%F{red}%? %f)%F{green}❯%f '
    '';

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_INSECURE = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      TERM = "xterm-256color";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "24";
      AWS_VAULT_PROMPT = "terminal";
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
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

}
