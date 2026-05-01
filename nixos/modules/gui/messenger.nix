{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    discord
    element-desktop

    thunderbird
  ];

  # services.protonmail-bridge.enable = true;
  # services.protonmail-bridge.path = [ pkgs.gnome-keyring ];
}
