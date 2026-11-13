return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'nvim-neotest/nvim-nio',
        },
        keys = {
            {
                '<F5>',
                function()
                    require('dap').continue()
                end,
                desc = 'Debug: Continue / Start',
            },
            {
                '<F10>',
                function()
                    require('dap').step_over()
                end,
                desc = 'Debug: Step Over',
            },
            {
                '<F11>',
                function()
                    require('dap').step_into()
                end,
                desc = 'Debug: Step Into',
            },
            {
                '<F12>',
                function()
                    require('dap').step_out()
                end,
                desc = 'Debug: Step Out',
            },
            {
                '<leader>db',
                function()
                    require('dap').toggle_breakpoint()
                end,
                desc = '[D]ebug: Toggle [B]reakpoint',
            },
            {
                '<leader>dc',
                function()
                    require('dap').continue()
                end,
                desc = '[D]ebug: [C]ontinue / Start',
            },
            {
                '<leader>dt',
                function()
                    require('dap').terminate()
                end,
                desc = '[D]ebug: [T]erminate',
            },
            {
                '<leader>du',
                function()
                    require('dapui').toggle()
                end,
                desc = '[D]ebug: Toggle [U]I',
            },
        },
        config = function()
            local dap = require 'dap'
            local dapui = require 'dapui'

            dapui.setup()

            dap.listeners.after.event_initialized['dapui_config'] = function()
                dapui.open()
            end

            dap.adapters.coreclr = {
                type = 'executable',
                command = 'netcoredbg',
                args = { '--interpreter=vscode' },
            }

            local function pick_dll()
                local dlls = vim.fn.glob(
                    vim.fn.getcwd() .. '/**/bin/Debug/**/*.dll',
                    false,
                    true
                )
                local exe_dlls = vim.tbl_filter(function(path)
                    local name = vim.fn.fnamemodify(path, ':t:r')
                    local dir = vim.fn.fnamemodify(path, ':h')
                    return vim.fn.filereadable(dir .. '/' .. name .. '.runtimeconfig.json')
                        == 1
                end, dlls)
                if #exe_dlls == 1 then
                    return { exe_dlls[1] }
                end
                return coroutine.create(function(coro)
                    vim.ui.select(exe_dlls, {
                        prompt = 'Select DLL to debug:',
                    }, function(choice)
                        coroutine.resume(coro, choice and { choice } or dap.ABORT)
                    end)
                end)
            end

            dap.configurations.cs = {
                {
                    type = 'coreclr',
                    name = 'Launch .NET (netcoredbg)',
                    request = 'launch',
                    justMyCode = false,
                    cwd = '${workspaceFolder}',
                    program = 'dotnet',
                    args = pick_dll,
                },
            }
        end,
    },
}
