{
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

    rustup
    go
    python3
    nodejs

    fd
    wget
    ripgrep
  ];
}
