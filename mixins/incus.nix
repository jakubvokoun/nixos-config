{ config, pkgs, lib, ... }:

{
  virtualisation.incus = {
    enable = true;
    ui = { enable = true; };
  };

  networking.nftables.enable = true;

  users.extraGroups.incus-admin.members = [ "jakub" ];
}
