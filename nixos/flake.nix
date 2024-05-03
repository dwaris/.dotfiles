{
    description = "Dwaris NixOS Flake";

    nixConfig = {
        extra-substituters = ["https://nix-community.cachix.org"];
        extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
    };

    inputs = {
        nixpkgs.url = "github:Nixos/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager-stable = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs-stable";
        };

        lanzaboote = {
            url = "github:nix-community/lanzaboote/v0.3.0";
            # Optional but recommended to limit the size of your system closure.
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-wsl.url = "github:nix-community/nixos-wsl";
  };

    outputs = { self, nixpkgs, nixpkgs-stable, home-manager, home-manager-stable, lanzaboote, nixos-wsl, ... }@inputs: {
        nixosConfigurations = {
            jedha = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
                modules = [
                    lanzaboote.nixosModules.lanzaboote
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
            wsl = nixpkgs-stable.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./hosts/wsl/configuration.nix
                nixos-wsl.nixosModules.wsl
                home-manager-stable.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.extraSpecialArgs = inputs;
                    home-manager.users.dwaris = import ./hosts/wsl/home.nix;
                }
            ];
            };
        };
    };
}
