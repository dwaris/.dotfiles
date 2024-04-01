{  pkgs, lib,  config, ...}:
let
  cfg = config.programs.makemkv;
in
{
  options = {
    programs.makemkv.enable = lib.mkEnableOption "MakeMKV";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.dwaris = {
      home.packages = with pkgs; [
        makemkv
      ];
    };
    boot.kernelModules = [ "sg" ];
  };
}
