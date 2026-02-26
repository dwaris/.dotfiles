{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    element-desktop

    thunderbird
  ];

  # services.protonmail-bridge.enable = true;
  # services.protonmail-bridge.path = [ pkgs.gnome-keyring ];
}
