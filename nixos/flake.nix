{
  description = "Dwaris NixOS Flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    nixpkgs-stable.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";

    lanzaboote.url = "https://github.com/nix-community/lanzaboote/archive/refs/tags/v1.2.0.tar.gz";
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
    };
  };
}
