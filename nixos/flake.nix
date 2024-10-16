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

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/nixos-wsl";

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      lanzaboote,
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
          ];
        };

        kashyyyk = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/kashyyyk/configuration.nix
            lanzaboote.nixosModules.lanzaboote
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
