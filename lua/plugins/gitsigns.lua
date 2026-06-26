require('gitsigns').setup {
  signs = {
    add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },
  -- on_attach = function(bufnr)
  --   local gs = require 'gitsigns'
  --   local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true }) end
  --
  --   -- Hunk navigation — ]h/[h to avoid conflicting with ]c/[c (treesitter classes)
  --   map('n', ']h', function() gs.nav_hunk 'next' end, 'next hunk')
  --   map('n', '[h', function() gs.nav_hunk 'prev' end, 'prev hunk')
  --
  --   -- Stage / reset
  --   map('n', '<leader>gs', gs.stage_hunk, '[G]it [S]tage hunk')
  --   map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, '[G]it [S]tage hunk')
  --   map('n', '<leader>gr', gs.reset_hunk, '[G]it [R]eset hunk')
  --   map('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, '[G]it [R]eset hunk')
  --   map('n', '<leader>gS', gs.stage_buffer, '[G]it [S]tage buffer')
  --   map('n', '<leader>gu', gs.undo_stage_hunk, '[G]it [U]ndo stage')
  --   map('n', '<leader>gR', gs.reset_buffer, '[G]it [R]eset buffer')
  --
  --   -- Inspect
  --   map('n', '<leader>gp', gs.preview_hunk, '[G]it [P]review hunk')
  --   map('n', '<leader>gb', function() gs.blame_line { full = true } end, '[G]it [B]lame')
  --   map('n', '<leader>gd', gs.diffthis, '[G]it [D]iff')
  --   map('n', '<leader>gD', function() gs.diffthis '~' end, '[G]it [D]iff HEAD~')
  -- end,
}
