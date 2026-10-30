{
  description = "Dwaris NixOS Flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";

    lanzaboote = {
      url = "https://github.com/nix-community/lanzaboote/archive/refs/tags/v1.2.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote-stable = {
      url = "https://github.com/nix-community/lanzaboote/archive/refs/tags/v1.2.0.tar.gz";
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
