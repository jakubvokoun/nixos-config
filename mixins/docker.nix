{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "jakub" ];
}
