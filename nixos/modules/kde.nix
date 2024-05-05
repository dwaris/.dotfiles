{ config, pkgs, ... }: {
    # List packages installed in system profile. To search, run:
    # $ nix search wget

    # Configure keymap in and Dispay Manager
    services = {
        xserver.enable = true;
        desktopManager.plasma6.enable = true;
        displayManager.sddm.wayland.enable = true;
    };
}
