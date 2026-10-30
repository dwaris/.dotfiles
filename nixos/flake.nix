{
  description = "Dwaris NixOS Flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote-stable = {
      url = "github:nix-community/lanzaboote/v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = inputs: let
    channels = {
      unstable = {
        nixpkgs = inputs.nixpkgs;
        lanzaboote = inputs.lanzaboote;
      };
      stable = {
        nixpkgs = inputs.nixpkgs-stable;
        lanzaboote = inputs.lanzaboote-stable;
      };
    };

    mkHost = channel: host:
      channel.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          lanzaboote = channel.lanzaboote;
        };
        modules = [./hosts/${host}/configuration.nix];
      };
  in {
    nixosConfigurations = {
      jedha = mkHost channels.unstable "jedha";
      aldhani = mkHost channels.unstable "aldhani";
      kashyyyk = mkHost channels.stable "kashyyyk";
      batuu = mkHost channels.stable "batuu";
    };
  };
}
