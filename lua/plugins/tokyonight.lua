require('tokyonight').setup {
  style = 'night',
  terminal_colors = true,
  cache = true,
  dim_inactive = true,
  lualine_bold = true,
  styles = {
    sidebars = 'dark',
    floats = 'dark',
  },
  plugins = {
    auto = false,
    dap = true,
    flash = true,
    mini_surround = true,
    treesitter = true,
    ['treesitter-context'] = true,
    ['which-key'] = true,
    semantic_tokens = true,
    rainbow = true,
    gitsigns = true,
    neotest = true,
    blink = true,
    snacks = true,
    trouble = true,
  },

  on_colors = function(colors)
    colors.bg = colors.bg_dark1
    colors.fg = '#e0e4f5' -- new baseline for all text
    -- colors.comment = '#434a68' -- dimmed comments, compensates for darker bg
  end,

  on_highlights = function(highlights, colors)
    local import_statement_color = '#565f89'
    local annotation_color = '#565f89'

    -- ── General ──────────────────────────────────────────────
    highlights['Type'] = { fg = colors.fg_dark }
    highlights['Comment'] = { fg = colors.comment, italic = true }
    highlights['DiagnosticUnnecessary'] = { strikethrough = true }
    highlights['DiagnosticUnderlineHint'] = { undercurl = true }
    highlights['String'] = { fg = colors.yellow }
    highlights['@string'] = { fg = colors.yellow }

    -- ── Keywords / structural — greyscale, not real color ───
    -- if/for/return/public/void/this/instanceof etc.
    highlights['@punctuation.delimiter.java'] = { fg = colors.fg }
    -- highlights['@keyword'] = { fg = colors.fg_dark }
    highlights['@operator'] = { fg = colors.fg }
    highlights['@variable'] = { fg = colors.magenta }
    highlights['@type.builtin.java'] = { fg = colors.fg_dark } -- int, boolean, void...
    highlights['@variable.builtin.java'] = { fg = colors.fg_dark } -- this, super

    -- ── Annotations — slightly more visible than comments ───
    highlights['@lsp.type.annotation.java'] = { fg = annotation_color }
    highlights['PreProc'] = { link = '@lsp.type.annotation.java' }

    -- ── Java: distinct hues per identifier category ─────────
    -- class / interface / enum / namespace — structural types
    highlights['@lsp.type.class.java'] = { fg = colors.blue }
    highlights['@lsp.type.interface.java'] = { fg = colors.blue }
    highlights['@lsp.type.enum.java'] = { fg = colors.blue }
    highlights['@keyword.import.java'] = { fg = import_statement_color }
    highlights['@lsp.type.namespace.java'] = { fg = import_statement_color }
    highlights['@lsp.mod.importDeclaration.java'] = { fg = import_statement_color }
    highlights['@lsp.type.typeParameter.java'] = { fg = colors.blue } -- generics <T>

    -- methods — behavior
    highlights['@lsp.type.method.java'] = { fg = colors.green }

    -- fields — persistent state
    highlights['@lsp.type.field.java'] = { fg = colors.green2 }
    highlights['@lsp.type.enumMember.java'] = { fg = colors.green2 } -- field-like

    -- parameters — incoming data
    highlights['@lsp.type.parameter.java'] = { fg = colors.orange }

    -- local variables — ephemeral, method-scoped
    highlights['@lsp.type.variable.java'] = { fg = colors.magenta }

    -- ── Java: only decoration kept — deprecated ──────────────
    highlights['@lsp.mod.deprecated.java'] = { fg = colors.comment, strikethrough = true }

    -- ── Lua: same identifier-category hues ───────────────────
    highlights['@lsp.type.property.lua'] = { fg = colors.green2 } -- field-equivalent
    highlights['@lsp.type.variable.lua'] = { fg = colors.magenta } -- local-equivalent
    highlights['@lsp.type.parameter.lua'] = { fg = colors.orange } -- param-equivalent
  end,
}
vim.cmd.colorscheme 'tokyonight-night'
