return {
    {
        'zbirenbaum/copilot.lua',
        requires = {
            'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
        },
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('copilot').setup {
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    hide_during_completion = false,
                    debounce = 25,
                    keymap = {
                        accept = false,
                        accept_word = false,
                        accept_line = '<C-v>',
                        next = false,
                        prev = false,
                        dismiss = false,
                    },
                },
            }
        end,
    },
}
