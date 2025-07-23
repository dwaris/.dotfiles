{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell =
          with pkgs;
          mkShell {
            buildInputs = 
                [
                  bc
                  bison
                  binutils
                  gcc
                  gnumake
                  ccache
                  curl
                  flex
                  gcc_multi
                  git
                  git-lfs
                  gnupg
                  gperf
                  imagemagick
                  ncurses5
                  ncurses5.dev
                  readline
                  readline.dev
                  zlib
                  zlib.dev
                  lz4
                  lzop
                  SDL
                  openssl.dev
                  wxGTK32
                  libxml2
                  libxslt
                  pngcrush
                  rsync
                  schedtool
                  squashfsTools
                  zip
                ];

            shellHook = ''
              export USE_CCACHE=1
              export CCACHE_EXEC=${ccache}/bin/ccache
            '';
          };
      }
    );
}


