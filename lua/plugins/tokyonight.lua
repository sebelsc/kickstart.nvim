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
  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) colors.bg = colors.bg_dark1 end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights tokyonight.Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors)
    -- highlights['@type.java'] = { link = '@none' } -- distinct from classes
    -- Types
    highlights['Type'] = { link = '@variable' }
    highlights['PreProc'] = { link = '@lsp.type.annotation.java' }

    highlights['@keyword.operator.java'] = { link = 'Special', italic = true }
    highlights['@type.builtin.java'] = { link = 'Special' }
    highlights['@variable.builtin.java'] = { fg = colors.blue5, italic = true }
    highlights['@lsp.type.interface.java'] = { link = '@variable', italic = true, bold = true } -- distinct from classes
    highlights['@lsp.type.enum.java'] = { link = '@variable', italic = true }
    highlights['@lsp.type.enumMember.java'] = { fg = colors.orange }
    highlights['@lsp.type.annotation.java'] = { fg = colors.yellow }
    highlights['@lsp.type.namespace.java'] = { link = '@variable', italic = true }
    highlights['@lsp.type.class.java'] = { link = '@variable', italic = true }
    highlights['@lsp.type.typeParameter.java'] = { fg = colors.fg, italic = true }
    highlights['@lsp.type.variable.java'] = { fg = colors.magenta }
    highlights['@lsp.type.field.java'] = { fg = colors.green2 } -- teal-green
    highlights['@lsp.type.enumMember.java'] = { fg = colors.orange, italic = true }
    highlights['@lsp.type.parameter.java'] = { fg = colors.yellow, italic = true }

    -- Typemod
    highlights['@lsp.typemod.interface.generic.java'] = { link = '@lsp.type.interface.java' }
    highlights['@lsp.typemod.property.private.java'] = { link = '@lsp.type.variable.java', underline = true }
    highlights['@lsp.typemod.property.protected.java'] = { link = '@lsp.type.variable.java' }
    highlights['@lsp.typemod.property.java'] = { fg = colors.red, undercurl = true, standout = true }
    -- highlights['@lsp.typemod.method.public.java'] = { bold = true }
    highlights['@lsp.typemod.method.private.java'] = { underline = true }
    highlights['@lsp.typemod.variable.declaration.java'] = { bold = true }
    highlights['@lsp.typemod.property.declaration.java'] = { bold = true }
    highlights['@lsp.typemod.variable.readonly.java'] = { fg = colors.red }
    highlights['@lsp.typemod.parameter.declaration.java'] = { fg = colors.red }

    -- Modifiers
    highlights['@lsp.mod.static.java'] = { underdotted = true }
    highlights['@lsp.mod.abstract.java'] = { italic = true }
    highlights['@lsp.mod.deprecated.java'] = { fg = colors.comment, strikethrough = true }
    highlights['@lsp.mod.typeArgument.java'] = { link = '@type.buildin' }
    highlights['@lsp.mod.importDeclaration.java'] = {}
    highlights['Comment'] = { link = 'Comment', italic = true }

    highlights['DiagnosticUnnecessary'] = { strikethrough = true }
    highlights['DiagnosticUnderlineHint'] = { undercurl = true }

    -- highlights['FlashMatch'] = { link = '@constant' }
    -- highlights['FlashLabel'] = { link = '@label' }
  end,
}

vim.cmd.colorscheme 'tokyonight-night'
