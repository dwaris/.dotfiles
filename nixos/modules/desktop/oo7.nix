{
  config,
  pkgs,
  lib,
  ...
}: {
  services.gnome.gnome-keyring.enable = false;


  security.pam.services = let
    waitForPamSocket = pkgs.writeShellScript "oo7-wait-for-pam-socket" ''
      uid=$(id -u "$PAM_USER")
      sock="/run/user/$uid/oo7-pam.sock"
      for _ in $(seq 1 20); do
        [ -S "$sock" ] && exit 0
        sleep 0.1
      done
      exit 0
    '';
  in
    lib.genAttrs ["login"] (svc: {
      oo7.enable = true;
      rules.session.oo7-wait = {
        control = "optional";
        order = config.security.pam.services.${svc}.rules.session.oo7.order - 50;
        modulePath = "${pkgs.pam}/lib/security/pam_exec.so";
        args = ["quiet" "${waitForPamSocket}"];
      };
    });

  services.oo7.enable = true;
}
