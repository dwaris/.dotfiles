{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    nil
    nixfmt-rfc-style
    black
    stylua
    gopls
    pyright
    marksman
    lua-language-server
  ];
}
