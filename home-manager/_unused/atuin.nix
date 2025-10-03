{ inputs, lib, config, pkgs, ... }: {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
}
