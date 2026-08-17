{
  lib,
  ...
}: {
  specialisation = {
    omarchy = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./omarchy.nix
        ];
        boot.lanzaboote.sortKey = "01";
        services.displayManager.plasma-login-manager.enable = lib.mkForce false;
        services.displayManager.ly.enable = lib.mkForce false;
        system.nixos.tags = ["omarchy"];
      };
    };

    hyprland = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./hyprland.nix
        ];
        boot.lanzaboote.sortKey = "02";
        services.displayManager.plasma-login-manager.enable = lib.mkForce false;
        services.displayManager.sddm.enable = lib.mkForce false;
        system.nixos.tags = ["hyprland"];
      };
    };

    kde = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./kde.nix
        ];
        boot.lanzaboote.sortKey = "03";
        services.displayManager.ly.enable = lib.mkForce false;
        services.displayManager.sddm.enable = lib.mkForce false;
        system.nixos.tags = ["kde"];
      };
    };
  };
}
