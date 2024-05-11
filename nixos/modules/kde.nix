{ config, pkgs, ... }: {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        wl-clipboard
        kdePackages.ksshaskpass
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
        };
    };

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
        plasma-browser-integration
        konsole
        oxygen
    ];

    security.pam.services.kwallet = {
        name = "kwallet";
        enableKwallet = true;
    };

    programs = {
        ssh.startAgent = true;
        ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
    };
    
    environment.sessionVariables = {
        
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

    programs.dconf.enable = true;
}
