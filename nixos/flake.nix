{
  description = "Dwaris NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs: let
    specialArgs = {inherit inputs;};
    mkHost = channel: host:
      channel.lib.nixosSystem {
        inherit specialArgs;
        modules = [./hosts/${host}/configuration.nix];
      };
  in {
    nixosConfigurations = {
      jedha = mkHost inputs.nixpkgs "jedha";
      aldhani = mkHost inputs.nixpkgs "aldhani";
      kashyyyk = mkHost inputs.nixpkgs-stable "kashyyyk";
      batuu = mkHost inputs.nixpkgs-stable "batuu";

      # wsl = mkHost inputs.nixpkgs "wsl";
    };
  };
}
