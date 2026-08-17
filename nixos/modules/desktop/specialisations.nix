{
  lib,
  ...
}: {
  specialisation = {
    hyprland = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./hyprland.nix
        ];
        boot.lanzaboote.sortKey = "01";
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
        boot.lanzaboote.sortKey = "02";
        services.displayManager.ly.enable = lib.mkForce false;
        services.displayManager.sddm.enable = lib.mkForce false;
        system.nixos.tags = ["kde"];
      };
    };
  };
}
