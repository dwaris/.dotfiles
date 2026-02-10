{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = with pkgs;
          mkShell {
            packages = [
              (python3.withPackages (python-pkgs: [
                python-pkgs.pip

                python-pkgs.networkx
                python-pkgs.simpy

                python-pkgs.matplotlib
                python-pkgs.numpy
                python-pkgs.scipy

                python-pkgs.pyvis
              ]))
            ];
          };
      }
    );
}
