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

    programs.hyprland = {
        # Install the packages from nixpkgs
        enable = true;
        # Whether to enable XWayland
        extraPackages = with pkgs; [
            
            wl-clipboard
            wf-recorder
            alacritty # Alacritty is the default terminal in the config
            wofi
        ];
        xwayland.enable = true;
    };

    programs.waybar.enable = true;

    # Configure keymap in and Dispay Manager
    services.xserver = {
        xkb = {
        layout = "eu";
        };
        enable = true;
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
