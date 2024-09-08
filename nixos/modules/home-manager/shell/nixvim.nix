{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
    black
    stylua
    gopls
    pyright
    marksman
    lua-language-server
  ];

  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;

    # Theme
    colorschemes.catppuccin.enable = true;

    # Settings
    opts = {
      expandtab = true;
      shiftwidth = 4;
      smartindent = true;
      tabstop = 4;
      number = true;
      clipboard = "unnamedplus";

      ignorecase = true;
      incsearch = true;
      smartcase = true;
      wildmode = "list:longest";

      swapfile = false;
      undofile = true;
    };

    # Keymaps
    globals = {
      mapleader = " ";
    };

    plugins = {

      # UI
      lualine.enable = true;
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
          fzf-native.enable = true;
        };
      };
      indent-blankline = {
        enable = true;
      };
      undotree = {
        enable = true;
        settings = {
          autoOpenDiff = true;
          focusOnToggle = true;
        };
        settings.keymaps = [
          {
            mode = "n";
            key = "<leader>ut";
            action = "<cmd>UndotreeToggle<CR>";
            options = {
              silent = true;
              desc = "Undotree";
            };
          }
        ];
      };

      conform-nvim = {
        enable = true;
        settings = {
          formatOnSave = {
            lspFallback = true;
            timeoutMs = 500;
          };
          notifyOnError = true;
          formattersByFt = {
            html = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            css = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            javascript = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            typescript = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            python = [ "black" ];
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            markdown = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            yaml = [
              "yamllint"
              "yamlfmt"
            ];
          };
        };
      };

      # Dev
      lsp = {
        enable = true;
        servers = {
          pyright.enable = true;
          marksman.enable = true;
          nil-ls.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };
    };
  };
}
