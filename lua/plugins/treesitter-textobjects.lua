-- ── nvim-treesitter-textobjects ───────────────────────────────────────
-- The textobjects plugin has its own setup call, separate from treesitter.
-- Keymaps for select are now set via direct vim.keymap.set calls using
-- the module's API, not in the setup table.

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        -- selection_modes per capture: v=charwise, V=linewise, <C-v>=blockwise
        selection_modes = {
            ["@function.outer"]  = "V",
            ["@class.outer"]     = "V",
            ["@parameter.outer"] = "v",
        },
    },
    move = {
        set_jumps = true,
    },
    swap = {
        -- swap keymaps wired below
    },
})

-- Text object keymaps (operator-pending + visual)
local sel = require("nvim-treesitter-textobjects.select")
local function tmap(lhs, query, desc)
    vim.keymap.set({ "x", "o" }, lhs, function()
        sel.select_textobject(query, "textobjects")
    end, { desc = desc })
end

tmap("af", "@function.outer", "around function")
tmap("if", "@function.inner", "function body")
tmap("ac", "@class.outer", "around class")
tmap("ic", "@class.inner", "class body")
tmap("aa", "@parameter.outer", "around argument")
tmap("ia", "@parameter.inner", "argument")
tmap("ai", "@conditional.outer", "around conditional")
tmap("ii", "@conditional.inner", "conditional body")
tmap("al", "@loop.outer", "around loop")
tmap("il", "@loop.inner", "loop body")
tmap("ak", "@call.outer", "around call")
tmap("ik", "@call.inner", "call arguments")

-- Move keymaps
local move = require("nvim-treesitter-textobjects.move")
local function mmap(lhs, query, dir, desc)
    vim.keymap.set({ "n", "x", "o" }, lhs, function()
        move.goto_next_start(query, "textobjects")
    end, { desc = desc })
end

vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end,
    { desc = "next function start" })
vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end,
    { desc = "next function end" })
vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end,
    { desc = "next class start" })
vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end,
    { desc = "next argument" })
vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end,
    { desc = "prev function start" })
vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end,
    { desc = "prev function end" })
vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end,
    { desc = "prev class start" })
vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end,
    { desc = "prev argument" })

-- Swap keymaps are defined in config/keymaps.lua (<leader>cn / <leader>cp)
