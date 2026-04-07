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
    });
  };
}
