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

      source <(kubectl completion zsh)
      compdef k=kubectl

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
      k = "kubectl";
      tldrf = ''
        tldr --list 2> /dev/null | sort | fzf --preview "tldr {1} --color=always" --preview-window=right,70% | xargs tldr'';
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
      continuation_prompt = "[.](bright-black) ";
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

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[x](bold red)";
        vimcmd_symbol = "[<](bold green)";
        vimcmd_visual_symbol = "[<](bold yellow)";
        vimcmd_replace_symbol = "[<](bold purple)";
        vimcmd_replace_one_symbol = "[<](bold purple)";
      };

      git_commit.tag_symbol = " tag ";

      git_status = {
        ahead = ">";
        behind = "<";
        diverged = "<>";
        renamed = "r";
        deleted = "x";
      };

      git_branch = {
        symbol = "git ";
        truncation_symbol = "...";
      };

      directory.read_only = " ro";

      aws.symbol = "aws ";
      azure.symbol = "az ";
      buf.symbol = "buf ";
      bun.symbol = "bun ";
      c.symbol = "C ";
      cmake.symbol = "cmake ";
      conda.symbol = "conda ";
      container.symbol = "container ";
      crystal.symbol = "cr ";
      dart.symbol = "dart ";
      deno.symbol = "deno ";
      docker_context.symbol = "docker ";
      dotnet = {
        format = "via [$symbol($version )(target $tfm )]($style)";
        symbol = ".NET ";
      };
      elixir.symbol = "exs ";
      elm.symbol = "elm ";
      erlang.symbol = "erl ";
      golang.symbol = "go ";
      gradle.symbol = "gradle ";
      haskell.symbol = "haskell ";
      helm.symbol = "helm ";
      java.symbol = "java ";
      jobs.symbol = "*";
      julia.symbol = "jl ";
      kotlin.symbol = "kt ";
      kubernetes = {
        disabled = false;
        symbol = "kubernetes ";
      };
      lua.symbol = "lua ";
      memory_usage.symbol = "memory ";
      nim.symbol = "nim ";
      nix_shell.symbol = "nix ";
      nodejs.symbol = "nodejs ";
      ocaml.symbol = "ml ";
      package.symbol = "pkg ";
      perl.symbol = "pl ";
      php.symbol = "php ";
      python.symbol = "py ";
      ruby.symbol = "rb ";
      rust.symbol = "rs ";
      scala.symbol = "scala ";
      sudo.symbol = "sudo ";
      swift.symbol = "swift ";
      terraform.symbol = "terraform ";
      vagrant.symbol = "vagrant ";
      zig.symbol = "zig ";

      battery = {
        full_symbol = "full ";
        charging_symbol = "charging ";
        discharging_symbol = "discharging ";
        unknown_symbol = "unknown ";
        empty_symbol = "empty ";
      };

      status = {
        symbol = "[x](bold red) ";
        not_executable_symbol = "noexec";
        not_found_symbol = "notfound";
        sigint_symbol = "sigint";
        signal_symbol = "sig";
      };

      hostname.ssh_symbol = "ssh ";
    };
  };
}
