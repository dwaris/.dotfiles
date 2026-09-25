{
  pkgs,
  lib,
  ...
}: {
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--write-kubeconfig-mode 644";
  };

  # Do not auto-start at boot; run on-demand with `sudo systemctl start k3s`
  systemd.services.k3s.wantedBy = lib.mkForce [];

  networking.firewall.allowedTCPPorts = [
    6443 # k3s API server
  ];

  environment.systemPackages = with pkgs; [
    kubectl
    k9s
    kubernetes-helm
    k3d
  ];
}
