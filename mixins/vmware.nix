{ config, pkgs, lib, ... }:

{
  virtualisation.vmware.host.enable = true;
  users.extraGroups.vmware.members = [ "jakub" ];
  environment.systemPackages = with pkgs; [ vmware-workstation ];
}
