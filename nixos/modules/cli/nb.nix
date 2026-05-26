{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nb

    pandoc
    w3m
    chafa
    glow
  ];
}
