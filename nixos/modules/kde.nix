{ config, pkgs, lib, ... }: {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        kile
        
        pciutils
        clinfo
        glxinfo
        vulkan-tools
        wayland-utils
        aha
        wl-clipboard
        xwaylandvideobridge
        kdePackages.sddm-kcm
        (catppuccin-kde.override {
            flavour = [ "mocha" ];
            accents = [ "rosewater" ];
            winDecStyles = [ "classic" ];
        })
    ];
    # Configure keymap in and Dispay Manager
    services = {
        xserver = {
            enable = true;
            xkb.layout = "eu";
        };
        desktopManager.plasma6.enable = true;
        displayManager.sddm = {
            enable = true;
            wayland.enable = true;
            autoNumlock = true;
        };
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        konsole
        oxygen
        elisa
    ];

    security.pam.services.kwallet = {
        name = "kwallet";
        enableKwallet = true;
    };

    programs.ssh.enableAskPassword = true;
    programs.ssh.askPassword = (lib.getExe pkgs.kdePackages.ksshaskpass);
    environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    };

    programs.partition-manager.enable = true;
    
    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    programs.dconf.enable = true;
}
