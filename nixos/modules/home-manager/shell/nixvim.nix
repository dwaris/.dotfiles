{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    # Theme
    colorschemes.tokyonight.enable = true;

    # Settings
    opts = {
      expandtab = true;
      shiftwidth = 4;
      smartindent = true;
      tabstop = 4;
      number = true;
      clipboard = "unnamedplus";
    };

    # Keymaps
    globals = {
      mapleader = " ";
    };

    plugins = {

      # UI
      lualine.enable = true;
      bufferline.enable = true;
      treesitter.enable = true;
      which-key = {
        enable = true;
      };

      telescope = {
        enable = true;
        settings.keymaps = {
          "<leader>ff" = {
            desc = "file finder";
            action = "find_files";
          };
          "<leader>fg" = {
            desc = "find via grep";
            action = "live_grep";
          };
        };
        extensions = {
          file-browser.enable = true;
        };
      };

      # Dev
      lsp = {
        enable = true;
        servers = {
          marksman.enable = true;
          nil-ls.enable = true;
          rust-analyzer = {
            enable = true;
          };
        };
      };
    };
  };
}