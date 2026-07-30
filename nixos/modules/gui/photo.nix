{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    darktable
    nomacs
  ];
  programs.gphoto2.enable = true;
  users.users.${username}.extraGroups = [
    "camera"
  ];
}
