-- lua/config/keymaps.lua
--
-- Single source of truth for all keymaps.
--
-- Namespace design:
--   <leader>b   buffers
--   <leader>c   code          ← LSP actions, rename, format, codelens, swap args
--   <leader>f   file
--   <leader>g   git           ← gitsigns (see plugins/gitsigns.lua)
--   <leader>n   notify
--   <leader>s   search        ← all Snacks.picker
--   <leader>t   tests
--   <leader>u   ui toggles    ← Snacks.toggle
--
--   g{d,D,i,r,y}   lsp navigation   (shadows: gd=local-decl, gr=virt-replace)
--   K              lsp hover         (shadows: K=man-page)
--   gK             lsp signature
--   ]d [d          next/prev diagnostic
--   ]e [e          next/prev error
--   ]h [h          next/prev git hunk   (gitsigns.lua)
--   ]t [t          next/prev failed test
--   ]f [f          next/prev function
--   ]c [c          next/prev class
--   ]a [a          next/prev argument
--   ;  ,           extend f/t AND treesitter-textobjects repeats (additive)
--
-- Intentional default overrides are marked with -- [OVERRIDE].

local M = {}

-- ── Better defaults ──────────────────────────────────────────────────────

local function setup_core()
  -- Move by display lines when wrap is on
  vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'down', silent = true, expr = true })
  vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'up', silent = true, expr = true })

  -- Keep visual selection after indent
  vim.keymap.set('x', '>', '>gv', { desc = 'indent', silent = true })
  vim.keymap.set('x', '<', '<gv', { desc = 'dedent', silent = true })

  -- Yank to end of line  [OVERRIDE: Y=yy in vanilla]
  vim.keymap.set('n', 'Y', 'y$', { desc = 'yank to EOL', silent = true })

  -- Centre screen after jumps
  vim.keymap.set('n', 'n', 'nzzzv', { desc = 'next match (centred)', silent = true })
  vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'prev match (centred)', silent = true })
  vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'scroll down (centred)', silent = true })
  vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'scroll up (centred)', silent = true })

  -- Leave insert without reaching for Escape
  vim.keymap.set('i', 'jk', '<Esc>', { desc = 'exit insert', silent = true })

  -- Clear search highlight
  vim.keymap.set('n', '<Esc>', '<cmd>noh<CR><Esc>', { desc = 'clear hlsearch', silent = true })

  -- Better paste: do not overwrite unnamed register when pasting over selection
  for _, op in ipairs { 'd', 'D', 'c', 'C', 'x', 'X' } do
    vim.keymap.set({ 'n', 'x' }, op, ('"d%s'):format(op), { silent = true })
  end

  vim.keymap.set('x', 'p', '"_dP', { desc = 'paste without clobber', silent = true })
  vim.keymap.set('x', 'P', '"_dP', {})
  vim.keymap.set('n', '<leader>rs', function() Snacks.picker.registers() end, { desc = '[r]egisters [s]how', silent = true })
  vim.keymap.set('n', '<leader>rp', '"dp', { desc = '[r]egister [p]aste (delete register)' })
  vim.keymap.set('n', '<leader>rP', '"dP', { desc = '[r]egister [P]aste (delete register)' })
  -- Move selected lines up or down
  vim.keymap.set('v', '<S-K>', ":m '<-2<CR>gv=gv", { desc = 'move selected line up', silent = true })
  vim.keymap.set('v', '<S-J>', ":m '>+1<CR>gv=gv", { desc = 'move selected line down', silent = true })

  -- Add empty line above or below without entering insert mode
  vim.keymap.set('n', '<leader>o', 'o<Esc>', { desc = 'open line below', silent = true })
  vim.keymap.set('n', '<leader>O', 'O<Esc>', { desc = 'open line above', silent = true })

  -- ── Window management ────────────────────────────────────────────────
  vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'window left', silent = true })
  vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'window down', silent = true })
  vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'window up', silent = true })
  vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'window right', silent = true })

  vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<CR>', { desc = 'resize up', silent = true })
  vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<CR>', { desc = 'resize down', silent = true })
  vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<CR>', { desc = 'resize left', silent = true })
  vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<CR>', { desc = 'resize right', silent = true })

  -- ── Buffer (<leader>b) ───────────────────────────────────────────────
  vim.keymap.set('n', '<C-^>', '<C-^>', { desc = 'alternate buffer', silent = true })
  vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = '[b]uffer [d]elete', silent = true })
  vim.keymap.set('n', '<leader>bD', function() Snacks.bufdelete { wipe = true } end, { desc = '[b]uffer [D]elete (wipe)', silent = true })
  vim.keymap.set('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = '[b]uffer delete []ther', silent = true })
  vim.keymap.set('n', '<leader>bs', function() Snacks.scratch() end, { desc = '[b]uffer [s]cratch', silent = true })
  vim.keymap.set('n', '<leader>bS', function() Snacks.scratch.select() end, { desc = '[b]uffer [S]elect scratch', silent = true })

  -- ── File (<leader>f) ─────────────────────────────────────────────────
  vim.keymap.set('n', '<leader>fr', function() Snacks.rename.rename_file() end, { desc = '[f]ile [r]ename', silent = true })

  -- ── Search / Snacks picker (<leader>s) ───────────────────────────────
  -- Bare shortcuts — quick access without opening the group menu
  vim.keymap.set('n', '<leader><space>', function() Snacks.picker.smart() end, { desc = 'Recent Files', silent = true })
  vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Grep', silent = true })
  vim.keymap.set('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = 'Buffers', silent = true })

  vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end, { desc = '[s]earch [f]iles', silent = true })
  vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = '[s]earch [g]rep', silent = true })
  vim.keymap.set('n', '<leader>sb', function() Snacks.picker.buffers() end, { desc = '[s]earch [b]uffers', silent = true })
  vim.keymap.set('n', '<leader>sc', function() Snacks.picker.command_history() end, { desc = '[s]earch [c]ommands', silent = true })
  vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[s]earch [k]eymaps', silent = true })
  vim.keymap.set('n', '<leader>se', function() Snacks.picker.explorer() end, { desc = '[s]earch [e]xplorer', silent = true })
  vim.keymap.set('n', '<leader>st', function() Snacks.terminal.list() end, { desc = '[s]earch [t]erminal', silent = true })
  -- ── Notify (<leader>n) ───────────────────────────────────────────────

  -- ── Code (<leader>c) ─────────────────────────────────────────────────
  vim.keymap.set('n', '<leader>cc', function() require('treesitter-context').go_to_context(vim.v.count1) end, { desc = '[c]ode [c]ontext', silent = true })

  vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = '[c]ode [d]iagnostic', silent = true })

  vim.keymap.set(
    'n',
    '<leader>cn',
    function() require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner' end,
    { desc = '[C]ode [N]ext arg', silent = true }
  )
  vim.keymap.set(
    'n',
    '<leader>cp',
    function() require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner' end,
    { desc = '[C]ode [P]rev arg', silent = true }
  )
  vim.keymap.set('n', '<leader>cq', function() Snacks.picker.qflist() end, { desc = '[c]ode [q]uickfix', silent = true })

  -- ── Inspect (<leader>i) ───────────────────────────────────────────

  vim.keymap.set('n', '<leader>ig', function()
    local pos = vim.inspect_pos()
    local lines = {}

    if #pos.semantic_tokens > 0 then
      table.insert(lines, 'LSP:')
      for _, t in ipairs(pos.semantic_tokens) do
        if t.hl_groups then
          for _, g in ipairs(t.hl_groups) do
            table.insert(lines, '  ' .. g)
          end
        elseif t.hl_group then
          table.insert(lines, '  ' .. t.hl_group)
        end
      end
    end

    if #pos.treesitter > 0 then
      table.insert(lines, 'Treesitter:')
      for _, t in ipairs(pos.treesitter) do
        table.insert(lines, '  ' .. t.capture .. ' → ' .. t.hl_group)
      end
    end

    if #pos.extmarks > 0 then
      table.insert(lines, 'Extmarks:')
      for _, e in ipairs(pos.extmarks) do
        if e.hl_group then table.insert(lines, '  ' .. e.hl_group) end
      end
    end

    Snacks.notify(table.concat(lines, '\n'), { title = 'Inspect', timeout = 30000 })
  end, { desc = 'Inspect highlights' })

  -- ── Git (<leader>g) ───────────────────────────────────────────
  vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit() end, { desc = '[g]it [l]azy', silent = true })
  vim.keymap.set('n', '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = '[g]it log [f]ile', silent = true })
  vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status() end, { desc = '[g]it [s]tatus', silent = true })
  vim.keymap.set('n', '<leader>gdd', function() Snacks.picker.git_diff() end, { desc = '[g]it [d]iff', silent = true })
  -- Diff current file vs index (unstaged changes)
  vim.keymap.set('n', '<leader>gdD', '<cmd>DiffviewOpen -- %<CR>', { desc = 'Diff file vs index' })
  -- Diff current file vs origin/main (changes since branching)
  -- vim.keymap.set('n', '<leader>gdd', '<cmd>DiffviewOpen origin/main...HEAD -- %<CR>', { desc = 'Diff file vs main' })
  -- File history for current file
  vim.keymap.set('n', '<leader>gdh', '<cmd>DiffviewFileHistory %<CR>', { desc = 'File history' })
  -- Full repo history
  vim.keymap.set('n', '<leader>gdH', '<cmd>DiffviewFileHistory<CR>', { desc = 'Repo history' })
  -- Close
  vim.keymap.set('n', '<leader>gdq', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview' })

  -- ── UI (<leader>u) ───────────────────────────────────────────
  local toggle = Snacks.toggle
  toggle.diagnostics():map('<leader>utd', { desc = '[u]i [t]oggle [d]iagnostics' })
  toggle.inlay_hints():map('<leader>uti', { desc = '[u]i [t]oggle [i]nlay hints' })
  -- toggle.treesitter():map('<leader>utt', { desc = '[u]i [t]oggle [t]reesitter' })
  -- toggle.option('relativenumber'):map('<leader>utr', { desc = '[u]i [t]oggle [r]elative numbers' })
  toggle.option('wrap'):map('<leader>utw', { desc = '[u]i [t]oggle [w]rap' })
  -- toggle.option('spell'):map('<leader>uts', { desc = '[u]i [t]oggle [s]pell' })
  toggle.diagnostics({ virtual_text = true }):map('<leader>utv', { desc = '[u]i [t]oggle [v]irtual text' })
  vim.keymap.set('n', '<leader>uso', function() Snacks.terminal() end, { desc = '[u]i [s]hell [o]pen', silent = true })
  vim.keymap.set('t', '<C-t>', function() Snacks.terminal() end) -- toggle from terminal mode too
  vim.keymap.set('n', '<leader>unh', function() Snacks.notifier.show_history() end, { desc = '[u]i [n]otification [h]istory', silent = true })

  -- ── UI-Undo (<leader>uu) ───────────────────────────────────────────
  vim.keymap.set('n', '<leader>uu', require('undotree').toggle, { desc = '[u]i [u]ndotree (toggle)', noremap = true, silent = true })

  -- ── Jumps (<leader>j) ───────────────────────────────────────────
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader>jj', function() require('flash').jump() end, { desc = '[j]ump', silent = true })
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader>jJ', function() require('flash').treesitter() end, { desc = 'Flash Treesitter', silent = true })

  -- ── Diagnostic navigation ────────────────────────────────────────────
  vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1, float = true } end, { desc = 'next diagnostic', silent = true })
  vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1, float = true } end, { desc = 'prev diagnostic', silent = true })
  vim.keymap.set(
    'n',
    ']e',
    function() vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true } end,
    { desc = 'next error', silent = true }
  )
  vim.keymap.set(
    'n',
    '[e',
    function() vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true } end,
    { desc = 'prev error', silent = true }
  )

  -- ── Test running (<leader>t) ─────────────────────────────────────────
  local nt = require 'neotest'

  vim.keymap.set('n', '<leader>tr', function() nt.run.run() end, { desc = '[t]est [r]un', silent = true })
  vim.keymap.set('n', '<leader>tf', function() nt.run.run(vim.fn.expand '%') end, { desc = '[t]est [f]ile', silent = true })
  vim.keymap.set('n', '<leader>ta', function() nt.run.run(vim.fn.getcwd()) end, { desc = '[t]est [a]ll', silent = true })
  vim.keymap.set('n', '<leader>tl', function() nt.run.run_last() end, { desc = '[t]est [l]ast', silent = true })
  vim.keymap.set('n', '<leader>tx', function() nt.run.stop() end, { desc = '[t]est [x]stop', silent = true })
  vim.keymap.set('n', '<leader>td', function() nt.run.run { strategy = 'dap' } end, { desc = '[t]est [d]ebug', silent = true })
  vim.keymap.set('n', '<leader>to', function() nt.output.open { enter = true } end, { desc = '[t]est [o]utput', silent = true })
  vim.keymap.set('n', '<leader>tO', function() nt.output_panel.toggle() end, { desc = '[t]est [O]utput panel', silent = true })
  vim.keymap.set('n', '<leader>ts', function() nt.summary.toggle() end, { desc = '[t]est [s]ummary', silent = true })
  vim.keymap.set('n', '<leader>tq', function()
    nt.run.run(vim.fn.getcwd())
    vim.cmd 'copen'
  end, { desc = '[t]est [q]uickfix', silent = true })

  vim.keymap.set('n', ']t', function() nt.jump.next { status = 'failed' } end, { desc = 'next failed test', silent = true })
  vim.keymap.set('n', '[t', function() nt.jump.prev { status = 'failed' } end, { desc = 'prev failed test', silent = true })

  vim.keymap.set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end, { desc = 'Next Word Reference' })
  vim.keymap.set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end, { desc = 'Prev Word Reference' })

  -- Buffers <leader>b
  -- bufdelete: replace :bd bindings with window-safe versions
  vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = '[b]uffer [d]elete' })
  vim.keymap.set('n', '<leader>bW', function() Snacks.bufdelete { wipe = true } end, { desc = '[b]uffer [W]ipe' })
  vim.keymap.set('n', '<leader>bO', function() Snacks.bufdelete.other() end, { desc = '[b]uffer delete [O]thers' })

  -- rename: LSP-aware file rename — updates all import references via
  -- workspace/willRenameFiles, which jdtls supports.
  -- Run this instead of shelling out to mv or using the OS file manager.
  vim.keymap.set('n', '<leader>fr', function() Snacks.rename.rename_file() end, { desc = '[f]ile [r]ename (lsp)' })

  -- scratch
  vim.keymap.set('n', '<leader>bs', function() Snacks.scratch() end, { desc = '[b]uffer [s]cratch' })
  vim.keymap.set('n', '<leader>bS', function() Snacks.scratch.select() end, { desc = '[b]uffer [S]elect scratch' })

  -- notifier history (useful to review missed jdtls build messages)
  vim.keymap.set('n', '<leader>nh', function() Snacks.notifier.show_history() end, { desc = '[n]otification [h]istory' })

  -- Terminal <leader>t
  -- In your keymaps or snacks config
