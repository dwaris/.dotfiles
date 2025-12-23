{
  config,
  lib,
  pkgs,
  ...
}: {

  programs.nix-ld.enable = true;
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    tree-sitter

    clang
    nodejs_24

    fd
    wget
    ripgrep
  ];
}
