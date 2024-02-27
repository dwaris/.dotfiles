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

      nixosconfigurations = {
        jedha = nixpkgs.lib.nixossystem {
          specialargs = { inherit inputs; };
	  modules = [
            ./hosts/jedha/configuration.nix
            inputs.home-manager.nixosmodules.default
          ];
        };

        kashyyyk = nixpkgs.lib.nixossystem {
          specialargs = { inherit inputs; };
	  modules = [
            ./hosts/kashyyyk/configuration.nix
            inputs.home-manager.nixosmodules.default
          ];
        };
      };
    };
}
