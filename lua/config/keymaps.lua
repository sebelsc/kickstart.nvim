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
    vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "down", silent = true, expr = true })
    vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "up", silent = true, expr = true })

    -- Keep visual selection after indent
    vim.keymap.set("x", ">", ">gv", { desc = "indent", silent = true })
    vim.keymap.set("x", "<", "<gv", { desc = "dedent", silent = true })

    -- Yank to end of line  [OVERRIDE: Y=yy in vanilla]
    vim.keymap.set("n", "Y", "y$", { desc = "yank to EOL", silent = true })

    -- Centre screen after jumps
    vim.keymap.set("n", "n", "nzzzv", { desc = "next match (centred)", silent = true })
    vim.keymap.set("n", "N", "Nzzzv", { desc = "prev match (centred)", silent = true })
    vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll down (centred)", silent = true })
    vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll up (centred)", silent = true })

    -- Leave insert without reaching for Escape
    vim.keymap.set("i", "jk", "<Esc>", { desc = "exit insert", silent = true })

    -- Clear search highlight
    vim.keymap.set("n", "<Esc>", "<cmd>noh<CR><Esc>", { desc = "clear hlsearch", silent = true })

    -- Better paste: do not overwrite unnamed register when pasting over selection
    vim.keymap.set("x", "p", '"_dP', { desc = "paste without clobber", silent = true })

    -- Move selected lines up or down
    vim.keymap.set('v', '<S-K>', ":m '<-2<CR>gv=gv", { desc = "move selected line up", silent = true })
    vim.keymap.set('v', '<S-J>', ":m '>+1<CR>gv=gv", { desc = "move selected line down", silent = true })

    -- Add empty line above or below without entering insert mode
    vim.keymap.set('n', '<leader>o', 'o<Esc>', { desc = "open line below", silent = true })
    vim.keymap.set('n', '<leader>O', 'O<Esc>', { desc = "open line above", silent = true })

    -- ── Window management ────────────────────────────────────────────────
    vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "window left", silent = true })
    vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "window down", silent = true })
    vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "window up", silent = true })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "window right", silent = true })

    vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "resize up", silent = true })
    vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "resize down", silent = true })
    vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "resize left", silent = true })
    vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "resize right", silent = true })

    -- ── Buffer (<leader>b) ───────────────────────────────────────────────
    vim.keymap.set("n", "<C-^>", "<C-^>", { desc = "alternate buffer", silent = true })
    vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end,
        { desc = "[B]uffer [D]elete", silent = true })
    vim.keymap.set("n", "<leader>bD", function() Snacks.bufdelete({ wipe = true }) end,
        { desc = "[B]uffer [D]elete (wipe)", silent = true })
    vim.keymap.set("n", "<leader>bo", function() Snacks.bufdelete.other() end,
        { desc = "[B]uffer delete [O]ther", silent = true })
    vim.keymap.set("n", "<leader>bs", function() Snacks.scratch() end,
        { desc = "[B]uffer [S]cratch", silent = true })
    vim.keymap.set("n", "<leader>bS", function() Snacks.scratch.select() end,
        { desc = "[B]uffer [S]elect scratch", silent = true })

    -- ── File (<leader>f) ─────────────────────────────────────────────────
    vim.keymap.set("n", "<leader>fr", function() Snacks.rename.rename_file() end,
        { desc = "[F]ile [R]ename", silent = true })

    -- ── Search / Snacks picker (<leader>s) ───────────────────────────────
    -- Bare shortcuts — quick access without opening the group menu
    vim.keymap.set("n", "<leader><space>", function() Snacks.picker.recent() end,
        { desc = "Recent Files", silent = true })
    vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep", silent = true })
    vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers", silent = true })

    vim.keymap.set("n", "<leader>sf", function() Snacks.picker.smart() end,
        { desc = "[S]earch [F]iles", silent = true })
    vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end,
        { desc = "[S]earch [G]rep", silent = true })
    vim.keymap.set("n", "<leader>sb", function() Snacks.picker.buffers() end,
        { desc = "[S]earch [B]uffers", silent = true })
    vim.keymap.set("n", "<leader>sc", function() Snacks.picker.command_history() end,
        { desc = "[S]earch [C]ommands", silent = true })
    vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end,
        { desc = "[S]earch [K]eymaps", silent = true })
    vim.keymap.set("n", "<leader>se", function() Snacks.picker.explorer() end,
        { desc = "[S]earch [E]xplorer", silent = true })

    -- ── Notify (<leader>n) ───────────────────────────────────────────────
    vim.keymap.set("n", "<leader>nh", function() Snacks.notifier.show_history() end,
        { desc = "[N]otify [H]istory", silent = true })

    -- ── Code (<leader>c) ─────────────────────────────────────────────────
    vim.keymap.set("n", "<leader>cc", function()
        require("treesitter-context").go_to_context(vim.v.count1)
    end, { desc = "[C]ode [C]ontext", silent = true })

    vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float,
        { desc = "[C]ode [D]iagnostic", silent = true })

    vim.keymap.set("n", "<leader>cn", function()
        require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
    end, { desc = "[C]ode [N]ext arg", silent = true })
    vim.keymap.set("n", "<leader>cp", function()
        require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
    end, { desc = "[C]ode [P]rev arg", silent = true })

    -- ── UI toggles (<leader>u) ───────────────────────────────────────────
    local toggle = Snacks.toggle
    toggle.diagnostics():map("<leader>ud", { desc = "[U]I [D]iagnostics" })
    toggle.inlay_hints():map("<leader>ui", { desc = "[U]I [I]nlay hints" })
    toggle.treesitter():map("<leader>ut", { desc = "[U]I [T]reesitter" })
    toggle.option("relativenumber"):map("<leader>ur", { desc = "[U]I [R]elative numbers" })
    toggle.option("wrap"):map("<leader>uw", { desc = "[U]I [W]rap" })
    toggle.option("spell"):map("<leader>us", { desc = "[U]I [S]pell" })
    toggle.diagnostics({ virtual_text = true }):map("<leader>uv", { desc = "[U]I [V]irtual text" })

    -- ── Diagnostic navigation ────────────────────────────────────────────
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
        { desc = "next diagnostic", silent = true })
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
        { desc = "prev diagnostic", silent = true })
    vim.keymap.set("n", "]e", function()
        vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
    end, { desc = "next error", silent = true })
    vim.keymap.set("n", "[e", function()
        vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
    end, { desc = "prev error", silent = true })

    -- ── Test running (<leader>t) ─────────────────────────────────────────
    local nt = require("neotest")

    vim.keymap.set("n", "<leader>tr", function() nt.run.run() end,
        { desc = "[T]est [R]un", silent = true })
    vim.keymap.set("n", "<leader>tf", function() nt.run.run(vim.fn.expand("%")) end,
        { desc = "[T]est [F]ile", silent = true })
    vim.keymap.set("n", "<leader>ta", function() nt.run.run(vim.fn.getcwd()) end,
        { desc = "[T]est [A]ll", silent = true })
    vim.keymap.set("n", "<leader>tl", function() nt.run.run_last() end,
        { desc = "[T]est [L]ast", silent = true })
    vim.keymap.set("n", "<leader>tx", function() nt.run.stop() end,
        { desc = "[T]est [X]stop", silent = true })
    vim.keymap.set("n", "<leader>td", function() nt.run.run({ strategy = "dap" }) end,
        { desc = "[T]est [D]ebug", silent = true })
    vim.keymap.set("n", "<leader>to", function() nt.output.open({ enter = true }) end,
        { desc = "[T]est [O]utput", silent = true })
    vim.keymap.set("n", "<leader>tO", function() nt.output_panel.toggle() end,
        { desc = "[T]est [O]utput panel", silent = true })
    vim.keymap.set("n", "<leader>ts", function() nt.summary.toggle() end,
        { desc = "[T]est [S]ummary", silent = true })
    vim.keymap.set("n", "<leader>tq", function()
        nt.run.run(vim.fn.getcwd())
        vim.cmd("copen")
    end, { desc = "[T]est [Q]uickfix", silent = true })

    vim.keymap.set("n", "]t", function() nt.jump.next({ status = "failed" }) end,
        { desc = "next failed test", silent = true })
    vim.keymap.set("n", "[t", function() nt.jump.prev({ status = "failed" }) end,
        { desc = "prev failed test", silent = true })
