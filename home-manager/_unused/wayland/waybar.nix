{ inputs, lib, config, pkgs, ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "bottom";
        position = "top";
        height = 26;
        spacing = 0;
        #output = [ "eDP-1" "HDMI-A-1" ];
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [
          "network"
          #"bluetooth"
          "pulseaudio"
          "backlight"
          "cpu"
          "memory"
          "battery"
          "tray"
        ];
        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
        };
        "sway/mode" = { format = ''<span style="italic">{}</span>''; };
        "sway/workspaces" = {
          on-click = "activate";
          sort-by-number = true;
        };
        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = [ "" "" ];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };
        "sway/window" = { max-length = 30; };
        "bluetooth" = {
          format = "{status} ";
          format-disabled = "";
          format-connected = "{num_connections} pair ";
          tooltip-format = "{controller_alias}	{controller_address}";
          tooltip-format-connected = ''
            {controller_alias}	{controller_address}

            {device_enumerate}'';
          tooltip-format-enumerate-connected =
            "{device_alias}	{device_address}";
        };
        "tray" = {
          icon-size = 13;
          spacing = 8;
        };
        "clock" = {
          interval = 60;
          tooltip = false;
          format = "{:%R | %a, %d/%m/%y}";
        };
        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
        };
        "memory" = { format = "{}% "; };
        "temperature" = {
          # thermal-zone" = 2;
          # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" "" ];
        };
        "backlight" = {
          # device = "acpi_video1";
          format = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" "" "" ];
        };
        "battery" = {
          states = {
            critical = 20;
            warning = 30;
            good = 80;
            full = 100;
          };
          interval = 2;
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% {icon} ";
          format-plugged = "{capacity}% {icon} ";
          format-alt = "{time} {icon}";
          # "format-good": ""; # An empty format will hide the module
          # "format-full": "";
          format-icons = [ "" "" "" "" "" ];
        };
        "network" = {
          # "interface" = "wlp2*"; # (Optional) To force the use of this interface
          format-wifi = "{signalStrength}% ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (no ip) ";
          format-disconnected = "off ";
          format-alt = "{ifname} = {ipaddr}/{cidr} ";
          interval = 2;
        };
        "pulseaudio" = {
          # "scroll-step" = 1; # %; can be a float
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon}  {format_source}";
          format-bluetooth-muted = " {icon}  {format_source}";
          format-muted = "{volume}%  {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "{volume}% ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
        };
      };
    };
    # TODO
    #style = '''';
  };
}
