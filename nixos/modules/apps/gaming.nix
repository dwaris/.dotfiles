{pkgs, ...}: {
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    heroic
    # prismlauncher
    # mesen
  ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };
}
