{
    description = "Dwaris NixOS Flake";

    nixConfig = {
        extra-substituters = ["https://nix-community.cachix.org"];
        extra-trusted-public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
    };

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        lanzaboote = {
            url = "github:nix-community/lanzaboote";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixos-wsl.url = "github:nix-community/nixos-wsl";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-small, lanzaboote, home-manager, nixos-wsl, ... }: {
    nixosConfigurations = {
      jedha = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";	          
          modules = [
              ./hosts/jedha/configuration.nix
              lanzaboote.nixosModules.lanzaboote

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
              lanzaboote.nixosModules.lanzaboote

              home-manager.nixosModules.home-manager
              {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;

                  home-manager.extraSpecialArgs = inputs;
                  home-manager.users.dwaris = import ./hosts/kashyyyk/home.nix;
              }
          ];
      };

      wsl = nixpkgs-small.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
              ./hosts/wsl/configuration.nix
              nixos-wsl.nixosModules.wsl
              
              home-manager.nixosModules.home-manager
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