end

-- ── LSP keymaps (buffer-local) ───────────────────────────────────────────
-- Called from LspAttach autocmd:
--   require("config.keymaps").on_lsp_attach(ev.buf, client)

function M.on_lsp_attach(bufnr, client)
  -- Navigation                                               [OVERRIDE: gd, gr]
  vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = '[g]oto [d]efinition', buffer = bufnr, silent = true })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[g]oto [D]eclaration', buffer = bufnr, silent = true })
  vim.keymap.set('n', 'gi', function() Snacks.picker.lsp_implementations() end, { desc = '[g]oto [i]mplementation', buffer = bufnr, silent = true })
  vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = '[g]oto [r]eferences', buffer = bufnr, silent = true })
  vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = '[g]oto t[y]pe', buffer = bufnr, silent = true })

  -- Symbols, references, calls (search group)
  vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = '[s]earch [s]ymbols', buffer = bufnr, silent = true })
  vim.keymap.set(
    'n',
    '<leader>sS',
    function() Snacks.picker.lsp_workspace_symbols() end,
    { desc = '[s]earch [S]ymbols workspace', buffer = bufnr, silent = true }
  )
  vim.keymap.set('n', '<leader>sr', function() Snacks.picker.lsp_references() end, { desc = '[s]earch [r]eferences', buffer = bufnr, silent = true })
  vim.keymap.set('n', '<leader>si', function() Snacks.picker.lsp_incoming_calls() end, { desc = '[s]earch [i]ncoming calls', buffer = bufnr, silent = true })
  vim.keymap.set('n', '<leader>so', function() Snacks.picker.lsp_outgoing_calls() end, { desc = '[s]earch [o]utgoing calls', buffer = bufnr, silent = true })

  -- Diagnostics pickers (search group)
  vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics_buffer() end, { desc = '[s]earch [d]iagnostics', buffer = bufnr, silent = true })
  vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics() end, { desc = '[s]earch [D]iagnostics workspace', buffer = bufnr, silent = true })

  -- Hover / signature                                        [OVERRIDE: K]
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'hover doc', buffer = bufnr, silent = true })
  vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, { desc = 'signature help', buffer = bufnr, silent = true })
  vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'signature help', buffer = bufnr, silent = true }) -- [OVERRIDE: digraph]

  -- Actions (code group)
  vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = '[c]ode [a]ction', buffer = bufnr, silent = true })
  vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = '[c]ode [r]ename', buffer = bufnr, silent = true })
  vim.keymap.set(
    { 'n', 'x', 'v' },
    '<leader>cf',
    function() require('conform').format { async = true } end,
    { desc = '[c]ode [f]ormat', buffer = bufnr, silent = true }
  )

  vim.keymap.set('n', ']w', function() Snacks.words.jump(1, true) end)
  vim.keymap.set('n', '[w', function() Snacks.words.jump(-1, true) end)

  -- Code lens (code group)
  if client and client.server_capabilities.codeLensProvider then
    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { desc = '[c]ode [l]ens', buffer = bufnr, silent = true })
  end
