{ inputs, lib, config, pkgs, ... }: {
  services.wlsunset = {
    enable = true;
    # Prague
    latitude = "50.073658";
    longitude = "14.418540";
    temperature = {
      day = 5800;
      night = 3500;
    };
    gamma = "0.8";
  };
}
