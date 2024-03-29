{
  description = "Dwaris NixOS Flake";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
      nixosConfigurations = {
        jedha = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
	        modules = [
                ./hosts/jedha/configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.extraSpecialArgs = inputs;
                    home-manager.users.dwaris = import ./hosts/jedha/home.nix;
                }
            ];
        };

        kashyyyk = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
	        modules = [
                ./hosts/kashyyyk/configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.extraSpecialArgs = inputs;
                    home-manager.users.dwaris = import ./hosts/kashyyyk/home.nix;
                }
            ];
        };
      };
    };
}
