vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.g.have_nerd_font = true
vim.o.relativenumber = true
vim.g.snacks_dim = true

-- Custom Keymap changes

-- Move selected lines up or down
vim.keymap.set('v', '<S-K>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<S-J>', ":m '>+1<CR>gv=gv")
-- Add empty line above or below current line without entering insert mode
vim.keymap.set('n', '<leader>o', 'o<Esc>')
vim.keymap.set('n', '<leader>O', 'O<Esc>')
-- Escape
vim.keymap.set('i', 'jk', '<Esc>')

-- Setup colorscheme with better semantic highlighting
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'onedark*',
  callback = function()
    local s = vim.api.nvim_set_hl

    -- Fields: distinct from locals (IntelliJ uses a muted purple/blue)
    s(0, '@lsp.type.property.java', { fg = '#c678dd' }) -- fields/properties
    s(0, '@lsp.typemod.field.static.java', { fg = '#c678dd', italic = true }) -- static fields

    -- Parameters: warm, distinct from locals
    s(0, '@lsp.type.parameter.java', { fg = '#d19a66' })

    -- Local variables: default fg is fine, but give them something crisp
    s(0, '@lsp.type.variable.java', { fg = '#e06c75' })

    -- Type/class names
    s(0, '@lsp.type.class.java', { fg = '#e5c07b', bold = true })
    s(0, '@lsp.type.interface.java', { fg = '#e5c07b', italic = true })
    s(0, '@lsp.type.enum.java', { fg = '#e5c07b' })
    s(0, '@lsp.type.enumMember.java', { fg = '#e5c07b', bold = true })
    s(0, '@lsp.type.annotation.java', { fg = '#98c379', italic = true })

    -- Methods
    s(0, '@lsp.type.method.java', { fg = '#61afef' })
    s(0, '@lsp.typemod.method.static.java', { fg = '#61afef', italic = true })
    s(0, '@lsp.type.constructor.java', { fg = '#61afef', bold = true })

    -- Modifiers
    s(0, '@lsp.typemod.variable.final.java', { bold = true })
    s(0, '@lsp.typemod.field.final.java', { bold = true })
    s(0, '@lsp.typemod.parameter.final.java', { bold = true })
    s(0, '@lsp.typemod.variable.deprecated.java', { strikethrough = true })
  end,
})

vim.cmd.doautocmd 'ColorScheme onedark_dark'


