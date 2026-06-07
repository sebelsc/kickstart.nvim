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
      local no_dim_filetypes = { markdown = true, text = true, toml = true }
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
  picker = {
    enabled = true,
    focus = 'input',
    layout = {
      preset = 'select',
    },
    formatters = {
      file = {
        filename_first = true,
        truncate = 'left',
      },
    },
    sources = {
      files = {
        hidden = true,
        ignored = false,
        win = {
          input = {
            keys = {
              ['<S-h>'] = 'toggle_hidden',
              ['<S-i>'] = 'toggle_ignored',
              ['<S-f>'] = 'toggle_follow',
              ['<C-y>'] = { 'yazi_copy_relative_path', mode = { 'n', 'i' } },
              -- ['<Esc>'] = { 'close', mode = { 'i', 'n' } },
            },
          },
        },
        exclude = {
          '**/.git/*',
          '**/node_modules',
          '**/.yarn/cache',
          '**/.yarn/install*',
          '**/.yarn/releases/*',
          '**/.pnpm-store/*',
          '**/.idea',
          '**/.DS_Store',
          '**/build',
          'coverage/*',
          '**/dist',
          'hodor-types/*',
          '**/target',
          '**/public/*',
          '**/digest*.txt',
          '**/.node-gyp/**',
          '**/.gradle',
        },
      },
      grep = {
        hidden = true,
        ignored = true,
        win = {
          input = {
            keys = {
              ['<S-h>'] = 'toggle_hidden',
              ['<S-i>'] = 'toggle_ignored',
              ['<S-f>'] = 'toggle_follow',
            },
          },
        },
        exclude = {
          '**/.git/*',
          '**/node_modules',
          '**/.yarn/cache/*',
          '**/.yarn/install*',
          '**/.yarn/releases/*',
          '**/.pnpm-store/*',
          '**/.venv/*',
          '**/.idea/*',
          '**/.DS_Store',
          '**/yarn.lock',
          '**/build',
          'coverage/*',
          'dist/*',
          'certificates/*',
          'hodor-types/*',
          '**/target',
          '**/public/*',
          '**/digest*.txt',
          '**/.node-gyp/**',
        },
      },
      grep_buffers = {},
      explorer = {
        hidden = true,
        ignored = true,
        supports_live = true,
        auto_close = true,
        diagnostics = true,
        diagnostics_open = false,
        focus = 'list',
        follow_file = true,
        git_status = true,
        git_status_open = false,
        git_untracked = true,
        jump = { close = true },
        tree = true,
        watch = true,
        exclude = {
          '.git',
          '.pnpm-store',
          '.venv',
          '.DS_Store',
          '**/.node-gyp/**',
        },
      },
    },
  },
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

-- ============================================================
-- SECTION 4: SEARCH & NAVIGATION
-- Snacks picker replaces Telescope
-- ============================================================
do
  -- Snacks picker is configured in custom/plugins/java.lua (or custom/plugins/init.lua).
  -- Keymaps use the global Snacks object registered by snacks.nvim at startup.

  local map = function(lhs, rhs, desc, mode) vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc }) end

  -- Files & search
  map('<leader>sf', function() Snacks.picker.files() end, '[S]earch [F]iles')
  map('<leader>sg', function() Snacks.picker.grep() end, '[S]earch by [G]rep')
  map('<leader>sw', function() Snacks.picker.grep_word() end, '[S]earch current [W]ord', { 'n', 'v' })
  map('<leader>s/', function() Snacks.picker.grep { buf = true } end, '[S]earch [/] in Open Files')
  map('<leader>/', function() Snacks.picker.lines() end, '[/] Fuzzily search in current buffer')

  -- Neovim meta
  map('<leader>sh', function() Snacks.picker.help() end, '[S]earch [H]elp')
  map('<leader>sk', function() Snacks.picker.keymaps() end, '[S]earch [K]eymaps')
  map('<leader>ss', function() Snacks.picker.pickers() end, '[S]earch [S]elect Picker')
  map('<leader>sc', function() Snacks.picker.commands() end, '[S]earch [C]ommands')
  map('<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, '[S]earch [N]eovim files')

  -- Buffers & recent
  map('<leader><leader>', function() Snacks.picker.buffers() end, '[ ] Find existing buffers')
  map('<leader>s.', function() Snacks.picker.recent() end, '[S]earch Recent Files')
  map('<leader>sr', function() Snacks.picker.resume() end, '[S]earch [R]esume')

  -- Diagnostics
  map('<leader>sd', function() Snacks.picker.diagnostics() end, '[S]earch [D]iagnostics')

  -- LSP pickers — replaces the telescope LspAttach autocmd from kickstart
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('snacks-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      local map_buf = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc }) end
      map_buf('grr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
      map_buf('gri', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
      map_buf('grd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
      map_buf('grt', function() Snacks.picker.lsp_type_definitions() end, '[G]oto [T]ype Definition')
      map_buf('gO', function() Snacks.picker.lsp_symbols() end, 'Open Document Symbols')
      map_buf('gW', function() Snacks.picker.lsp_workspace_symbols() end, 'Open Workspace Symbols')
    end,
  })
end
