-- ── nvim-treesitter core ────────────────────────────────────────────────
local ts = require 'nvim-treesitter'

ts.install {
  -- Languages
  'java',
  'kotlin',
  -- Config / build
  'lua',
  'json',
  'yaml',
  'toml',
  'xml',
  'bash',
  -- DB / query
  'sql',
  -- Docs
  'markdown',
  'markdown_inline',
  -- Neovim internals
  'vim',
  'vimdoc',
  'query',
  'regex',
}

-- ── Indent ─────────────────────────────────────────────────────────
-- Drives the = operator for auto-indentation.
-- Caveat: for Java, jdtls formatting (via LSP) is more accurate.
-- Keep enabled — = still works on ranges that jdtls does not own,
-- and it powers treesitter-aware indentation in new lines.
ts.setup {
  indent = { enable = true },
}

-- Text objects, move, swap — configured separately in previous artifact.

-- ── Folding ─────────────────────────────────────────────────────────────
-- Uses the treesitter parse tree to define fold ranges instead of
-- indentation heuristics. Folds track real language constructs:
-- methods, classes, lambdas, blocks, import groups.
--
-- Set globally. These options are window-local, so set them before
-- opening files, or in a BufReadPost autocmd for per-buffer control.
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- built-in since Nvim 0.10
vim.o.foldlevel = 99 -- start fully expanded
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldnestmax = 4 -- prevents deeply nested folds from becoming noise

-- ── nvim-treesitter-refactor ────────────────────────────────────────────
-- Of the four sub-features, only highlight_definitions is worth enabling
-- for Java — the others are superseded by jdtls:
--   smart_rename   → use vim.lsp.buf.rename() instead (cross-file aware)
--   navigation     → use LSP go-to-definition/references instead
require('nvim-treesitter').setup {
  refactor = {
    -- Highlights all usages of the symbol under the cursor in the current
    -- buffer. Additive on top of LSP semantic tokens — LSP does this for
    -- the current word, treesitter does it for the exact syntax node.
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
    highlight_current_scope = {
      enable = false, -- too visually noisy alongside ibl scope highlight
    },
    smart_rename = {
      enable = false, -- use vim.lsp.buf.rename() — cross-file, cross-module
    },
    navigation = {
      enable = false, -- use LSP definition/references
    },
  },
}
