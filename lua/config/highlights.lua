local M = {}

local function apply()
    vim.api.nvim_set_hl(0, "@lsp.type.parameter", { italic = true })
    vim.api.nvim_set_hl(0, "@lsp.typemod.method.static", { italic = true })
    vim.api.nvim_set_hl(0, "@lsp.typemod.variable.static", { italic = true })
    vim.api.nvim_set_hl(0, "@lsp.typemod.variable.final", { bold = true })
    vim.api.nvim_set_hl(0, "@lsp.typemod.method.deprecated", { strikethrough = true })
    vim.api.nvim_set_hl(0, "@lsp.typemod.type.deprecated", { strikethrough = true })
end

function M.setup()
    apply()
    -- Re-apply after any colorscheme change wipes highlights
    vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
end

return M
