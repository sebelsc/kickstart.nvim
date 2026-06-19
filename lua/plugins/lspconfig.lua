vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = '',
      },
      scheams = require('schemastore').yaml.schemas(),
    },
  },
})

vim.lsp.enable { 'jsonls', 'yamlls' }
