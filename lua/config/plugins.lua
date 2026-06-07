-- ── Colorscheme — MUST be first in plugins.lua ───────────────────────────
-- vim.cmd.colorscheme() clears all highlights and repaints from scratch.
-- Every plugin that defines highlight groups in its setup() must run
-- AFTER this block so its groups are applied on top of the palette.

vim.pack.add({
    { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
})

require("catppuccin").setup({
    flavour           = "mocha",
    background        = { dark = "mocha" },

    -- Dim inactive splits slightly — useful with split-heavy workflows
    dim_inactive      = {
        enabled    = true,
        shade      = "dark",
        percentage = 0.15,
    },

    -- Integrations: enable only what you actually use.
    -- Each enabled integration generates additional highlight groups.
    integrations      = {
        treesitter         = true,
        treesitter_context = true,
        rainbow_delimiters = true,
        which_key          = true,
        gitsigns           = true,
        mason              = true,
        neotest            = true,
        snacks             = true,
        -- Disable ibl — using Snacks.indent instead
        indent_blankline   = { enabled = false },
        native_lsp         = {
            enabled = true,
            -- Style for LSP virtual text by severity
            virtual_text = {
                errors      = { "italic" },
                hints       = { "italic" },
                warnings    = { "italic" },
                information = { "italic" },
            },
            -- Style for LSP underlines by severity
            underlines = {
                errors      = { "undercurl" },
                hints       = { "underline" },
                warnings    = { "undercurl" },
                information = { "underline" },
            },
            inlay_hints = { background = true },
        },
    },

    -- Custom highlight overrides using the Mocha palette.
    -- `colors` is the full palette table; use it to keep overrides
    -- palette-relative rather than hard-coding hex values.
    custom_highlights = function(colors)
        return {
            -- Make comments slightly more visible than the default overlay0
            Comment                    = { fg = colors.overlay1, style = { "italic" } },

            -- Distinguish parameters from local variables at a glance
            -- (supplements the @lsp.type.parameter semantic token override
            --  in highlights.lua, which handles the italic style separately)
            ["@variable.parameter"]    = { fg = colors.flamingo },

            -- Fold column / fold line blends into the background
            FoldColumn                 = { fg = colors.surface1, bg = colors.base },
            Folded                     = { fg = colors.subtext0, bg = colors.surface0 },

            -- Make the current search match more prominent
            CurSearch                  = { fg = colors.base, bg = colors.peach, style = { "bold" } },

            -- Diagnostic virtual text — subtle background tint per severity
            DiagnosticVirtualTextError = { fg = colors.red, bg = colors.base },
            DiagnosticVirtualTextWarn  = { fg = colors.yellow, bg = colors.base },
            DiagnosticVirtualTextInfo  = { fg = colors.sky, bg = colors.base },
            DiagnosticVirtualTextHint  = { fg = colors.teal, bg = colors.base },
        }
    end,
})

-- Apply the colorscheme. Everything after this line inherits this palette.
vim.cmd.colorscheme("catppuccin-mocha")

if vim.g.have_nerd_font then vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons' } end

-- Highlight todo, notes, etc in comments
vim.pack.add { 'https://github.com/folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
require('plugins.mini')

vim.pack.add({
    'https://github.com/lewis6991/gitsigns.nvim',
    -- add further plugins here
})

require("plugins.gitsigns")
-- ── Tier 1: Core UI — no dependencies ────────────────────────────────────
-- These must be available before everything else because keymaps.lua and
-- other modules call Snacks.* and require("which-key") at the top level.

vim.pack.add({
    'https://github.com/folke/snacks.nvim',
    'https://github.com/folke/which-key.nvim',
})

require("plugins.snacks") -- Snacks global is now set
require("which-key").setup({})

vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
require('plugins.conform')

vim.pack.add { { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

vim.pack.add { { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' } }
require('plugins.blink')
-- -- ── Tier 2: Treesitter — textobjects depend on core parser ───────────────
-- -- nvim-treesitter must be added (and its setup called) before
-- -- treesitter-textobjects, because textobjects registers itself as a
-- -- treesitter module during its own plugin/ sourcing.

vim.pack.add {
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = "main" },
}
-- vim.cmd.packadd("nvim-treesitter")

-- -- Textobjects and other extensions are added AFTER core treesitter.
-- -- A separate add() call guarantees treesitter is in runtimepath first.
vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
    'https://github.com/HiPhish/rainbow-delimiters.nvim',
})

-- -- Setup treesitter after all extensions are in the runtimepath.
require("plugins.treesitter")
require("plugins.treesitter-textobjects")
require("plugins.treesitter-context")
require("plugins.rainbow")

-- ── Tier 3: Completion ───────────────────────────────────────────────────

vim.pack.add({
    'https://github.com/saghen/blink.cmp',
})
require("plugins.completion")

-- ── Tier 4: LSP tooling ──────────────────────────────────────────────────
-- mason and nvim-jdtls are added eagerly so their Lua modules are
-- require()-able, but jdtls is only *configured and attached* lazily
-- in the FileType autocmd (see config/autocmds.lua).
-- There is no cost to adding a plugin eagerly — the expense is in setup().

-- Mason
vim.pack.add {
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
}
-- Automatically install LSPs and related tools to stdpath for Neovim
require('plugins.mason')

-- JAVA
vim.pack.add({
    'https://github.com/mfussenegger/nvim-jdtls',
    'https://github.com/JavaHello/spring-boot.nvim',
    'https://github.com/ibhagwan/fzf-lua',
})
require('plugins.java')


-- -- ── Tier 5: Testing ──────────────────────────────────────────────────────
-- -- plenary and nvim-nio are neotest dependencies; they must be added first
-- -- because neotest's plugin/ scripts require() them at source time.

vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-neotest/nvim-nio',
})

vim.pack.add({
    'https://github.com/nvim-neotest/neotest',
    'https://github.com/rcasia/neotest-java',
})

-- require("neotest").setup(require("plugins.neotest"))

-- -- ── Tier 6: Everything else ───────────────────────────────────────────────
