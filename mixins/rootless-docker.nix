{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = false;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  users.users.jakub = {
    subUidRanges = [{
      startUid = 100000;
      count = 65536;
    }];
    subGidRanges = [{
      startGid = 100000;
      count = 65536;
    }];
  };

  users.users.jakub.linger = true;
}
