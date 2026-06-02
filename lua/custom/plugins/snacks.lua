vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  -- Each key is a module; set enabled = true to activate it.
  -- All others default to disabled.
  animate = {},
  dim = {
    enbaled = true,
    scope = {
      treesitter = {
        blocks = {
          enabled = true,
          'function_declaration',
          'function_definition',
          'method_declaration',
          'method_definition',
        },
      },
    },
    filter = function(buf)
      local no_dim_filetypes = { markdown = true, text = true }
      return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == '' and not no_dim_filetypes[vim.bo[buf].filetype]
    end,
  },
  git = { enbaled = true },
  gitbrows = { enabled = true },
  indent = { enabled = true }, -- indent guides
  input = { enabled = true }, -- better vim.ui.input (used by LSP rename etc.)
  notifier = { enabled = true }, -- better vim.notify with history
  quickfile = { enabled = true }, -- faster rendering for small files
  lazygit = { enabled = true },
  keymap = { enbaled = true },
  rename = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true }, -- smooth scrolling
  statuscolumn = { enabled = true }, -- better sign/fold column
  words = { enabled = true }, -- highlight word under cursor + navigate with ]] / [[
  zen = { enabled = true },
}

-- Enable Dim globally when UI is ready
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function() Snacks.dim.enable() end,
})

-- Notifier configuration for LSP Progress events
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not client or type(value) ~= 'table' then return end

    local p = progress[client.id]
    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end

    local msg = {}
    progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)

    local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    vim.notify(table.concat(msg, '\n'), 'info', {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif) notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] end,
    })
  end,
})

vim.keymap.set('n', '<leader>nh', function() Snacks.notifier.show_history() end, { desc = 'Notification history' })
