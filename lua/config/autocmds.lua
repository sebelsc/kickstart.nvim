-- lua/config/autocmds.lua

local M = {}

function M.setup()
  -- Suppress window/showMessage noise while a client is still busy (indexing,
  -- resolving classpath, etc.); only forward WARN/ERROR once it's settled.
  -- LSP progress itself is rendered by fidget.nvim, not vim.notify.
  -- local lsp_busy = {} ---@type table<integer, integer>
  --
  -- vim.api.nvim_create_autocmd('LspProgress', {
  --   group = vim.api.nvim_create_augroup('lsp-progress-busy', { clear = true }),
  --   ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  --   callback = function(ev)
  --     local id, kind = ev.data.client_id, ev.data.params.value.kind
  --     if kind == 'begin' then
  --       lsp_busy[id] = (lsp_busy[id] or 0) + 1
  --     elseif kind == 'end' then
  --       lsp_busy[id] = math.max((lsp_busy[id] or 1) - 1, 0)
  --     end
  --   end,
  -- })
  --
  -- vim.lsp.handlers['window/showMessage'] = function(_, params, ctx)
  --   local level = ({
  --     [vim.lsp.protocol.MessageType.Error] = vim.log.levels.ERROR,
  --     [vim.lsp.protocol.MessageType.Warning] = vim.log.levels.WARN,
  --     [vim.lsp.protocol.MessageType.Info] = vim.log.levels.INFO,
  --     [vim.lsp.protocol.MessageType.Log] = vim.log.levels.DEBUG,
  --   })[params.type] or vim.log.levels.INFO
  --
  --   local busy = (lsp_busy[ctx.client_id] or 0) > 0
  --   if not busy and level < vim.log.levels.WARN then return end
  --   local client = vim.lsp.get_client_by_id(ctx.client_id)
  --   vim.notify(('LSP[%s] %s'):format(client and client.name or ctx.client_id, params.message), level)
  -- end
  --
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      require('config.keymaps').on_lsp_attach(event.buf, client)
    end,
  })

  -- Highlight when yanking (copying) text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function(args) vim.lsp.semantic_tokens.enable(false, { bufnr = args.buf }) end,
  })

  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function(args) vim.lsp.semantic_tokens.enable(true, { bufnr = args.buf }) end,
  })
  -- vim.api.nvim_create_autocmd('lspattach', {
  --   group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  --   callback = function(event)
  --     -- note: remember that lua is a real programming language, and as such it is possible
  --     -- to define small helper and utility functions so you don't have to repeat yourself.
  --     --
  --
  --     -- the following two autocommands are used to highlight references of the
  --     -- word under your cursor when your cursor rests there for a little while.
  --     --    see `:help cursorhold` for information about when this is executed
  --     --
  --     -- when you move your cursor, the highlights will be cleared (the second autocommand).
  --     local client = vim.lsp.get_client_by_id(event.data.client_id)
  --     require('config.keymaps').on_lsp_attach(event.buf, client)
  --
  --     -- notifier configuration for lsp progress events
  --     ---@type table<number, {token:lsp.progresstoken, msg:string, done:boolean}[]>
  --     local progress = vim.defaulttable()
  --     vim.api.nvim_create_autocmd('lspprogress', {
  --       ---@param ev {data: {client_id: integer, params: lsp.progressparams}}
  --       callback = function(ev)
  --         local client = vim.lsp.get_client_by_id(ev.data.client_id)
  --         local value = ev.data.params.value
  --         if not client or type(value) ~= 'table' then return end
  --
  --         local p = progress[client.id]
  --         for i = 1, #p + 1 do
  --           if i == #p + 1 or p[i].token == ev.data.params.token then
  --             p[i] = {
  --               token = ev.data.params.token,
  --               msg = ('[%3d%%] %s%s'):format(
  --                 value.kind == 'end' and 100 or value.percentage or 100,
  --                 value.title or '',
  --                 value.message and (' **%s**'):format(value.message) or ''
  --               ),
  --               done = value.kind == 'end',
  --             }
  --             break
  --           end
  --         end
  --
  --         local msg = {}
  --         progress[client.id] = vim.tbl_filter(function(v) return table.insert(msg, v.msg) or not v.done end, p)
  --
  --         local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  --         vim.notify(table.concat(msg, '\n'), 'info', {
  --           id = 'lsp_progress',
  --           title = client.name,
  --           opts = function(notif) notif.icon = #progress[client.id] == 0 and ' ' or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1] end,
  --         })
  --       end,
  --     })
  --   end,
  -- })
  --
  -- -- highlight when yanking (copying) text
  -- --  try it with `yap` in normal mode
  -- --  see `:help vim.hl.on_yank()`
  -- vim.api.nvim_create_autocmd('textyankpost', {
  --   desc = 'highlight when yanking (copying) text',
  --   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  --   callback = function() vim.hl.on_yank() end,
  -- })
  --
  do
    -- [[ intro to `vim.pack` ]]
    -- `vim.pack` is a new plugin manager built into neovim,
    --  which provides a lua interface for installing and managing plugins.
    --
    --  see `:help vim.pack`, `:help vim.pack-examples` or the
    --  excellent blog post from the creator of vim.pack and mini.nvim:
    --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
    --
    --  to inspect plugin state and pending updates, run
    --    :lua vim.pack.update(nil, { offline = true })
    --
    --  to update plugins, run
    --    :lua vim.pack.update()
    --
    --
    --  throughout the rest of the config there will be examples
    --  of how to install and configure plugins using `vim.pack`.
    --
    --  in this section we set up some autocommands to run build
    --  steps for certain plugins after they are installed or updated.

    local function run_build(name, cmd, cwd)
      local result = vim.system(cmd, { cwd = cwd }):wait()
      if result.code ~= 0 then
        local stderr = result.stderr or ''
        local stdout = result.stdout or ''
        local output = stderr ~= '' and stderr or stdout
        if output == '' then output = 'no output from build command.' end
        vim.notify(('build failed for %s:\n%s'):format(name, output), vim.log.levels.error)
      end
    end

    -- this autocommand runs after a plugin is installed or updated and
    --  runs the appropriate build command for that plugin if necessary.
    --
    -- see `:help vim.pack-events`
    vim.api.nvim_create_autocmd('packchanged', {
      callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind
        if kind ~= 'install' and kind ~= 'update' then return end

        if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
          run_build(name, { 'make' }, ev.data.path)
          return
        end

        if name == 'luasnip' then
          if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
          return
        end

        if name == 'nvim-treesitter' then
          if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
          vim.cmd 'tsupdate'
          return
        end
      end,
    })
  end

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- enable treesitter based folds
    -- for more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('filetype', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- if a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })

  -- configure auto-read for files on specific events.
  vim.api.nvim_create_autocmd({ 'focusgained', 'bufenter', 'cursorhold', 'cursorholdi' }, {
    command = "if mode() != 'c' | checktime | endif",
  })
end

return M
