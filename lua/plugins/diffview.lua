require('diffview').setup {}

-- ~/.config/nvim/lua/keymaps.lua (or wherever your global keymaps live)

-- Diff current file vs index (unstaged changes)
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen -- %<CR>", { desc = "Diff file vs index" })

-- Diff current file vs origin/main (changes since branching)
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen origin/main...HEAD -- %<CR>", { desc = "Diff file vs main" })

-- File history for current file
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })

-- Full repo history
vim.keymap.set("n", "<leader>gH", "<cmd>DiffviewFileHistory<CR>", { desc = "Repo history" })

-- Close
vim.keymap.set("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
