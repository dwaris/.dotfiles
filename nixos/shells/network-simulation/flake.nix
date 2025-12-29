{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [
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
