{ inputs, lib, config, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs; [{
      plugin = tmuxPlugins.catppuccin;
      extraConfig = ''
        set -g @catppuccin_flavour 'mocha'
      '';
    }];
    extraConfig = ''
      set -g mouse on
    '';
  };
}
