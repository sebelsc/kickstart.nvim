-- ── nvim-treesitter-context ─────────────────────────────────────────────
-- Pins the enclosing scope header (class name, method signature, if condition)
-- at the top of the window when you scroll past it.
-- Prevents the "where am I in this 400-line class?" problem.
require('treesitter-context').setup {
  enable = false,
  max_lines = 4, -- max lines of context shown
  min_window_height = 20, -- don't show context in very small windows
  multiline_threshold = 20, -- collapse multiline contexts beyond this many chars
  trim_scope = 'outer',
  mode = 'topline', -- follows the cursor, not just the topline
  separator = '─', -- visual separator between context and buffer content
}

-- Jump to the context header with <C-]> (useful to check the full signature)
vim.keymap.set('n', '<leader>cc', function() require('treesitter-context').go_to_context(vim.v.count1) end, { desc = 'jump to context' })
