return {
    'neovim/nvim-lspconfig',
    opts = {
        servers = {
            rust_analyzer = {},
            clangd = {},
            lua_ls = {},
            glsl_analyzer = {},
        },
    },
    inlay_hints = {
        enabled = true,
    },
    diagnostics = {
        virtual_text = {
            prefix = '⏹',
        },
    },
}
