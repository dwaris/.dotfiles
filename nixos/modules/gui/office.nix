{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    rnote
    joplin-desktop
    obsidian
    xournalpp
  ];
}
