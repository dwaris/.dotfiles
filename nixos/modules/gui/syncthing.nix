{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    syncthingtray
  ];

  services.syncthing = {
    enable = false;
    openDefaultPorts = false;
    user = username;
    group = "users";
    dataDir = "/home/${username}"; # default location for new folders
    configDir = "/home/${username}/.config/syncthing";
  };

}
