{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bat
    delta
    dust
    eza
    ouch
    procs
    sd
    sequoia-sq
    trippy
  ];
}
