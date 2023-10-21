return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = true,
    },
    diagnostics = {
      virtual_text = {
        prefix = "⏹",
      },
    },
  },
}
