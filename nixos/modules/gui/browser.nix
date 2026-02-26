{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    firefox
    chromium

    (nur.repos.Ev357.helium.override {enableWideVine = true;})
  ];
}
