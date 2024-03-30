{ config, lib, pkgs, ...}: {
    hardware.opentabletdriver.enable = true;
    hardware.opentabletdriver.daemon.enable = true;
    hardware.opentabletdriver.blacklistedKernelModules = [ "wacom" ];
}
