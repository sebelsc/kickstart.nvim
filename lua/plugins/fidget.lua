require('fidget').setup {
  progress = {
    suppress_on_insert = true,
    ignore_done_already = true,
    ignore_empty_message = true,
  },

  display = {},

  notification = {
    filter = vim.log.levels.WARN,
  },
}
