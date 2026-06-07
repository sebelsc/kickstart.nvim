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

-- Make sure Mason installs the server, debug adapter, and test bundles.
-- (lombok.jar ships inside Mason's jdtls package, so no separate entry.)
-- This re-runs mason-tool-installer with the Java tools appended; harmless if
-- it overlaps with the list in your LSP section.
local ok, mti = pcall(require, 'mason-tool-installer')
if ok then
    mti.setup {
        ensure_installed = { 'jdtls', 'java-debug-adapter', 'java-test', 'vscode-spring-boot-tools' },
    }
end

-- Add nvim-neotest for better testing support
-- vim.pack.add {
--     --   'https://github.com/nvim-neotest/neotest',
--     'https://github.com/nvim-neotest/nvim-nio', -- already installed via kickstart debug, but harmless
--     --   'https://github.com/rcasia/neotest-java',
--     'https://github.com/theHamsta/nvim-dap-virtual-text',
-- }
--
-- require 'nvim-treesitter'
-- require('nvim-dap-virtual-text').setup {}
--
-- require('neotest').setup {
--   adapters = {
--     require 'neotest-java' {
--       ignore_wrapper = false, -- use gradlew
--       log_level = vim.log.levels.DEBUG,
--     },
--   },
-- }
--
-- local check, NJPath = pcall(require, 'neotest-java.model.path')
-- if check then
--   local orig = NJPath.append
--   NJPath.append = function(self, other)
--     if type(other) == 'table' then other = tostring(other) end
--     return orig(self, other)
--   end
-- end
-- -- neotest discovers nvim-treesitter via parser file location, but parsers land in
-- -- site/parser/ (outside the plugin dir), so the plugin's lua/ never reaches the
-- -- child process. Inject it explicitly.
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


require('spring_boot').init_lsp_commands()
