vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.g.have_nerd_font = true
vim.o.relativenumber = true

-- Custom Keymap changes
vim.keymap.set('v', '<S-K>', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', '<S-J>', ":m '>+1<CR>gv=gv")
