{ config, pkgs, lib, ... }:

{
  environment.pathsToLink =
    [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  services.xserver.windowManager.i3.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.defaultSession = "none+i3";

  services.gnome.gnome-keyring.enable = lib.mkForce false;
}
