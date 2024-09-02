{ config, lib, pkgs, ... }:

{
    programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
               * {
                 font-family: "SauceCodePro";
                 font-size: 12pt;
                 font-weight: bold;
                 border-radius: 8px;
                 transition-property: background-color;
                 transition-duration: 0.5s;
               }
               @keyframes blink_red {
                 to {
                   background-color: rgb(242, 143, 173);
                   color: rgb(26, 24, 38);
                 }
               }
               .warning, .critical, .urgent {
                 animation-name: blink_red;
                 animation-duration: 1s;
                 animation-timing-function: linear;
                 animation-iteration-count: infinite;
                 animation-direction: alternate;
               }
               window#waybar {
                 background-color: transparent;
               }
               window > box {
                 margin-left: 5px;
                 margin-right: 5px;
                 margin-top: 5px;
                 background-color: #1e1e2a;
                 padding: 3px;
                 padding-left:8px;
                 border: 2px none #33ccff;
               }
         #workspaces {
                 padding-left: 0px;
                 padding-right: 4px;
               }
         #workspaces button {
                 padding-top: 5px;
                 padding-bottom: 5px;
                 padding-left: 6px;
                 padding-right: 6px;
               }
         #workspaces button.active {
                 background-color: rgb(181, 232, 224);
                 color: rgb(26, 24, 38);
               }
         #workspaces button.urgent {
                 color: rgb(26, 24, 38);
               }
         #workspaces button:hover {
                 background-color: rgb(248, 189, 150);
                 color: rgb(26, 24, 38);
               }
               tooltip {
                 background: rgb(48, 45, 65);
               }
               tooltip label {
                 color: rgb(217, 224, 238);
               }
         #mode, #clock, #memory, #temperature, #cpu, #backlight, #pulseaudio, #network, #battery, #custom-powermenu {
                 padding-left: 10px;
                 padding-right: 10px;
               }
               /* #mode { */
               /* 	margin-left: 10px; */
               /* 	background-color: rgb(248, 189, 150); */
               /*     color: rgb(26, 24, 38); */
               /* } */
         #memory {
                 color: rgb(181, 232, 224);
               }
         #cpu {
                 color: rgb(245, 194, 231);
               }
         #clock {
                 color: rgb(217, 224, 238);
               }
         #temperature {
                 color: rgb(150, 205, 251);
               }
         #backlight {
                 color: rgb(248, 189, 150);
               }
         #pulseaudio {
                 color: rgb(245, 224, 220);
               }
         #network {
                 color: #ABE9B3;
               }
         #network.disconnected {
                 color: rgb(255, 255, 255);
               }
         #tray {
                 padding-right: 8px;
                 padding-left: 10px;
               }
         #custom-launcher {
                 font-size: 20px;
                 padding-left: 8px;
                 padding-right: 6px;
                 color: #7ebae4;
               }
      '';
      settings = [{
        "layer" = "top";
        "position" = "top";
        modules-left = [
          "custom/launcher"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio#sink"
          "pulseaudio#source"
          "temperature"
          "cpu"
          "memory"
          "network"
          "tray"
        ];
        "hyprland/workspaces" = {
          "format" = "{name}: {icon}";
          "format-icons" = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "active" = "";
            "default" = "";
          };
          "persistent-workspaces" = {
            "*" = 5;
          };
        };
        "custom/launcher" = {
          "format" = " ";
          "on-click" = "pkill rofi || rofi -show drun";
          "tooltip" = false;
        };
        "pulseaudio#sink" = {
          "format" = "{volume}% {icon}";
          "format-muted" = "🔇";
          "format-bluetooth" = "{volume}% {icon}  {format_source}";
          "format-icons" = {
              "headphones" = [" " " " " "];
              "handsfree" = "";
              "headset" =  [" " " " " "];
              "phone" = [" " " " " "];
              "portable" = [" " " " " "];
              "car" = [" " " " " "];
              "default" = ["" "" ""];
          };
          "on-click" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "on-click-right" = "/usr/bin/pavucontrol";
          "on-scroll-down" = "pactl set-sink-volume @DEFAULT_SINK@ -1%";
          "on-scroll-up" = "pactl set-sink-volume @DEFAULT_SINK@ +1%";
        };
        "pulseaudio#source" = {
          "format" = "{format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "on-click" = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "on-click-right" = "/usr/bin/pavucontrol";
          "on-scroll-down" = "pactl set-source-volume @DEFAULT_SOURCE@ -1%";
          "on-scroll-up" = "pactl set-source-volume @DEFAULT_SOURCE@ +1%";
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%H:%M  %A %b %d}";
          "tooltip" = false;

        };
        "memory" = {
          "interval" = 1;
          "format" = "󰻠 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = "󰍛 {usage}%";
        };
        "network" = {
          "format-disconnected" = "󰯡";
          "format-ethernet" = "󰒢";
          "format-linked" = "󰖪 {essid} (No IP)";
          "format-wifi" = "󰖩 {essid}";
          "interval" = 1;
          "tooltip" = false;
        };
        "temperature" = {
        # "thermal-zone": 2;
        "hwmon-path" = "/sys/class/hwmon/hwmon3/temp1_input";
        "critical-threshold" = 95;
        # "format-critical"= "{temperatureC}°C {icon}",
        "format" = "{temperatureC}°C {icon}";
        "format-icons" = ["" "" ""];
        };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };
      }];
    };
}