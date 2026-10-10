{
  description = "Dwaris NixOS Flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.xz";

    lanzaboote = {
      url = "https://github.com/nix-community/lanzaboote/archive/refs/tags/v1.2.0.tar.gz";
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
