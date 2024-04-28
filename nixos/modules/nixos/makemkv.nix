{ config, lib, ...}: {
    boot.kernelModules = [ "sg" ];
}
