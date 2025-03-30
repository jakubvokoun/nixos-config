{ inputs, lib, config, pkgs, ... }: {
  /* systemd.user.services.onex-sitemap = {
       Unit = { Description = "ONEX sitemaps"; };

       Service = {
         Type = "oneshot";
         WorkingDirectory = "/home/jakub/Work/imao/onex-sitemap-testing";
         ExecStart = "/home/jakub/Work/imao/onex-sitemap-testing/onex-sitemap-testing -run-processor";
       };
     };

     systemd.user.timers.onex-sitemap = {
       Unit = { Description = "ONEX sitemap"; };

       Timer = {
         OnCalendar = "*-*-* *:00:00";
         Unit = "onex-sitemap.service";
       };

       Install = { WantedBy = [ "timers.target" ]; };
     };
  */

  systemd.user.services.zettelkasten = {
    Unit = { Description = "Zettelkasten auto commit"; };

    Service = {
      Type = "oneshot";
      WorkingDirectory = "/home/jakub/Repos/zettelkasten";
      ExecStart = "/home/jakub/Repos/zettelkasten/commit.sh";
    };
  };

  systemd.user.timers.zettelkasten = {
    Unit = { Description = "Zettelkasten auto commit"; };

    Timer = {
      OnCalendar = "*-*-* *:00:00";
      Unit = "zettelkasten.service";
    };

    Install = { WantedBy = [ "timers.target" ]; };
  };
}
