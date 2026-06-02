vim.pack.add { 'https://codeberg.org/andyg/leap.nvim' }

vim.keymap.set({ 'n', 'x', 'o' }, '<leader>js', '<Plug>(leap)')
vim.keymap.set('n', '<leader>J', '<Plug>(leap-from-window)')
