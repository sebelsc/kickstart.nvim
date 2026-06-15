-- ══════════════════════════════════════════════════════════════════════
-- init.lua
-- ══════════════════════════════════════════════════════════════════════
--
-- vim.pack.add() is synchronous: when it returns, every listed plugin is
-- in the runtimepath and its plugin/ scripts have been sourced.
-- There is no deferred loading — what you see here is what executes, in
-- order, every time Neovim starts.
--
-- Ordering rules:
--   1. Leader key         — before any keymap is registered
--   2. Options            — before plugins read them during setup()
--   3. vim.pack.add()     — add all plugins to the runtimepath
--   4. Eager setup()      — configure plugins needed immediately at startup
--   5. Autocmds           — register event handlers (LspAttach etc.)
--   6. Keymaps            — all plugins are loaded, top-level require() is safe
--   7. Diagnostics        — global config, before first LSP attach
--   8. Highlights         — after colorscheme is active
--
-- Lazy loading: delay the setup() call (or the packadd) inside an autocmd.
-- There is no lazy.nvim-style event/ft/keys system — you implement it
-- explicitly with vim.api.nvim_create_autocmd or vim.defer_fn.
--
-- Dependency ordering: if plugin B calls require('A') during its setup(),
-- plugin A's vim.pack.add() must come first. Since add() is synchronous,
-- two separate add() calls guarantee order. Plugins in the same add() call
-- are loaded in array order.

-- ── 1. Leader key ────────────────────────────────────────────────────────
-- Must precede any require() that registers keymaps using <leader>.

-- ── 2. Options ───────────────────────────────────────────────────────────
-- Pure vim.opt calls. No plugin references.
require 'config.options'

-- ── 3 + 4. Plugins — add then configure immediately ──────────────────────
-- Each require("plugins.X") contains the setup() call for that plugin.
-- The pattern is always: vim.pack.add() → require("plugins.X").setup()
-- Because add() is synchronous, the plugin is available when setup() runs.
require 'config.plugins' -- see lua/config/plugins.lua below

local ih_ns = vim.api.nvim_create_namespace 'nvim.lsp.inlayhint'
local orig = vim.api.nvim_buf_set_extmark

vim.api.nvim_buf_set_extmark = function(buf, ns, line, col, opts)
  if ns == ih_ns then
    local ok, result = pcall(orig, buf, ns, line, col, opts)
    if not ok then
      vim.notify(result, vim.log.levels.WARN)
      return -1
    end
    return result
  end
  return orig(buf, ns, line, col, opts)
end

-- ── 5. Autocmds ──────────────────────────────────────────────────────────
-- LspAttach, FileType handlers, format-on-save, etc.
-- LspAttach fires when a file is first opened after init.lua completes,
-- so registering it here is always early enough.
require('config.autocmds').setup()

-- ── 6. Keymaps ───────────────────────────────────────────────────────────
-- All plugins are in the runtimepath by now (config.plugins ran above).
-- Top-level require() of any plugin is safe here — no inline tricks needed.
require('config.keymaps').setup()

-- ── 7. Diagnostics ───────────────────────────────────────────────────────
require('config.diagnostics').setup()

-- ── 8. Highlights ────────────────────────────────────────────────────────
-- Semantic token overrides and colorscheme-dependent hl groups.
require('config.highlights').setup()
