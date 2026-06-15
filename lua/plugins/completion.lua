require('nvim-autopairs').setup {}
-- note: neovim 0.12 ships native insert-mode completion via 'autocomplete'.
-- blink.cmp is still worth keeping for: fuzzy matching, ghost text,
-- integrated signature help, and documentation popup quality.
require('blink.cmp').setup {
  keymap = {
    preset = 'default',
  },
  -- keymap = {
  --   preset = 'none', -- define all bindings explicitly
  --   ['<c-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
  --   ['<c-e>'] = { 'hide', 'fallback' },
  --   ['<cr>'] = { 'accept', 'fallback' },
  --   ['<tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
  --   ['<s-tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
  --   ['<c-j>'] = { 'select_next', 'fallback' },
  --   ['<c-k>'] = { 'select_prev', 'fallback' },
  --   ['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
  --   ['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
  -- },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'normal',
  },

  fuzzy = {
    implementation = 'prefer_rust_with_warning',
  },

  -- snippets = {
  --   preset = { 'luasnip' },
  -- },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    -- per-filetype overrides: restrict buffer source in java files to
    -- avoid noise — jdtls completion is comprehensive enough
    per_filetype = {
      java = { 'lsp', 'path', 'snippets' },
    },
  },

  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },
    -- accept the currently visible ghost text on <right>
    ghost_text = { enabled = false },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = {
        border = 'rounded',
        direction_priority = {
          menu_north = { 'e', 'w', 'n', 's' },
          menu_south = { 's', 'e', 'w', 'n' },
        },
      },
    },

    menu = {
      border = 'rounded',
      direction_priority = { 's', 'n' },
      -- show a kind icon and kind label beside each item
      draw = {
        treesitter = { 'lsp' },
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind_icon', 'kind' },
        },
      },
    },
  },
  -- integrated signature help — replaces the <c-k> signature_help call
  -- for insert mode if you prefer blink's popup over the built-in float
  signature = {
    enabled = true,
    window = { border = 'rounded', direction_priority = { 's', 'n' } },
  },
}
