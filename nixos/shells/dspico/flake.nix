{
  description = "DSPico Firmware Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        blocksds = pkgs.stdenv.mkDerivation rec {
          pname = "blocksds";
          version = "master";

          src = pkgs.fetchFromGitHub {
            owner = "blocksds";
            repo = "sdk";
            rev = "v0.17.1";
            hash = "sha256-4Y28Zz9v5wZz7vJz6Zz7vJz6Zz7vJz6Zz7vJz6Zz7vI=";
            fetchSubmodules = true;
          };

          nativeBuildInputs = with pkgs; [
            gcc-arm-embedded
            gnumake
          ];

          buildPhase = ''
            export BLOCKSDS=$PWD
            make -j$NIX_BUILD_CORES
          '';

          installPhase = ''
            mkdir -p $out
            make install INSTALLDIR=$out
          '';
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            gcc-arm-embedded
            cmake
            gnumake
            git
            dotnet-sdk_9
            python3

            blocksds
          ];

          shellHook = ''
            export BLOCKSDS=${blocksds}
            export DLDITOOL=${blocksds}/tools/dlditool/dlditool

            # Start the user with a helpful message
            echo "Environment loaded for DSPico compilation."
            echo "BLOCKSDS path: $BLOCKSDS"
            echo "DLDITOOL path: $DLDITOOL"
          '';
        };
      }
    );
}
