-- ── Colorscheme — MUST be first in plugins.lua ───────────────────────────
-- vim.cmd.colorscheme() clears all highlights and repaints from scratch.
-- Every plugin that defines highlight groups in its setup() must run
-- AFTER this block so its groups are applied on top of the palette.

vim.pack.add {
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/folke/tokyonight.nvim', name = 'tokyonight' },
  { src = 'https://github.com/olimorris/onedarkpro.nvim', name = 'onedarkpro' },
}

require 'plugins.catppuccin'
-- require 'plugins.tokyonight'
-- require 'plugins.onedarkpro'

vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons', 'https://github.com/nvim-lualine/lualine.nvim' }
require 'plugins.lualine'

-- Highlight todo, notes, etc in comments
vim.pack.add { 'https://github.com/folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
require 'plugins.mini'

vim.pack.add {
  'https://github.com/lewis6991/gitsigns.nvim',
  -- add further plugins here
}

require 'plugins.gitsigns'
-- ── Tier 1: Core UI — no dependencies ────────────────────────────────────
-- These must be available before everything else because keymaps.lua and
-- other modules call Snacks.* and require("which-key") at the top level.

vim.pack.add {
  'https://github.com/folke/snacks.nvim',
  'https://github.com/folke/which-key.nvim',
}

require 'plugins.snacks' -- Snacks global is now set
require 'plugins.which-key'

vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
require 'plugins.conform'

vim.pack.add { { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

-- vim.pack.add { { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' } }
-- require 'plugins.blink'
-- -- ── Tier 2: Treesitter — textobjects depend on core parser ───────────────
-- -- nvim-treesitter must be added (and its setup called) before
-- -- treesitter-textobjects, because textobjects registers itself as a
-- -- treesitter module during its own plugin/ sourcing.

vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}
-- vim.cmd.packadd("nvim-treesitter")

-- -- Textobjects and other extensions are added AFTER core treesitter.
-- -- A separate add() call guarantees treesitter is in runtimepath first.
vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/HiPhish/rainbow-delimiters.nvim',
}

-- -- Setup treesitter after all extensions are in the runtimepath.
require 'plugins.treesitter'
require 'plugins.treesitter-textobjects'
require 'plugins.treesitter-context'
require 'plugins.rainbow'

-- ── Tier 3: Completion ───────────────────────────────────────────────────

vim.pack.add {
  { src = 'https://github.com/windwp/nvim-autopairs', version = 'master' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
}
require 'plugins.completion'

-- ── Tier 4: LSP tooling ──────────────────────────────────────────────────
-- mason and nvim-jdtls are added eagerly so their Lua modules are
-- require()-able, but jdtls is only *configured and attached* lazily
-- in the FileType autocmd (see config/autocmds.lua).
-- There is no cost to adding a plugin eagerly — the expense is in setup().

-- Mason
vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/b0o/SchemaStore.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
}
-- Automatically install LSPs and related tools to stdpath for Neovim
require 'plugins.mason'
require 'plugins.lspconfig'

-- JAVA
vim.pack.add {
  'https://codeberg.org/mfussenegger/nvim-jdtls',
  'https://github.com/JavaHello/spring-boot.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://codeberg.org/mfussenegger/nvim-dap',
  'https://github.com/thehamsta/nvim-dap-virtual-text',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/rcasia/neotest-java',
  'https://github.com/folke/trouble.nvim',
}

require 'plugins.java'
require 'plugins.trouble'

-- KOTLIN
vim.pack.add {
  'https://github.com/AlexandrosAlexiou/kotlin.nvim',
}

require 'plugins.kotlin'

-- -- ── Tier 5: Testing ──────────────────────────────────────────────────────
-- -- plenary and nvim-nio are neotest dependencies; they must be added first
-- -- because neotest's plugin/ scripts require() them at source time.

-- require("neotest").setup(require("plugins.neotest"))

-- -- ── Tier 6: Everything else ───────────────────────────────────────────────
vim.pack.add { { src = 'https://github.com/j-hui/fidget.nvim', version = vim.version.range '*' } }
require 'plugins.fidget'

vim.pack.add { { src = 'https://github.com/sindrets/diffview.nvim', version = 'main' } }
require 'plugins.diffview'

vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
require 'plugins.oil'

vim.pack.add { 'https://github.com/folke/flash.nvim' }
require('plugins.flash').setup()

vim.pack.add { 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' }
require 'plugins.tiny-inline-diagnostic'

vim.pack.add { 'https://github.com/jiaoshijie/undotree' }
require 'plugins.undotree'

vim.pack.add { 'https://github.com/kosayoda/nvim-lightbulb' }
require 'plugins.lightbulb'

vim.pack.add { 'https://github.com/felpafel/inlay-hint.nvim' }
require 'plugins.inlay-hint'
