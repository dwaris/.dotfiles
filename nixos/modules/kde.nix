{ config, pkgs, lib, ... }: {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        pciutils
        clinfo
        glxinfo
        vulkan-tools
        wayland-utils
        aha
        wl-clipboard
        kdePackages.ksshaskpass
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
    ];

    security.pam.services.kwallet = {
        name = "kwallet";
        enableKwallet = true;
    };
/* 
    programs.ssh = {
        enableAskPassword = true;
        askPassword = (lib.getExe pkgs.kdePackages.ksshaskpass);
    };
    environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";
 */
    programs.ssh.startAgent = true;
    programs.ssh.askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

    systemd.user.services.ssh-add-my-keys = {
        script = ''
        # adding ssh key using KDE, adapted from https://wiki.archlinux.org/title/KDE_Wallet
        ${pkgs.openssh}/bin/ssh-add -q < /dev/null
        '';
        unitConfig.ConditionUser = "!@system"; # same as ssh-agent
        serviceConfig.Restart = "on-failure"; # in case ssh-agent or kwallet need more time to setup

        wantedBy = [ "default.target" ];
        # assumes that plasma systemd support is activated, see https://blog.davidedmundson.co.uk/blog/plasma-and-the-systemd-startup/
        requires = [ "ssh-agent.service" "app-pam_kwallet_init-autostart.service" ];
        after = [ "ssh-agent.service" "app-pam_kwallet_init-autostart.service" ];
    };


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
