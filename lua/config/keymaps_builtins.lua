-- lua/config/keymaps_builtins.lua
--
-- Adds descriptions for Neovim built-in commands to which-key.
-- No keymaps are created here — these are annotations only.
--
-- Visibility:
--   POPUP    keys under a prefix (g, z, <C-w>, ], [) appear in the
--            which-key popup when you pause after the prefix.
--   SEARCH   single-key commands appear only via :WhichKey or
--            Snacks.picker.keymaps() — useful as a reference dictionary.
--
-- Keys overridden in keymaps.lua are documented with their new meaning.

local M = {}

function M.setup()
    local wk = require("which-key")

    -- ── Operators — SEARCH only (execute immediately, no popup) ────────────
    wk.add({
        mode = { "n", "x" },
        { "d", desc = "delete (operator)" },
        { "c", desc = "change (operator) → insert" },
        { "y", desc = "yank (operator)" },
        { ">", desc = "indent right (operator)" },
        { "<", desc = "indent left (operator)" },
        { "=", desc = "auto-indent (operator)" },
        { "!", desc = "filter through shell (operator)" },
    })

    -- ── Normal-mode commands — SEARCH only ─────────────────────────────────
    wk.add({
        mode = "n",
        -- Edit
        { "u",     desc = "undo" },
        { "<C-r>", desc = "redo" },
        { ".",     desc = "repeat last change" },
        { "J",     desc = "join line below" },
        { "~",     desc = "toggle case at cursor" },
        { "x",     desc = "delete char forward" },
        { "X",     desc = "delete char backward" },
        { "r",     desc = "replace single char" },
        { "R",     desc = "replace mode" },
        { "s",     desc = "substitute char (delete + insert)" },
        { "S",     desc = "substitute line (delete + insert)" },
        { "<C-a>", desc = "increment number" },
        { "<C-x>", desc = "decrement number" },
        -- Paste
        { "p",     desc = "paste after" },
        { "P",     desc = "paste before" },
        -- Yank / delete shortcuts
        { "Y",     desc = "yank to end of line (→ y$)" },   -- our override
        { "yy",    desc = "yank line" },
        { "dd",    desc = "delete line" },
        { "D",     desc = "delete to end of line (→ d$)" },
        { "cc",    desc = "change line" },
        { "C",     desc = "change to end of line (→ c$)" },
        -- Insert-mode entry
        { "i",     desc = "insert before cursor" },
        { "a",     desc = "insert after cursor" },
        { "I",     desc = "insert at line start" },
        { "A",     desc = "insert at line end" },
        { "o",     desc = "open line below" },
        { "O",     desc = "open line above" },
        -- Visual
        { "v",     desc = "visual char mode" },
        { "V",     desc = "visual line mode" },
        { "<C-v>", desc = "visual block mode" },
        -- Macros
        { "q",     desc = "record macro into register" },
        { "@",     desc = "replay macro from register" },
        { "@@",    desc = "replay last macro" },
        -- Marks
        { "m",     desc = "set mark" },
        { "'",     desc = "jump to mark line" },
        { "`",     desc = "jump to mark position" },
        -- Jumps / history
        { "<C-o>", desc = "jumplist: older position" },
        { "<C-i>", desc = "jumplist: newer position" },
        { "<C-^>", desc = "alternate buffer" },
        -- Search
        { "n",     desc = "next search match (centred)" },   -- our override
        { "N",     desc = "prev search match (centred)" },   -- our override
        { "*",     desc = "search word under cursor →" },
        { "#",     desc = "search word under cursor ←" },
        { "/",     desc = "search forward" },
        { "?",     desc = "search backward" },
        -- Scroll
        { "<C-f>", desc = "page down" },
        { "<C-b>", desc = "page up" },
        { "<C-d>", desc = "half page down (centred)" },      -- our override
        { "<C-u>", desc = "half page up (centred)" },        -- our override
        { "<C-e>", desc = "scroll down one line" },
        { "<C-y>", desc = "scroll up one line" },
        -- Folds (shortcut forms)
        { "zo",    desc = "open fold" },
        { "zc",    desc = "close fold" },
        { "za",    desc = "toggle fold" },
        -- Quit / write shortcuts
        { "ZZ",    desc = "save and quit" },
        { "ZQ",    desc = "quit without saving" },
    })

    -- ── Motions — SEARCH only ───────────────────────────────────────────────
    wk.add({
        mode = { "n", "x", "o" },
        -- Word
        { "w", desc = "word start →" },
        { "W", desc = "WORD start →" },
        { "b", desc = "word start ←" },
        { "B", desc = "WORD start ←" },
        { "e", desc = "word end → (inclusive)" },
        { "E", desc = "WORD end → (inclusive)" },
        -- Line
        { "0", desc = "line start (col 0)" },
        { "^", desc = "line first non-blank" },
        { "$", desc = "line end (inclusive)" },
        { "_", desc = "first non-blank (count-1 lines down)" },
        -- File
        { "gg", desc = "file start" },
        { "G",  desc = "file end (or line N with count)" },
        { "H",  desc = "screen top" },
        { "M",  desc = "screen middle" },
        { "L",  desc = "screen bottom" },
        -- Find on line
        { "f", desc = "find char → (inclusive)" },
        { "F", desc = "find char ← (inclusive)" },
        { "t", desc = "till char → (exclusive)" },
        { "T", desc = "till char ← (exclusive)" },
        { ";", desc = "repeat f/t/]f/]c → (extended by treesitter)" },
        { ",", desc = "repeat f/t/]f/]c ← (extended by treesitter)" },
        -- Paragraph / sentence
        { "}", desc = "paragraph end →" },
        { "{", desc = "paragraph start ←" },
        { ")", desc = "sentence end →" },
        { "(", desc = "sentence start ←" },
        -- Bracket
        { "%", desc = "matching bracket (inclusive)" },
    })

    -- ── g prefix — POPUP ────────────────────────────────────────────────────
    wk.add({
        -- LSP navigation (overridden — descriptions match keymaps.lua mnemonics)
        { "gd", desc = "[G]oto [D]efinition",    mode = "n" },
        { "gD", desc = "[G]oto [D]eclaration",   mode = "n" },
        { "gi", desc = "[G]oto [I]mplementation", mode = "n" },
        { "gr", desc = "[G]oto [R]eferences",    mode = "n" },
        { "gy", desc = "[G]oto [Y]type",         mode = "n" },
        { "gK", desc = "signature help",          mode = "n" },
        -- File navigation
        { "gf", desc = "[G]oto [F]ile under cursor", mode = "n" },
        -- Visual
        { "gv", desc = "reselect last visual",       mode = "n" },
        { "ga", desc = "char info (ascii/hex/name)",  mode = "n" },
        -- Display-line movement (relevant when wrap=true)
        { "gj", desc = "display line down",           mode = { "n", "x" } },
        { "gk", desc = "display line up",             mode = { "n", "x" } },
        { "g0", desc = "display line start",          mode = { "n", "x" } },
        { "g^", desc = "display line first non-blank", mode = { "n", "x" } },
        { "g$", desc = "display line end",            mode = { "n", "x" } },
        -- Word movement
        { "ge", desc = "word end ← (inclusive)",     mode = { "n", "x", "o" } },
        { "gE", desc = "WORD end ← (inclusive)",     mode = { "n", "x", "o" } },
        -- Search
        { "g*", desc = "search word (no boundary) →", mode = "n" },
        { "g#", desc = "search word (no boundary) ←", mode = "n" },
        -- Changelist
        { "g;", desc = "prev change position",        mode = "n" },
        { "g,", desc = "next change position",        mode = "n" },
        -- Case / format operators
        { "g~", desc = "toggle case (operator)",      mode = { "n", "x" } },
        { "gu", desc = "lowercase (operator)",        mode = { "n", "x" } },
        { "gU", desc = "uppercase (operator)",        mode = { "n", "x" } },
        { "gq", desc = "format / reflow text",        mode = { "n", "x" } },
        { "gw", desc = "format / reflow (cursor stable)", mode = { "n", "x" } },
        -- Line shortcuts
        { "guu", desc = "lowercase line",             mode = "n" },
        { "gUU", desc = "uppercase line",             mode = "n" },
        { "g~~", desc = "toggle case line",           mode = "n" },
        { "gqq", desc = "format current line",        mode = "n" },
    })

    -- ── z prefix — POPUP ────────────────────────────────────────────────────
    wk.add({
        { "z", group = "fold & view" },
        -- View: reposition screen without moving cursor
        { "zz", desc = "centre cursor line",        mode = "n" },
        { "zt", desc = "cursor line to top",        mode = "n" },
        { "zb", desc = "cursor line to bottom",     mode = "n" },
        -- Horizontal scroll
        { "ze", desc = "scroll right to cursor",    mode = "n" },
        { "zs", desc = "scroll left to cursor",     mode = "n" },
        -- Folds: open
        { "zo", desc = "open fold",                 mode = "n" },
        { "zO", desc = "open folds recursively",    mode = "n" },
        { "zR", desc = "open all folds",            mode = "n" },
        -- Folds: close
        { "zc", desc = "close fold",                mode = "n" },
        { "zC", desc = "close folds recursively",   mode = "n" },
        { "zM", desc = "close all folds",           mode = "n" },
        -- Folds: toggle
        { "za", desc = "toggle fold",               mode = "n" },
        { "zA", desc = "toggle folds recursively",  mode = "n" },
        { "zi", desc = "toggle foldenable",         mode = "n" },
        -- Folds: navigate
        { "zj", desc = "next fold start",           mode = "n" },
        { "zk", desc = "prev fold end",             mode = "n" },
        -- Folds: create/delete (foldmethod=manual or treesitter)
        { "zf", desc = "create fold (operator)",    mode = { "n", "x" } },
        { "zd", desc = "delete fold at cursor",     mode = "n" },
        { "zD", desc = "delete folds recursively",  mode = "n" },
        -- Spelling (when spell=true)
        { "z=", desc = "spell suggestions",         mode = "n" },
        { "zg", desc = "add word to spellfile",     mode = "n" },
        { "zw", desc = "mark word as wrong",        mode = "n" },
        { "z]", desc = "next misspelled word",      mode = "n" },
        { "z[", desc = "prev misspelled word",      mode = "n" },
    })

    -- ── <C-w> prefix — POPUP ───────────────────────────────────────────────
    wk.add({
        { "<C-w>", group = "windows" },
        -- Split
        { "<C-w>s", desc = "split horizontal" },
        { "<C-w>v", desc = "split vertical" },
        { "<C-w>n", desc = "new window" },
        -- Close
        { "<C-w>q", desc = "close window" },
        { "<C-w>c", desc = "close window (no quit)" },
        { "<C-w>o", desc = "close all other windows" },
        -- Navigate (remapped to <C-h/j/k/l> — these are the raw <C-w> forms)
        { "<C-w>h", desc = "window left" },
        { "<C-w>j", desc = "window down" },
        { "<C-w>k", desc = "window up" },
        { "<C-w>l", desc = "window right" },
        -- Move window
        { "<C-w>H", desc = "move window far left" },
        { "<C-w>J", desc = "move window far down" },
        { "<C-w>K", desc = "move window far up" },
        { "<C-w>L", desc = "move window far right" },
        { "<C-w>T", desc = "move window to new tab" },
        { "<C-w>x", desc = "swap with next window" },
        { "<C-w>r", desc = "rotate windows down/right" },
        { "<C-w>R", desc = "rotate windows up/left" },
        -- Resize
        { "<C-w>=", desc = "equalize window sizes" },
        { "<C-w>+", desc = "increase height" },
        { "<C-w>-", desc = "decrease height" },
        { "<C-w><", desc = "decrease width" },
        { "<C-w>>", desc = "increase width" },
        { "<C-w>_", desc = "maximize height" },
        { "<C-w>|", desc = "maximize width" },
        -- Other
        { "<C-w>f", desc = "open file under cursor in split" },
        { "<C-w>}", desc = "preview tag" },
        { "<C-w>z", desc = "close preview window" },
    })

    -- ── ] / [ navigation — POPUP ───────────────────────────────────────────
    wk.add({
        mode = { "n", "x", "o" },
        -- Built-in unmatched bracket jumps
        { "[(", desc = "prev unmatched (" },
        { "[{", desc = "prev unmatched {" },
        { "](", desc = "next unmatched )" },
        { "]{", desc = "next unmatched }" },
        -- Built-in section jumps (C / nroff)
        { "[[", desc = "prev section start" },
        { "]]", desc = "next section start" },
        { "[]", desc = "prev section end" },
        { "][", desc = "next section end" },
        -- Spelling
        { "[s", desc = "prev misspelled word" },
        { "]s", desc = "next misspelled word" },
    })

    -- ── Text objects — POPUP (operator-pending + visual) ───────────────────
    -- Extends the i/a group labels already registered in keymaps.lua.
    -- Built-in objects use the "inner / around" Vim convention throughout;
    -- treesitter-textobjects follow the same style for consistency.
    wk.add({
        mode = { "o", "x" },
        -- Built-in: word / sentence / paragraph
        { "iw", desc = "inner word" },
        { "aw", desc = "around word" },
        { "iW", desc = "inner WORD" },
        { "aW", desc = "around WORD" },
        { "is", desc = "inner sentence" },
        { "as", desc = "around sentence" },
        { "ip", desc = "inner paragraph" },
        { "ap", desc = "around paragraph" },
        -- Built-in: bracket pairs
        { "i(", desc = "inner ()" },
        { "a(", desc = "around ()" },
        { "ib", desc = "inner () (alias)" },
        { "ab", desc = "around () (alias)" },
        { "i[", desc = "inner []" },
        { "a[", desc = "around []" },
        { "i{", desc = "inner {}" },
        { "a{", desc = "around {}" },
        { "iB", desc = "inner {} (alias)" },
        { "aB", desc = "around {} (alias)" },
        { "i<", desc = "inner <>" },
        { "a<", desc = "around <>" },
        { "it", desc = "inner tag" },
        { "at", desc = "around tag" },
        -- Built-in: quote pairs
        { [[i"]], desc = [[inner ""]] },
        { [[a"]], desc = [[around ""]] },
        { "i'",   desc = "inner ''" },
        { "a'",   desc = "around ''" },
        { "i`",   desc = "inner ``" },
        { "a`",   desc = "around ``" },
        -- treesitter-textobjects (from plugins/treesitter-textobjects.lua)
        { "af", desc = "around function" },
        { "if", desc = "inner function" },
        { "ac", desc = "around class" },
        { "ic", desc = "inner class" },
        { "aa", desc = "around argument" },
        { "ia", desc = "inner argument" },
        { "ai", desc = "around conditional" },
        { "ii", desc = "inner conditional" },
        { "al", desc = "around loop" },
        { "il", desc = "inner loop" },
        { "ak", desc = "around call" },
        { "ik", desc = "inner call" },
    })

    -- ── Registers reference — SEARCH only ─────────────────────────────────
    wk.add({
        mode = "n",
        { [[""]],  desc = [[unnamed register (last d/c/y)]] },
        { [["0]],  desc = [[yank register (never clobbered by delete)]] },
        { [["1]],  desc = [[last linewise delete]] },
        { [["_]],  desc = [[black hole register (discard)]] },
        { [["+]],  desc = [[system clipboard]] },
        { [["*]],  desc = [[primary selection (Linux/X11)]] },
        { [["%]],  desc = [[current filename]] },
        { [[":"]], desc = [[last ex command]] },
        { [["/]],  desc = [[last search pattern]] },
    })
end

return M
