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
                python-pkgs.defusedxml
                python-pkgs.protobuf
                python-pkgs.pycryptodomex
                python-pkgs.requests
                python-pkgs.pillow
                python-pkgs.tqdm
                python-pkgs.mutagen
                python-pkgs.ffmpeg-python
                python-pkgs.m3u8
              ]))
              parallel
            ];
          };
      }
    );
}
