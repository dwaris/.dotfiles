{ pkgs, lib, ... }:
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
  });
in
{
  imports = [
    # For home-manager
    nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
        enable = true;
        flavour = "mocha";
    };

    clipboard.providers.wl-copy.enable = true;

    opts = {
        number = true;         # Show line numbers
        relativenumber = true; # Show relative line numbers
        shiftwidth = 4;        # Tab width should be 4
    };

    plugins = {
        bufferline.enable = true;
        lightline = {
            enable = true;
            colorscheme = "catppuccin";
        };

        lsp = {
            enable = true;

            servers = {
                tsserver.enable = true;

                lua-ls = {
                    enable = true;
                    settings.telemetry.enable = false;
                };
                rust-analyzer = {
                    enable = true;
                    installCargo = false;
                };
                marksman = {
                    enable = true;
                };
                gopls = {
                    enable = true;
                };
                nil_ls.enable = true;
            };
        };

        cmp = {
            enable = true;
            autoEnableSources = true;
            settings.sources = [
                {name = "nvim_lsp";}
                {name = "path";}
                {name = "buffer";}
                {name = "luasnip";}
            ];
        };
    };
  };
}
