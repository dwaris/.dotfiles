{
  description = "Dwaris NixOS Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    username = "dwaris";
    specialArgs = {inherit inputs username;};
  in {
    nixosConfigurations = {
      jedha = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/jedha/configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
      };

      aldhani = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/aldhani/configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
      };

      kashyyyk = inputs.nixpkgs-stable.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/kashyyyk/configuration.nix
        ];
      };

      batuu = inputs.nixpkgs-stable.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/batuu/configuration.nix
        ];
      };
    };
  };
}
