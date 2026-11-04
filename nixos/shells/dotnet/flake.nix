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
            dotnet-sdk_10 # .NET 10 LTS SDK
            csharpier # Code formatter
            netcoredbg # DAP Debugger
          ];

          env = {
            DOTNET_ROOT = "${dotnet-sdk_10}";
            DOTNET_CLI_TELEMETRY_OPTOUT = "1";
          };
        };
    });
  };
}
