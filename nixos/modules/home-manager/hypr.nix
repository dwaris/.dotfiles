{ inputs
, config
, pkgs
, ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      monitor=,preferred,auto,1
      monitor=DP-1, 2560x1440@144, 1920x0, 1, bitdepth,10, vrr, 2
      monitor=HDMI-A-1, 1920x1080@75, 0x0, 1

      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = XCURSOR_SIZE,24
      env = QT_QPA_PLATFORM,wayland
      env = XDG_SCREENSHOTS_DIR,~/screens

      input {
          kb_layout = eu
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1
          accel_profile = flat

          touchpad {
              natural_scroll = false
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5
          gaps_out = 10
          border_size = 2
          col.active_border = 0xffcba6f7
          col.inactive_border = 0xff313244
          no_border_on_floating = true
          layout = dwindle
      }

      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 5
          active_opacity = 1.0
          inactive_opacity = 1.0
          blur {
              enabled = yes
              size = 10
              passes = 1
              new_optimizations = on
          }
          drop_shadow = yes
          shadow_ignore_window = true
          shadow_range = 4
          shadow_offset = 2 2 
          shadow_render_power = 2
          col.shadow= 0x66000000
      }

      animations {
          enabled = true

          # Some default animations, see https://wiki.hyprland.org/Configuring>

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # you probably want this
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = true
          workspace_swipe_fingers = 3
          workspace_swipe_invert = false
          workspace_swipe_distance = 200
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more

      misc {
          animate_manual_resizes = true
          animate_mouse_windowdragging = true
          enable_swallow = true
          render_ahead_of_time = false
          disable_hyprland_logo = true

      }

      # Example windowrule v1
      windowrule = float, ^(imv)$
      windowrule = float, ^(mpv)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER

      exec-once = ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1

      exec-once = swww init
      # exec-once = nm-applet --indicator & waybar & dunst

      exec-once = waybar & dunst

      exec-once = wl-paste --type text --watch cliphist store 
      exec-once = wl-paste --type image --watch cliphist store
      bind = $mainMod, C, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, Return, exec, alacritty
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, nautilus
      bind = $mainMod, F, fullscreen, 1
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, D, exec, wofi --show drun
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      bind = $mainMod, left,  movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up,    movefocus, u
      bind = $mainMod, down,  movefocus, d

      # Moving windows
      bind = $mainMod SHIFT, left,  swapwindow, l
      bind = $mainMod SHIFT, right, swapwindow, r
      bind = $mainMod SHIFT, up,    swapwindow, u
      bind = $mainMod SHIFT, down,  swapwindow, d

      # Window resizing                           X  Y
      bind = $mainMod CTRL, left,  resizeactive, -60 0
      bind = $mainMod CTRL, right, resizeactive,  60 0
      bind = $mainMod CTRL, up,    resizeactive,  0 -60
      bind = $mainMod CTRL, down,  resizeactive,  0  60

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Keyboard backlight
      bind = SUPER, F3, exec, brightnessctl -d *::kbd_backlight set +33%
      bind = SUPER, F2, exec, brightnessctl -d *::kbd_backlight set 33%-

      # Volume and Media Control
      bind = , XF86AudioRaiseVolume, exec, pamixer -i 5 
      bind = , XF86AudioLowerVolume, exec, pamixer -d 5 
      bind = , XF86AudioMute, exec, pamixer -t
      bind = , XF86AudioMicMute, exec, pamixer --default-source -m

      # Configuration files
      bind = , Print, exec, grimblast copysave area

      # Waybar
      bind = $mainMod, B, exec, pkill -SIGUSR1 waybar
      bind = $mainMod, W, exec, pkill -SIGUSR2 waybar
    '';
  };
}

