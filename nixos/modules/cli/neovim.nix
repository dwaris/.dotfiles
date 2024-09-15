{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./language-server.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    clang
    python3
    fd
    ripgrep
    luarocks
    lua5_1
  ];
}
