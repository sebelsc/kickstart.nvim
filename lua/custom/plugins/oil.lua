vim.pack.add { { src = 'https://github.com/stevearc/oil.nvim', version = vim.version.range '2.*' } }

vim.keymap.set('n', '-', function() require('oil').toggle_float() end, { desc = 'Open parent directory (float)' })

require('oil').setup {
  default_file_explorer = true,
  columns = { 'icon' },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  watch_for_changes = true,
  view_options = {
    show_hidden = true,
    natural_order = 'fast',
  },
  keymaps = {
    ['<Esc>'] = { 'actions.close', mode = 'n' },
  },
  float = {
    padding = 2,
    max_width = 0.5,
    max_height = 0.5,
    border = 'rounded',
  },
}
