require('snacks').setup {
  -- ── bufdelete ────────────────────────────────────────────────────────
  -- Replaces :bd / :bw. Critically: does NOT close the window when deleting
  -- a buffer. Falls back to the alternate buffer (#), then last used —
  -- exactly the idiomatic buffer navigation model we discussed.
  -- No config needed; just use the API.

  -- ── bigfile ──────────────────────────────────────────────────────────
  -- Replaces the manual `disable = function()` size guard in treesitter.
  -- Automatically disables: treesitter, LSP completion, statuscolumn,
  -- foldexpr, and syntax highlighting when a file exceeds the threshold.
  bigfile = {
    enabled = true,
    size = 1.5 * 1024 * 1024, -- 1.5 MB (default)
    -- Custom handler: extend defaults with anything specific to your setup
    setup = function(ctx)
      -- Disable jdtls semantic tokens for huge generated files
      vim.b[ctx.buf].completion = false
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ctx.buf) then
          -- Fall back to regex syntax so the file is still readable
          vim.bo[ctx.buf].syntax = ctx.ft
        end
      end)
    end,
  },
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

  picker = {
    enabled = true,
    focus = 'input',
    layouts = {
      ivy_narrow_preview = {
        layout = {
          { border = 'bottom', height = 1, win = 'input' },
          {
            { border = 'none', win = 'list' },
            { border = 'left', title = '{preview}', width = 0.4, win = 'preview' },
            box = 'horizontal',
          },
          backdrop = false,
          border = 'top',
          box = 'vertical',
          height = 0.4,
          row = -1,
          title = ' {title} {live} {flags}',
          title_pos = 'left',
          width = 0,
        },
      },
    },
    win = {
      input = {
        keys = {
          ['<Esc>'] = { 'close', mode = { 'i', 'n' } },
        },
      },
    },
    layout = {
      preset = 'dropdown',
    },
    formatters = {
      file = {
        truncate = 'left',
      },
      grep = {
        truncate = 'left',
      },
    },
    sources = {
      files = {
        hidden = true,
        ignored = true,
        layout = { preset = 'select', layout = { width = 0.7, max_width = 200 } },
        win = {
          input = {
            keys = {
              ['<S-h>'] = 'toggle_hidden',
              ['<S-i>'] = 'toggle_ignored',
              ['<S-f>'] = 'toggle_follow',
              ['<C-y>'] = { 'yazi_copy_relative_path', mode = { 'n', 'i' } },
            },
          },
        },
        include = {
          '**/build/generated-sources',
          '**/build/generated-specs',
          '**/build/generated',
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
          '**/bin',
          '**/build/classes',
          '**/build/libs',
          '**/build/reports',
          '**/build/resources',
          '**/build/spotless-clean',
          '**/build/spotless-lints',
          '**/build/spring-modulith-docs',
          '**/build/test-results',
          '**/build/tmp',
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
        layout = { preset = 'ivy' },
        win = {
          input = {
            keys = {
              ['<S-h>'] = 'toggle_hidden',
              ['<S-i>'] = 'toggle_ignored',
              ['<S-f>'] = 'toggle_follow',
            },
          },
        },
        include = {
          '**/build/generated-sources',
          '**/build/generated-specs',
          '**/build/generated',
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
          '**/bin',
          '**/build/classes',
          '**/build/libs',
          '**/build/reports',
          '**/build/resources',
          '**/build/spotless-clean',
          '**/build/spotless-lints',
          '**/build/spring-modulith-docs',
          '**/build/test-results',
          '**/build/tmp',
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
      grep_buffers = { layout = { preset = 'dropdown' } },
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

        include = {
          '**/build/generated-sources',
          '**/build/generated-specs',
          '**/build/generated',
        },
        exclude = {
          '.git',
          '.pnpm-store',
          '.venv',
          '.DS_Store',
          '**/.node-gyp/**',
          '**/node_modules',
          '**/target',
          '**/build/classes',
          '**/build/libs',
          '**/build/reports',
          '**/build/resources',
          '**/build/spotless-clean',
          '**/build/spotless-lints',
          '**/build/spring-modulith-docs',
          '**/build/test-results',
          '**/build/tmp',
          '**/dist',
          '**/bin',
        },
      },

      smart = {
        multi = { 'recent', 'files' },
        format = 'file',
        filter = { cwd = true, buf = true },
        layout = { preset = 'select', layout = { width = 0.7, max_width = 200 } },
      },
      recent = {
        filter = { cwd = true },
        layout = { preset = 'select', layout = { width = 0.7, max_width = 200 } },
      },
      buffers = { layout = { preset = 'dropdown' } },
      command_history = { layout = { preset = 'select' } },

      keymaps = {
        layout = { preset = 'ivy' },
        modes = { 'n' },
        sort = {
          fields = { 'score:desc', 'key', 'mode', 'idx' },
        },
      },

      lsp_definitions = { layout = { preset = 'dropdown' } },
      lsp_implementations = { layout = { preset = 'ivy' } },
      lsp_references = { layout = { preset = 'ivy' } },
      lsp_incoming_calls = { layout = { preset = 'ivy' } },
      lsp_outgoing_calls = { layout = { preset = 'ivy' } },
      lsp_symbols = {
        layout = {
          preset = 'dropdown',
        },
      },
      lsp_workspace_symbols = { layout = { preset = 'dropdown' } },
      diagnostics = { layout = { preset = 'ivy' } },
      diagnostics_buffer = {
        layout = {
          layout = {
            { border = 'bottom', height = 1, win = 'input' },
            {
              { border = 'none', win = 'list' },
              { border = 'left', title = '{preview}', width = 0.4, win = 'preview' },
              box = 'horizontal',
            },
            backdrop = false,
            border = 'top',
            box = 'vertical',
            height = 0.4,
            row = -1,
            title = ' {title} {live} {flags}',
            title_pos = 'left',
            width = 0,
          },
        },
      },
    },
  },

  -- ── words ────────────────────────────────────────────────────────────
  -- Replaces the entire documentHighlightProvider autocmd block from the
  -- LspAttach config. Highlights all references to the word under cursor,
  -- and adds ]w / [w to jump between them.
  -- Remove the documentHighlightProvider block from your LspAttach autocmd
  -- once this is enabled.
  words = {
    enabled = true,
    debounce = 200, -- ms after CursorHold before highlighting fires
    notify_jump = false, -- don't echo "jumped to X references"
  },
  lazygit = {
    enabled = true,
  },

  -- ── toggle ───────────────────────────────────────────────────────────
  -- Stateful toggles that show ON/OFF state in which-key with color coding.
  -- Replaces the manual inlay hint toggle in LspAttach, and supersedes the
  -- raw vim.diagnostic.config calls for per-session toggling.
  -- No setup config needed; toggles are created via the API (see keymaps below).

  -- ── indent ───────────────────────────────────────────────────────────
  -- Replaces indent-blankline. Uses Snacks.scope for treesitter-aware
  -- scope detection — they share the same underlying scope engine,
  -- so no duplication or mismatch between indent guides and scope highlight.
  indent = {
    enabled = true,
    indent = {
      char = '│',
      hl = 'SnacksIndent',
      only_scope = false,
      only_current = false,
    },
    hl = {
      'SnacksIndent1',
      'SnacksIndent2',
      'SnacksIndent3',
      'SnacksIndent4',
      'SnacksIndent5',
      'SnacksIndent6',
      'SnacksIndent7',
      'SnacksIndent8',
    },
    -- Highlight the current scope's indent level
    scope = {
      enabled = true,
      char = '│',
      hl = 'SnacksIndentScope', -- distinct color from indent guides
      underline = false, -- underline the opening line
      only_current = false,
    },
    animate = {
      style = 'down',
    },
    chunk = {
      -- Draws a corner bracket at the start/end of the scope instead of
      -- a straight line — useful for seeing where a block closes
      enabled = true, -- enable if you prefer bracket-style over underline
    },
  },

  -- ── scope ────────────────────────────────────────────────────────────
  -- Treesitter/indent-based scope detection. Powers Snacks.indent above.
  -- Also exposes text objects (ii/ai) and jump commands ([i/]i) for
  -- the current scope — complementary to treesitter-textobjects' af/if.
  -- ii/ai = scope block (whatever encloses the cursor: method, if, for...)
  -- Note: check for conflicts with your @conditional.inner mapping (ii).
  scope = {
    enabled = true,
    cursor = true,
    siblings = true,
    -- Use treesitter when available, fall back to indent
    treesitter = { enabled = true, injections = true, blocks = {
      enabled = true,
    } },
  },

  -- ── notifier ─────────────────────────────────────────────────────────
  -- Replaces fidget.nvim. Shows jdtls indexing/build progress as
  -- non-intrusive notifications rather than in the statusline.
  notifier = {
    enabled = true,
    timeout = 3000,
    style = 'fancy', -- "compact" | "fancy" | "minimal"
    top_down = false, -- notifications stack upward from the bottom
    -- filter = function(notif)
    --   local filter_jdtls_publish_diag = not (notif.title == 'jdtls' and notif.msg:find 'Publish Diagnostics')
    --   local filter_lua_ls_publish_diag = not (notif.title == 'lua_ls' and notif.msg:find 'Processing')
    --   return filter_jdtls_publish_diag and filter_lua_ls_publish_diag
    -- end,
  },

  -- ── statuscolumn ─────────────────────────────────────────────────────
  -- Replaces manual sign/fold/number column configuration. Unifies:
  -- diagnostics signs, git signs (if using gitsigns.nvim), fold markers,
  -- and line numbers into a single coherent gutter layout.
  statuscolumn = {
    enabled = true,
    left = { 'mark', 'sign' }, -- marks and signs on the left
    right = { 'fold', 'git' }, -- fold indicator and git changes on the right
    folds = {
      open = false, -- show open fold indicator (can be noisy)
      git_hl = false, -- color fold indicators with git diff colors
    },
  },

  -- ── scratch ──────────────────────────────────────────────────────────
  -- Persistent named scratch buffers (survive restarts via shada).
  -- Better than :enew | setlocal buftype=nofile — content is actually saved.
  -- Toggle a scratch buffer: Snacks.scratch()
  -- Pick among existing scratches: Snacks.scratch.select()
  scratch = { enabled = true },

  terminal = {
    win = {
      style = 'terminal',
    },
  },
}

-- ── Keymaps ─────────────────────────────────────────────────────────────

-- Toggles are mapped under <leader>u* in config/keymaps.lua
