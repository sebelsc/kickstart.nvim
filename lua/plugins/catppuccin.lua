require('catppuccin').setup {
  flavour = 'mocha',
  background = { dark = 'mocha' },

  -- Dim inactive splits slightly — useful with split-heavy workflows
  dim_inactive = {
    enabled = true,
    shade = 'dark',
    percentage = 0.15,
  },

  -- Integrations: enable only what you actually use.
  -- Each enabled integration generates additional highlight groups.
  integrations = {
    treesitter = true,
    treesitter_context = true,
    rainbow_delimiters = true,
    which_key = true,
    gitsigns = true,
    mason = true,
    neotest = true,
    snacks = {
      enabled = true,
      indent_scope_color = 'lavender',
    },
    mini = {
      enabled = true,
    },
    -- Disable ibl — using Snacks.indent instead
    indent_blankline = { enabled = false },
    native_lsp = {
      enabled = true,
      -- Style for LSP virtual text by severity
      virtual_text = {
        errors = { 'italic' },
        hints = { 'italic' },
        warnings = { 'italic' },
        information = { 'italic' },
      },
      -- Style for LSP underlines by severity
      underlines = {
        errors = { 'undercurl' },
        hints = { 'underline' },
        warnings = { 'undercurl' },
        information = { 'underline' },
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
      Comment = { fg = colors.overlay1, style = { 'italic' } },

      -- Distinguish parameters from local variables at a glance
      -- (supplements the @lsp.type.parameter semantic token override
      --  in highlights.lua, which handles the italic style separately)
      ['@variable.parameter'] = { fg = colors.flamingo },

      -- Fold column / fold line blends into the background
      FoldColumn = { fg = colors.surface1, bg = colors.base },
      Folded = { fg = colors.subtext0, bg = colors.surface0 },

      -- Make the current search match more prominent
      CurSearch = { fg = colors.base, bg = colors.peach, style = { 'bold' } },

      -- Diagnostic virtual text — subtle background tint per severity
      DiagnosticVirtualTextError = { fg = colors.red, bg = colors.base },
      DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = colors.base },
      DiagnosticVirtualTextInfo = { fg = colors.sky, bg = colors.base },
      DiagnosticVirtualTextHint = { fg = colors.teal, bg = colors.base },
    }
  end,
}

vim.cmd.colorscheme 'catppuccin-mocha'
