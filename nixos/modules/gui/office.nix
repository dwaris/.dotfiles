{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    rnote
    obsidian
    xournalpp
  ];
}
