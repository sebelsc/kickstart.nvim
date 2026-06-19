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
    local variable_color = highlights['@variable'].fg or colors.fg
    local special_color= highlights['Special'].fg or colors.blue1

    -- General configuration
    highlights['Type'] = { fg = variable_color }
    highlights['PreProc'] = { link = '@lsp.type.annotation.java' }
    highlights['Comment'] = { fg = colors.comment, italic = true }

    highlights['DiagnosticUnnecessary'] = { strikethrough = true }
    highlights['DiagnosticUnderlineHint'] = { undercurl = true }
    highlights['DiffAdd'] = { bg = '#1a3a3a' } -- more saturated teal
    highlights['DiffDelete'] = { bg = colors.red, standout = true } -- more saturated red

    -- JAVA specific
    -- Types
    highlights['@keyword.operator.java'] = { fg = special_color, italic = true }
    highlights['@type.builtin.java'] = { link = 'Special' }
    highlights['@variable.builtin.java'] = { fg = colors.blue5, italic = true }
    highlights['@lsp.type.interface.java'] = { fg = colors.blue, italic = true, bold = true }
    highlights['@lsp.type.enum.java'] = { fg = variable_color, italic = true }
    highlights['@lsp.type.annotation.java'] = { fg = colors.yellow }
    highlights['@lsp.type.namespace.java'] = { fg = variable_color, italic = true }
    highlights['@lsp.type.class.java'] = { fg = variable_color, italic = true }
    highlights['@lsp.type.typeParameter.java'] = { fg = colors.fg, italic = true }
    highlights['@lsp.type.variable.java'] = { fg = colors.magenta }
    highlights['@lsp.type.field.java'] = { fg = colors.green2 } -- teal-green
    highlights['@lsp.type.enumMember.java'] = { fg = colors.orange, italic = true }
    highlights['@lsp.type.parameter.java'] = { fg = colors.yellow, italic = true }

    -- Typemod
    highlights['@lsp.typemod.interface.generic.java'] = { link = '@lsp.type.interface.java' }
    highlights['@lsp.typemod.property.private.java'] = { fg = colors.magenta, underline = true }
    highlights['@lsp.typemod.property.protected.java'] = { link = '@lsp.type.variable.java' }
    highlights['@lsp.typemod.property.java'] = { fg = colors.red, undercurl = true, standout = true }
    -- highlights['@lsp.typemod.method.public.java'] = { bold = true }
    highlights['@lsp.typemod.method.private.java'] = { underline = true }
    highlights['@lsp.mod.readonly.java'] = { underdouble = true }

    -- Modifiers
    highlights['@lsp.mod.static.java'] = { underdotted = true }
    highlights['@lsp.mod.abstract.java'] = { italic = true }
    highlights['@lsp.mod.deprecated.java'] = { fg = colors.comment, strikethrough = true }
    highlights['@lsp.mod.typeArgument.java'] = { link = '@type.builtin' }
    -- highlights['@lsp.mod.importDeclaration.java'] = {}

    -- highlights['FlashMatch'] = { link = '@constant' }
    -- highlights['FlashLabel'] = { link = '@label' }

    -- LUA specific
    highlights['@lsp.type.property.lua'] = { fg = colors.green2 }
    highlights['@lsp.type.variable.lua'] = { fg = colors.magenta }
    highlights['@lsp.type.parameter.lua'] = { fg = colors.yellow, italic = true }
  end,
}

vim.cmd.colorscheme 'tokyonight-night'
