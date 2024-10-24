{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.flatpak.packages = [
    "com.valvesoftware.Steam"
  ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

}
