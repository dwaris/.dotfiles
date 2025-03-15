if vim.g.vscode then
    vim.opt.clipboard:append 'unnamedplus'
else
    require 'dwaris'
end