end


-- ── LSP keymaps (buffer-local) ───────────────────────────────────────────
-- Called from LspAttach autocmd:
--   require("config.keymaps").on_lsp_attach(ev.buf, client)

function M.on_lsp_attach(bufnr, client)
    -- Navigation                                               [OVERRIDE: gd, gr]
    vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end,
        { desc = "[G]oto [D]efinition", buffer = bufnr, silent = true })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
        { desc = "[G]oto [D]eclaration", buffer = bufnr, silent = true })
    vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end,
        { desc = "[G]oto [I]mplementation", buffer = bufnr, silent = true })
    vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end,
        { desc = "[G]oto [R]eferences", buffer = bufnr, silent = true })
    vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end,
        { desc = "[G]oto [Y]type", buffer = bufnr, silent = true })

    -- Symbols, references, calls (search group)
    vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end,
        { desc = "[S]earch [S]ymbols", buffer = bufnr, silent = true })
    vim.keymap.set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,
        { desc = "[S]earch [S]ymbols workspace", buffer = bufnr, silent = true })
    vim.keymap.set("n", "<leader>sr", function() Snacks.picker.lsp_references() end,
        { desc = "[S]earch [R]eferences", buffer = bufnr, silent = true })
    vim.keymap.set("n", "<leader>si", function() Snacks.picker.lsp_incoming_calls() end,
        { desc = "[S]earch [I]ncoming calls", buffer = bufnr, silent = true })
    vim.keymap.set("n", "<leader>so", function() Snacks.picker.lsp_outgoing_calls() end,
        { desc = "[S]earch [O]utgoing calls", buffer = bufnr, silent = true })

    -- Diagnostics pickers (search group)
    vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics_buffer() end,
        { desc = "[S]earch [D]iagnostics", buffer = bufnr, silent = true })
    vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics() end,
        { desc = "[S]earch [D]iagnostics workspace", buffer = bufnr, silent = true })

    -- Hover / signature                                        [OVERRIDE: K]
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "hover doc", buffer = bufnr, silent = true })
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "signature help", buffer = bufnr, silent = true })
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "signature help", buffer = bufnr, silent = true }) -- [OVERRIDE: digraph]

    -- Actions (code group)
    vim.keymap.set({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action,
        { desc = "[C]ode [A]ction", buffer = bufnr, silent = true })
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename,
        { desc = "[C]ode [R]ename", buffer = bufnr, silent = true })
    vim.keymap.set({ "n", "x" }, "<leader>cf", function() vim.lsp.buf.format({ async = true }) end,
        { desc = "[C]ode [F]ormat", buffer = bufnr, silent = true })

    -- Code lens (code group)
    if client and client.server_capabilities.codeLensProvider then
        vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run,
            { desc = "[C]ode [L]ens", buffer = bufnr, silent = true })
    end
end

-- ── which-key group labels ────────────────────────────────────────────────
local function setup_whichkey()
    local wk = require("which-key")


    wk.add({
        { "<leader>b", group = "[B]uffer" },
        { "<leader>c", group = "[C]ode" },
        { "<leader>f", group = "[F]ile" },
        { "<leader>g", group = "[G]it",   mode = { "n", "v" } },
        { "<leader>n", group = "[N]otify" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>t", group = "[T]est" },
        { "<leader>u", group = "[U]I" },

        { "]",         group = "Next",    mode = { "n", "x", "o" } },
        { "[",         group = "Prev",    mode = { "n", "x", "o" } },

        { "a",         group = "Around",  mode = { "o", "x" } },
        { "i",         group = "Inner",   mode = { "o", "x" } },
    })
end


-- ── Entry point ───────────────────────────────────────────────────────────

function M.setup()
    require("config.keymaps_builtins").setup()
    setup_core()
    require("plugins.mini").setupMiniSurround()
    setup_whichkey()
end

return M
