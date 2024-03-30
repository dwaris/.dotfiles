{ config, pkgs, ... }: {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        gnomeExtensions.appindicator
        wl-clipboard
    ];
    # Enable the XWayland Fallback windowing system.
    programs.xwayland.enable = true;

    services.xserver = {
        displayManager = {
            gdm = {
                enable = true;
                wayland = true;
            };
        };

        desktopManager.gnome.enable = true;
    };

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

    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}
