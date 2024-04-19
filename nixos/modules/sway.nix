{ config, pkgs, ... }: {
    # Enable the XWayland Fallback windowing system.
    programs.xwayland.enable = true;

    services.xserver = {
        displayManager = {
            gdm = {
                enable = true;
                wayland = true;
            };
        };
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraPackages = with pkgs; [
        swaylock
        swayidle
        wl-clipboard
        wf-recorder
        mako # notification daemon
        grim
      #kanshi
        slurp
        alacritty # Alacritty is the default terminal in the config
        dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
      ];
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export MOZ_ENABLE_WAYLAND=1
      '';
    };

    programs.waybar.enable = true;

    # Configure keymap in and Dispay Manager
    services.xserver = {
        xkb = {
        layout = "eu";
        };
        enable = true;
    };

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

}
