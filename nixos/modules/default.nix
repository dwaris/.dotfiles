{ config, pkgs, lib, ... }:

{
  imports = [
    ./system.nix
    ./boot.nix
  ];

  specialisation = {
    gnome = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./desktop.nix
          ./gnome.nix
        ];
        boot.lanzaboote.sortKey = "02";
        system.nixos.tags = [ "gnome" ];
      };
    };
    kde = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./desktop.nix
          ./kde.nix
        ];

        boot.lanzaboote.sortKey = "03";
        system.nixos.tags = [ "kde" ];

        # keep kwallet in kde module but disable it here to avoid conflicts between different desktop environments; gnome-keyring is preferred
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.login.kwallet.enable = lib.mkForce false;
        security.pam.services.kde.kwallet.enable = lib.mkForce false;
        programs.ssh.startAgent = lib.mkForce false;
        environment.sessionVariables.SSH_ASKPASS_REQUIRE = lib.mkForce "";
      };
    };
    hyprland = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          ./desktop.nix
          ./hyprland.nix
        ];
        boot.lanzaboote.sortKey = "01";
        system.nixos.tags = [ "hyprland" ];
      };
    };
  };
}
