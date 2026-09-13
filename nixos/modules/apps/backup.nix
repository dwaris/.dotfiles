{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nextcloud-client

    pika-backup

    localsend
  ];
}
