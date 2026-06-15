-- lua/config/autocmds.lua

local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      require('config.keymaps').on_lsp_attach(event.buf, client)

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
    end,
  })

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  do
    -- [[ Intro to `vim.pack` ]]
    -- `vim.pack` is a new plugin manager built into Neovim,
    --  which provides a Lua interface for installing and managing plugins.
    --
    --  See `:help vim.pack`, `:help vim.pack-examples` or the
    --  excellent blog post from the creator of vim.pack and mini.nvim:
    --  https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack
    --
    --  To inspect plugin state and pending updates, run
    --    :lua vim.pack.update(nil, { offline = true })
    --
    --  To update plugins, run
    --    :lua vim.pack.update()
    --
    --
    --  Throughout the rest of the config there will be examples
    --  of how to install and configure plugins using `vim.pack`.
    --
    --  In this section we set up some autocommands to run build
    --  steps for certain plugins after they are installed or updated.

    local function run_build(name, cmd, cwd)
      local result = vim.system(cmd, { cwd = cwd }):wait()
      if result.code ~= 0 then
        local stderr = result.stderr or ''
        local stdout = result.stdout or ''
        local output = stderr ~= '' and stderr or stdout
        if output == '' then output = 'No output from build command.' end
        vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
      end
    end

    -- This autocommand runs after a plugin is installed or updated and
    --  runs the appropriate build command for that plugin if necessary.
    --
    -- See `:help vim.pack-events`
    vim.api.nvim_create_autocmd('PackChanged', {
      callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind
        if kind ~= 'install' and kind ~= 'update' then return end

        if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
          run_build(name, { 'make' }, ev.data.path)
          return
        end

        if name == 'LuaSnip' then
          if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
          return
        end

        if name == 'nvim-treesitter' then
          if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
          vim.cmd 'TSUpdate'
          return
        end
      end,
    })
  end

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

return M
