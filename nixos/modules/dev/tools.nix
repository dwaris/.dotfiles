{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Uutils (Rust replacements for GNU utilities)
    uutils-coreutils-noprefix
    uutils-findutils
    uutils-diffutils

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
