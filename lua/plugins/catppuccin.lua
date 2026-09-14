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
    blink_cmp = {
      style = 'bordered',
    },
    which_key = true,
    flash = true,
    fzf = true,
    lsp_saga = true,
    gitsigns = {
      enabled = true,
      transparent = false,
    },
    diffview = true,
    mason = true,
    neotest = true,
    snacks = {
      enabled = true,
      indent_scope_color = 'lavender',
    },
    lsp_trouble = true,
    dap = true,
    dap_ui = true,
    mini = {
      enabled = true,
    },
    -- Disable ibl — using Snacks.indent instead
    indent_blankline = { enabled = false },
    lualine = {
      all = function(colors)
        return {
          normal = { c = { bg = colors.crust } },
          -- insert = { a = { bg = colors.crust }, b = { bg = colors.crust } },
          -- visual = { a = { bg = colors.crust }, b = { bg = colors.crust } },
          -- replace = { a = { bg = colors.crust }, b = { bg = colors.crust } },
          -- command = { a = { bg = colors.crust }, b = { bg = colors.crust } },
          -- inactive = { a = { bg = colors.crust }, b = { bg = colors.crust }, c = { bg = colors.crust } },
        }
      end,
    },
    -- native_lsp = {
    --   enabled = true,
    --   -- Style for LSP virtual text by severity
    --   virtual_text = {
    --     errors = { 'italic' },
    --     hints = { 'italic' },
    --     warnings = { 'italic' },
    --     information = { 'italic' },
    --   },
    --   -- Style for LSP underlines by severity
    --   underlines = {
    --     errors = { 'undercurl' },
    --     hints = { 'underline' },
    --     warnings = { 'undercurl' },
    --     information = { 'underline' },
    --   },
    --   inlay_hints = { background = true },
    -- },
  },
  styles = {
    comments = { 'italic' },
    conditionals = { 'italic' },
    loops = { 'italic' },
    keywords = { 'bold', 'italic' },
    operators = { 'bold' },
  },
  lsp_styles = {

    virtual_text = {
      errors = { 'bold', 'underdouble' },
    },
    inlay_hints = {
      background = false,
    },
  },
  custom_highlights = function(colors)
    return {
      Normal = { bg = colors.crust },
      NormalNC = { bg = colors.crust },
      NormalFloat = { bg = colors.crust },
      StatusLine = { bg = colors.crust },
      StatusLineNC = { bg = colors.crust },
      TabLine = { bg = colors.crust },
      TabLineFill = { bg = colors.crust },
      SignColumnSB = { bg = colors.crust },
      Pmenu = { bg = colors.crust },
      FloatTitle = { bg = colors.crust },
      SignColumn = { bg = colors.crust },
      YankHighlight = { bg = colors.peach, fg = colors.crust, style = { 'bold' } },
      FloatBorder = { fg = colors.overlay0, bg = colors.base },
      SnacksPickerInputBorder = { bg = colors.crust },
      SnacksPickerBorder = { bg = colors.crust },
      SnacksPickerBoxBorder = { bg = colors.crust },
      SnacksPickerListBorder = { bg = colors.crust },
      SnacksPickerPreviewBorder = { bg = colors.crust },
      SnacksPickerBoxFooter = { bg = colors.crust },
    }
  end,
  -- Custom highlight overrides using the Mocha palette.
  -- `colors` is the full palette table; use it to keep override
  -- palette-relative rather than hard-coding hex values.
  -- custom_highlights = function(colors)
  --   return {
  --     -- Make comments slightly more visible than the default overlay0
  --     Comment = { fg = colors.overlay1, style = { 'italic' } },
  --
  --     -- Distinguish parameters from local variables at a glance
  --     -- (supplements the @lsp.type.parameter semantic token override
  --     --  in highlights.lua, which handles the italic style separately)
  --     ['@variable.parameter'] = { fg = colors.flamingo },
  --
  --     -- Fold column / fold line blends into the background
  --     FoldColumn = { fg = colors.surface1, bg = colors.base },
  --     Folded = { fg = colors.subtext0, bg = colors.surface0 },
  --
  --     -- Make the current search match more prominent
  --     CurSearch = { fg = colors.base, bg = colors.peach, style = { 'bold' } },
  --
  --     -- Diagnostic virtual text — subtle background tint per severity
  --     DiagnosticVirtualTextError = { fg = colors.red, bg = colors.base },
  --     DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = colors.base },
  --     DiagnosticVirtualTextInfo = { fg = colors.sky, bg = colors.base },
  --     DiagnosticVirtualTextHint = { fg = colors.teal, bg = colors.base },
  --   }
  -- end,
}

vim.cmd.colorscheme 'catppuccin-nvim'
