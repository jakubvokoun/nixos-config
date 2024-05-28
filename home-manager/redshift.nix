{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  services.redshift = {
    enable = true;
    # Prague
    latitude = "50.073658";
    longitude = "14.418540";
    tray = true;
    temperature = {
      day = 5700;
      night = 3500;
    };
    settings = {
      redshift = {
        gamma = "0.8";
        brightness = "0.9";
      };
    };
  };
}
