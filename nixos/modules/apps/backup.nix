{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nextcloud-client

    vorta

    localsend
  ];
}
