{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    clang
    fd
    ripgrep

    bash-language-server
    markdownlint-cli

    lua-language-server
    stylua

    nil
    nixfmt-rfc-style
  ];
}
