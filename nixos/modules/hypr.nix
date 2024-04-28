{ config, pkgs, ... }: {
    # Enable the XWayland Fallback windowing system.
    programs.xwayland.enable = true;
  
    #environment.sessionVariables = {
    #    NIXOS_OZONE_WL = "1";
    #    WLR_NO_HARDWARE_CURSORS = "1";
    #};

    services.xserver = {
        displayManager = {
            gdm = {
                enable = true;
                wayland = true;
            };
        };
    };

    environment.systemPackages = with pkgs; [
        wofi
        dunst
        waybar

        swww # for wallpapers

        networkmanagerapplet

        wl-clipboard

        nerdfonts
    ];

    programs.hyprland = {
        # Install the packages from nixpkgs
        enable = true;
        # Whether to enable XWayland
        xwayland.enable = true;
    };

    # Configure keymap in and Dispay Manager
    services.xserver = {
        xkb = {
            layout = "eu";
            };
        enable = true;
    };

    services.dbus.enable = true;
    xdg.portal = {
        enable = true;
        wlr.enable = true;
    };

    security.polkit.enable = true;

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
