{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
        system: function nixpkgs.legacyPackages.${system}
      );
  in {
    devShells = forAllSystems (pkgs: {
      default = with pkgs;
        mkShell {
          packages = [
            (python3.withPackages (python-pkgs: [
              python-pkgs.networkx
              python-pkgs.simpy

              python-pkgs.numpy
              python-pkgs.scipy

              python-pkgs.matplotlib
            ]))
          ];
        };
    });
  };
}
