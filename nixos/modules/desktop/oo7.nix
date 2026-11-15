{pkgs, ...}: {
  services.gnome.gnome-keyring.enable = false;

  services.oo7.enable = true;
  environment.systemPackages = with pkgs; [
    libsecret
  ];
}
