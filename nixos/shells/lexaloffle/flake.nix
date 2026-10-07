{
  description = "Lexaloffle fantasy consoles environment (PICO-8 & Picotron)";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
        system: let
          pkgs = nixpkgs.legacyPackages.${system};
          libs = with pkgs; [
            SDL2
            libGL
            alsa-lib
            wayland
            libxkbcommon
            libx11
            libxcursor
            libxrandr
            libxi
            libxinerama
            libxext
            libxrender
          ];
        in
          function pkgs libs
      );
  in {
    devShells = forAllSystems (pkgs: libs: {
      default = pkgs.mkShell {
        packages = libs;
        shellHook = ''
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath libs}:$LD_LIBRARY_PATH"
        '';
      };
    });
  };
}
