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
    userEmail = "jakub.vokoun@gmail.com";
  };
}