end

-- ── which-key group labels ────────────────────────────────────────────────
local function setup_whichkey()
  local wk = require 'which-key'

  wk.add {
    { '<leader>b', group = '[b]uffer' },
    { '<leader>c', group = '[c]ode' },
    { '<leader>f', group = '[f]ile' },
    { '<leader>g', group = '[g]it', mode = { 'n', 'v' } },
    { '<leader>gd', group = '[g]it [d]iffview', mode = { 'n' } },
    { '<leader>i', group = '[i]nspect', mode = { 'n' } },
    { '<leader>j', group = '[j]ump', mode = { 'n', 'v' } },
    { '<leader>p', group = '[p]aste', mode = { 'n' } },
    { '<leader>s', group = '[s]earch' },
    { '<leader>t', group = '[t]est' },
    { '<leader>u', group = '[u]i' },
    { '<leader>ut', group = '[u]i [t]oggle' },

    { ']', group = 'Next', mode = { 'n', 'x', 'o' } },
    { '[', group = 'Prev', mode = { 'n', 'x', 'o' } },

    { 'a', group = 'Around', mode = { 'o', 'x' } },
    { 'i', group = 'Inner', mode = { 'o', 'x' } },
  }
end

-- ── Entry point ───────────────────────────────────────────────────────────

function M.setup()
  -- require("config.keymaps_builtins").setup()
  setup_core()
  require('plugins.mini').setupMiniSurround()
  setup_whichkey()
end

return M
