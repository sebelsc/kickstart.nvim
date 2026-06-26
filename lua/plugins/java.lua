-- lua/custom/plugins/java.lua
-- Java/Spring plugin installation. Runs at startup (via `require 'custom.plugins'`).
-- Per-buffer jdtls bootstrap lives in ftplugin/java.lua.
--
-- NOTE: jdtls must NOT be added to the `servers` table in the LSP section, and
-- you must NOT call vim.lsp.enable('jdtls'). nvim-jdtls manages the client
-- lifecycle itself via start_or_attach; doing both causes a double-attach.

-- nvim-jdtls: extends the built-in LSP client with jdtls-specific commands
-- (organize_imports, extract_*, test_class, DAP integration, etc.)
-- vim.pack.add { 'https://codeberg.org/mfussenegger/nvim-jdtls' }

-- Add nvim-neotest for better testing support
-- vim.pack.add {
--     --   'https://github.com/nvim-neotest/neotest',
--     'https://github.com/nvim-neotest/nvim-nio', -- already installed via kickstart debug, but harmless
--     --   'https://github.com/rcasia/neotest-java',
--     'https://github.com/theHamsta/nvim-dap-virtual-text',
-- }
--
require('spring_boot').setup {
  ls_path = vim.fn.expand '~/.vscode/extensions/vmware.vscode-spring-boot-2.2.0/language-server/spring-boot-language-server-2.2.0-SNAPSHOT-exec.jar',
  java_cmd = vim.fn.expand '/Library/Java/JavaVirtualMachines/temurin-25.jdk/Contents/Home/bin/java',
}

require 'nvim-treesitter'
require('nvim-dap-virtual-text').setup {}

local DefaultClasspathProvider = require 'neotest-java.core.spec_builder.compiler.classpath_provider'
local compilers = require 'neotest-java.core.spec_builder.compiler'

local default_provider = DefaultClasspathProvider { client_provider = compilers.client_provider }

local gradle_folder_classpath_provider = {
  get_classpath = function(base_dir, additional_entries)
    local lsp_classpath = default_provider.get_classpath(base_dir, additional_entries)
    local base = tostring(base_dir)

    local patched = lsp_classpath
      :gsub(vim.pesc(base .. '/bin/main'), base .. '/build/classes/java/main:' .. base .. '/build/resources/main')
      :gsub(vim.pesc(base .. '/bin/test'), base .. '/build/classes/java/test:' .. base .. '/build/resources/test')
      :gsub(vim.pesc(base .. '/bin/default'), base .. '/build/resources/test')

    return patched
  end,
}

require('neotest').setup {
  quickfix = { enabled = true, open = true },
  adapters = {
    require 'neotest-java'({
      -- ignore_wrapper = false, -- use gradlew
      incremental_build = true,
    }, {
      classpath_provider = gradle_folder_classpath_provider,
    }),
  },
}

-- local check, NJPath = pcall(require, 'neotest-java.model.path')
-- if check then
--   local orig = NJPath.append
--   NJPath.append = function(self, other)
--     if type(other) == 'table' then other = tostring(other) end
--     return orig(self, other)
--   end
-- end
-- neotest discovers nvim-treesitter via parser file location, but parsers land in
-- site/parser/ (outside the plugin dir), so the plugin's lua/ never reaches the
-- child process. Inject it explicitly.
-- local _sub = require 'neotest.lib.subprocess'
-- local _orig = _sub.add_paths_to_rtp
-- _sub.add_paths_to_rtp = function(paths)
--   local resolved = {}
--   for _, p in ipairs(paths) do
--     if type(p) == 'string' then
--       table.insert(resolved, p)
--     elseif type(p) == 'function' then
--       local ok, root = pcall(_sub.resolve_plugin_root, p)
--       if ok and root then table.insert(resolved, root) end
--     end
--   end
--   local ts = vim.fn.globpath(vim.o.packpath, 'pack/*/opt/nvim-treesitter', 1)
--   if ts ~= '' and not vim.tbl_contains(resolved, ts) then table.insert(resolved, ts) end
--   _orig(resolved)
-- end
-- -- ── Optional: Spring Boot Language Server ────────────────────────────────:
-- Uncomment for application.properties/yaml completion and bean navigation.
-- Also uncomment the matching block in ftplugin/java.lua that appends its
-- bundles to `bundles`.
