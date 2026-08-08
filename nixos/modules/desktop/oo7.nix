{ pkgs, ... }: {
  services.gnome.gnome-keyring.enable = false;
  security.pam.services.sddm.enableGnomeKeyring = false;
  security.pam.services.login.enableGnomeKeyring = false;

  security.pam.services.sddm.enableKwallet = false;
  security.pam.services.login.enableKwallet = false;

  environment.systemPackages = with pkgs; [
    oo7-server
    oo7-portal
    oo7-pam
    gcr
    libsecret
  ];

  security.wrappers.oo7-daemon = {
    owner = "root";
    group = "root";
    capabilities = "cap_ipc_lock=+ep";
    source = "${pkgs.oo7-server}/libexec/oo7-daemon";
  };

  services.dbus.packages = with pkgs; [
    oo7-server
    oo7-portal
    gcr
  ];

  systemd.user.services.oo7-daemon.serviceConfig = {
    ExecStart = [
      ""
      "/run/wrappers/bin/oo7-daemon"
    ];
    PrivateUsers = false;
    NoNewPrivileges = false;
  };

  systemd.user.services.oo7-portal.serviceConfig = {
    ExecStart = "${pkgs.oo7-portal}/libexec/oo7-portal";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      oo7-portal
    ];
    config.common."org.freedesktop.impl.portal.Secret" = "oo7";
  };
}
