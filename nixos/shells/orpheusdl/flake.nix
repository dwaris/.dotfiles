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
              tmux
            ];
          };
      }
    );
}
