{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
        system: function nixpkgs.legacyPackages.${system}
      );
  in {
    devShells = forAllSystems (pkgs: let
      commonPackages = with pkgs; [
        pi-coding-agent
        llama-swap
        python3Packages.huggingface-hub
      ];
    in {
      default = pkgs.mkShell {
        packages = [pkgs.llama-cpp-rocm] ++ commonPackages;
      };
      vulkan = pkgs.mkShell {
        packages = [pkgs.llama-cpp-vulkan] ++ commonPackages;
      };
    });
  };
}
