local mocha_colors = require('catppuccin.palettes').get_palette 'mocha'

require('lualine').setup {
  options = {
    theme = 'catppuccin-nvim',
    icons_enabled = true,
  },
  extensions = {
    'trouble',
    'oil',
    'mason',
    'quickfix',
    'symbols-outline',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = {
      {
        'lsp_status',
        icon = '',
        symbols = { spinner = { '' }, done = '', separator = ' | ' },
      },
    },
    lualine_y = {},
    lualine_z = {
      {
        function() return vim.bo.modified and '' or '' end,
        color = function()
          if vim.bo.modified then return { bg = mocha_colors.red, fg = mocha_colors.base, gui = 'bold' } end
          return { bg = mocha_colors.green, fg = mocha_colors.mantle, gui = 'bold' }
        end,
      },
    },
  },
}
