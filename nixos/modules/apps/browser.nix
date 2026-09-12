{pkgs, ...}: let
  brave-pkg =
    if pkgs ? brave-origin
    then pkgs.brave-origin
    else pkgs.brave;
in {
  environment.systemPackages = with pkgs; [
    (brave-pkg.override {
      enableVideoAcceleration = true;
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
      commandLineArgs = [
        "--password-store=gnome-libsecret"
      ];
    })
    firefox
    tor-browser
  ];
}
