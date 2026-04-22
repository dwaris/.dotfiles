{
  description = "Dwaris NixOS Flake";

  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/nixos-wsl";
  };

  outputs = inputs: {
    nixosConfigurations = {
      jedha = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/jedha/configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
      };

      aldhani = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/aldhani/configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen2
        ];
      };

      kashyyyk = inputs.nixpkgs-stable.lib.nixosSystem {
        modules = [
          ./hosts/kashyyyk/configuration.nix
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x260
        ];
      };

      batuu = inputs.nixpkgs-stable.lib.nixosSystem {
        modules = [
          ./hosts/batuu/configuration.nix
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t420
        ];
      };

      wsl = inputs.nixpkgs-stable.lib.nixosSystem {
        modules = [
          ./hosts/wsl/configuration.nix
          inputs.nixos-wsl.nixosModules.wsl
        ];
      };
    };
  };
}
