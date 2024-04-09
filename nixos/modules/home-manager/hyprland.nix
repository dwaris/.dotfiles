{ config, pkgs, ... }: {
    {
        wayland.windowManager.hyprland.enable = true;
    }
    wayland.windowManager.hyprland.plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
    wayland.windowManager.hyprland.systemd.variables = ["--all"];
}
