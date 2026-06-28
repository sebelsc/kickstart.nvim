do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true
  vim.opt.termguicolors = true

  -- Tab behavior
  vim.o.expandtab = true
  vim.o.tabstop = 4
  vim.o.softtabstop = 4
  vim.o.shiftwidth = 4

  -- [[ Setting options ]]
  --  See `:help vim.o`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Make line numbers default
  vim.o.number = true
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  vim.opt.wrap = false
  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable break indent
  vim.o.breakindent = true

  -- Enable undo/redo changes even after closing and reopening a file
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 1000

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Configure Completion popup
  vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
  vim.opt.pumheight = 10

  -- Configure folding
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  vim.opt.foldlevelstart = 99

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   See `:help lua-options`
  --   and `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true

  vim.opt.autoread = true

  -- ============================================================
  -- Snacks
  vim.g.snacks_words = true

  -- GUI

  vim.o.guifont = 'Maple Mono Normal NF:h15'
  vim.opt.linespace = 1

  -- Diagnostics
  vim.diagnostic.config {
    virtual_text = false,
    update_in_insert = false,
  }

  -- LSPs
  vim.lsp.config('jdtls', {
    flags = { debounce_text_change = 500 },
  })
  if vim.g.neovide then
    vim.o.guifont = 'Maple Mono Normal NF:h14'
    vim.opt.linespace = 1
    vim.g.neovide_cursor_short_animation_length = 0
    vim.g.neovide_cursor_animation_length = 0.100
    vim.g.neovide_cursor_trail_size = 0.6
    vim.g.neovide_cursor_animate_in_insert_mode = false
  end
  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  -- vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  -- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  -- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  -- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  -- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  -- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
end

-- -- Setup colorscheme with better semantic highlighting
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   pattern = 'onedark*',
--   callback = function()
--     local s = vim.api.nvim_set_hl

--     -- Fields: distinct from locals (IntelliJ uses a muted purple/blue)
--     s(0, '@lsp.type.property.java', { fg = '#c678dd' }) -- fields/properties
--     s(0, '@lsp.typemod.field.static.java', { fg = '#c678dd', italic = true }) -- static fields

--     -- Parameters: warm, distinct from locals
--     s(0, '@lsp.type.parameter.java', { fg = '#d19a66' })

--     -- Local variables: default fg is fine, but give them something crisp
--     s(0, '@lsp.type.variable.java', { fg = '#e06c75' })

--     -- Type/class names
--     s(0, '@lsp.type.class.java', { fg = '#e5c07b', bold = true })
--     s(0, '@lsp.type.interface.java', { fg = '#e5c07b', italic = true })
--     s(0, '@lsp.type.enum.java', { fg = '#e5c07b' })
--     s(0, '@lsp.type.enumMember.java', { fg = '#e5c07b', bold = true })
--     s(0, '@lsp.type.annotation.java', { fg = '#98c379', italic = true })

--     -- Methods
--     s(0, '@lsp.type.method.java', { fg = '#61afef' })
--     s(0, '@lsp.typemod.method.static.java', { fg = '#61afef', italic = true })
--     s(0, '@lsp.type.constructor.java', { fg = '#61afef', bold = true })

--     -- Modifiers
--     s(0, '@lsp.typemod.variable.final.java', { bold = true })
--     s(0, '@lsp.typemod.field.final.java', { bold = true })
--     s(0, '@lsp.typemod.parameter.final.java', { bold = true })
--     s(0, '@lsp.typemod.variable.deprecated.java', { strikethrough = true })
--   end,
-- })

-- vim.cmd.doautocmd("ColorScheme " .. vim.g.colors_name)
