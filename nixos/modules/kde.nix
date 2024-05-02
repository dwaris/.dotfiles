{ config, pkgs, ... }: {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        wl-clipboard
    ];
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
    ];


    # Enable the XWayland Fallback windowing system.
    programs.xwayland.enable = true;

    # Configure keymap in and Dispay Manager
    services.xserver = {
        enable = true;
        xkb = {
            layout = "eu";
        };
        displayManager = {
            sddm = {
                enable = true;
                wayland.enable = true;
            };
            defaultSession = "plasma";
        };
        desktopManager.plasma6.enable = true;
    };

    qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
    };
    
    programs.dconf.enable = true;

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
