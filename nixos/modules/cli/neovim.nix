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
    clang
    
    nodejs_24

    imagemagick
    ghostscript
  ];
}
