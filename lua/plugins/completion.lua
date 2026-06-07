-- Note: Neovim 0.12 ships native insert-mode completion via 'autocomplete'.
-- blink.cmp is still worth keeping for: fuzzy matching, ghost text,
-- integrated signature help, and documentation popup quality.
require("blink.cmp").setup({
    keymap = {
        preset        = "none", -- define all bindings explicitly
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"]     = { "hide", "fallback" },
        ["<CR>"]      = { "accept", "fallback" },
        ["<Tab>"]     = { "snippet_forward", "select_next", "fallback" },
        ["<S-Tab>"]   = { "snippet_backward", "select_prev", "fallback" },
        ["<C-j>"]     = { "select_next", "fallback" },
        ["<C-k>"]     = { "select_prev", "fallback" },
        ["<C-d>"]     = { "scroll_documentation_down", "fallback" },
        ["<C-u>"]     = { "scroll_documentation_up", "fallback" },
    },

    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant       = "mono",
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        -- Per-filetype overrides: restrict buffer source in Java files to
        -- avoid noise — jdtls completion is comprehensive enough
        per_filetype = {
            java = { "lsp", "path", "snippets" },
        },
    },

    completion = {
        -- Accept the currently visible ghost text on <Right>
        ghost_text = { enabled = true },

        documentation = {
            auto_show          = true,
            auto_show_delay_ms = 200,
            window             = { border = "rounded" },
        },

        menu = {
            border = "rounded",
            -- Show a kind icon and kind label beside each item
            draw   = {
                columns = {
                    { "label",     "label_description", gap = 1 },
                    { "kind_icon", "kind" },
                },
            },
        },
    },
    -- Integrated signature help — replaces the <C-k> signature_help call
    -- for insert mode if you prefer blink's popup over the built-in float
    signature = {
        enabled = true,
        window  = { border = "rounded" },
    },
})
