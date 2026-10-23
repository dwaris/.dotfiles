{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    vesktop
    element-desktop
    thunderbird
  ];
}
