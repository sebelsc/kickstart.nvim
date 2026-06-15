require('which-key').setup {
  delay = 0,
  preset = 'helix',
  icons = { mappings = true },
  plugins = {
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  -- spec = {
  --     { '<leader>s', group = 'search' },
  --     { '<leader>c', group = 'code' },
  --     { '<leader>g', group = 'git',    mode = { 'n', 'v' } },
  --     { '<leader>t', group = 'test' },
  --     { '<leader>u', group = 'ui' },
  --     { '<leader>b', group = 'buffer' },
  --     { '<leader>f', group = 'file' },
  --     { '<leader>n', group = 'notify' },
  -- },
}
