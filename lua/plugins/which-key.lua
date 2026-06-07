require("which-key").setup({
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
        { '<leader>s', group = 'search' },
        { '<leader>c', group = 'code' },
        { '<leader>g', group = 'git',    mode = { 'n', 'v' } },
        { '<leader>t', group = 'test' },
        { '<leader>u', group = 'ui' },
        { '<leader>b', group = 'buffer' },
        { '<leader>f', group = 'file' },
        { '<leader>n', group = 'notify' },
    },
})
