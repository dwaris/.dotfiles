{pkgs, ...}: {
  imports = [
    ./apps/steam.nix
  ];

  environment.systemPackages = with pkgs; [
    heroic
  ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };
}
