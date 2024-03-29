{
  description = "Dwaris NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {

      nixosConfigurations = {
        jedha = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
	  modules = [
            ./hosts/jedha/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        kashyyyk = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
	  modules = [
            ./hosts/kashyyyk/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
