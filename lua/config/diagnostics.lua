local M = {}

function M.setup()
  vim.diagnostic.config {
    virtual_text = {
      prefix = '●',
      source = 'if_many',
      spacing = 4,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '',
        [vim.diagnostic.severity.WARN] = '',
        [vim.diagnostic.severity.INFO] = '',
        [vim.diagnostic.severity.HINT] = '',
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = 'rounded',
      source = true,
    },
  }
end

return M
