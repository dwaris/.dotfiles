{ pkgs, lib, ... }: {
  services.gnome.gnome-keyring.enable = false;

  # Enable pam_oo7.so and disable legacy keyrings across all display managers & login
  security.pam.services = let
    oo7PamConfig = {
      enableGnomeKeyring = false;
      enableKwallet = false;
      rules.auth.oo7 = {
        control = "optional";
        order = 11000;
        modulePath = "${pkgs.oo7-pam}/lib/security/pam_oo7.so";
      };
      rules.session.oo7 = {
        control = "optional";
        order = 11000;
        modulePath = "${pkgs.oo7-pam}/lib/security/pam_oo7.so";
      };
    };
  in
    lib.genAttrs [ "gdm" "plasma-login-manager" "login" ] (_: oo7PamConfig);

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

  systemd.user.services.oo7-daemon = {
    description = "Secret service (oo7 implementation)";
    wantedBy = [ "graphical-session-pre.target" "graphical-session.target" ];
    before = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = [
        ""
        "/run/wrappers/bin/oo7-daemon"
      ];
      PrivateUsers = false;
      NoNewPrivileges = false;
      Restart = "on-failure";
      BusName = "org.freedesktop.secrets";
    };
  };

  systemd.user.services.oo7-portal = {
    description = "Secret portal service (oo7 implementation)";
    wantedBy = [ "graphical-session-pre.target" "graphical-session.target" ];
    before = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "dbus";
      BusName = "org.freedesktop.impl.portal.desktop.oo7";
      ExecStart = "${pkgs.oo7-portal}/libexec/oo7-portal";
      Restart = "on-failure";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      oo7-portal
    ];
    config.common."org.freedesktop.impl.portal.Secret" = "oo7";
  };
}
