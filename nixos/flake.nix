{
  description = "Dwaris NixOS Flake";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-flatpak.url = "github:gmodena/nix-flatpak/";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixos-wsl.url = "github:nix-community/nixos-wsl";

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      lanzaboote,
      nix-flatpak,
      nixos-wsl,
      ...
    }:

    {
      nixosConfigurations = {
        jedha = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/jedha/configuration.nix
            lanzaboote.nixosModules.lanzaboote
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };

        corellia = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/corellia/configuration.nix
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };

        kashyyyk = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/kashyyyk/configuration.nix
            nix-flatpak.nixosModules.nix-flatpak
          ];
        };

        wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/wsl/configuration.nix
            nixos-wsl.nixosModules.wsl
          ];
        };
      };
    };
}
