{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Jakub Vokoun";
  };
}
