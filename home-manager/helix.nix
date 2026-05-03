{ inputs, lib, config, pkgs, ... }: {
  xdg.configFile."helix/runtime/queries/ansible/highlights.scm".text =
    "; inherits: yaml";
  xdg.configFile."helix/runtime/queries/ansible/injections.scm".text =
    "; inherits: yaml";

  programs.helix = {
    enable = true;
    languages = {
      language = [{
        name = "ansible";
        scope = "source.yaml.ansible";
        grammar = "yaml";
        comment-token = "#";
        file-types = [
          { glob = "playbooks/*.yaml"; }
          { glob = "playbooks/*.yml"; }
          { glob = "tasks/*.yaml"; }
          { glob = "tasks/*.yml"; }
          { glob = "handlers/*.yaml"; }
          { glob = "handlers/*.yml"; }
          { glob = "roles/**/*.yaml"; }
          { glob = "roles/**/*.yml"; }
          { glob = "group_vars/**/*.yaml"; }
          { glob = "group_vars/**/*.yml"; }
          { glob = "host_vars/**/*.yaml"; }
          { glob = "host_vars/**/*.yml"; }
          { glob = "defaults/*.yaml"; }
          { glob = "defaults/*.yml"; }
          { glob = "vars/*.yaml"; }
          { glob = "vars/*.yml"; }
          { glob = "meta/main.yaml"; }
          { glob = "meta/main.yml"; }
          { glob = "site.yaml"; }
          { glob = "site.yml"; }
        ];
        language-servers = [ "ansible-language-server" ];
      }];
    };
    settings = {
      theme = "tokyonight";
      editor = {
        soft-wrap = { enable = true; };
        whitespace = {
          render = {
            space = "all";
            tab = "all";
            nbsp = "none";
            nnbsp = "none";
            newline = "none";
          };
        };
      };
    };
    extraPackages = [
      pkgs.gopls
      pkgs.marksman
      pkgs.bash-language-server
      pkgs.yaml-language-server
      pkgs.terraform-ls
      pkgs.nixd
      (pkgs.callPackage
        "${config.home.homeDirectory}/.config/home-manager/packages/ansible-language-server"
        { })
    ];
  };
}
