{
  description = "Dwaris NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs @ {...}: let
    specialArgs = {inherit inputs;};
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
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
      };

      batuu = inputs.nixpkgs-stable.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ./hosts/batuu/configuration.nix
        ];
      };

      # wsl = inputs.nixpkgs.lib.nixosSystem {
      #   inherit specialArgs;
      #   modules = [
      #     ./hosts/wsl/configuration.nix
      #     inputs.nixos-wsl.nixosModules.default
      #   ];
      # };
    };
  };
}
