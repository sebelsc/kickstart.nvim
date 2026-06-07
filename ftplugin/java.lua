-- ftplugin/java.lua
local jdtls = require 'jdtls'
-- Runs once per Java buffer. Starts or attaches eclipse.jdt.ls via nvim-jdtls.
--
-- Standard LSP keymaps (grr/gri/grd/grn/gra, document highlight, inlay-hint
-- toggle) come from kickstart's LspAttach autocmds and apply to jdtls too.
-- This file adds only jdtls-specific commands + DAP + JUnit.
local mason = vim.fn.stdpath 'data' .. '/mason/packages'

-- Resolve the project root from THIS buffer (not the startup cwd). Order
-- matters: wrapper/build files win over .git so submodules in a Modulith
-- monorepo don't collapse to the repo root.
local root = vim.fs.root(0, {
  'gradlew',
  'mvnw',
  '.git',
})
if not root then return end

-- Unique data dir per project so jdtls doesn't re-index across projects.
local workspace = vim.fn.stdpath 'data' .. '/jdtls/' .. vim.fn.fnamemodify(root, ':h:t') .. '/' .. vim.fn.fnamemodify(root, ':t')

-- ── Bundles: DAP (java-debug) + JUnit (vscode-java-test) ─────────────────
local bundles = vim.fn.glob(mason .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true, true)

-- Add test jars, excluding the two that must NOT be loaded into jdtls.
local excluded = {
  ['com.microsoft.java.test.runner-jar-with-dependencies.jar'] = true,
  ['jacocoagent.jar'] = true,
}
for _, jar in ipairs(vim.fn.glob(mason .. '/java-test/extension/server/*.jar', true, true)) do
  if not excluded[vim.fn.fnamemodify(jar, ':t')] then table.insert(bundles, jar) end
end

-- ── Optional: Spring Boot LS bundles ─────────────────────────────────────
-- Uncomment together with the spring-boot.nvim block in custom/plugins/java.lua.
local ok_spring, spring = pcall(require, 'spring_boot')
if ok_spring then vim.list_extend(bundles, spring.java_extensions()) end

local config = {
  cmd = {
    'jdtls', -- Mason's wrapper; injects -Declipse.*, -jar, --add-opens, etc.
    '-data',
    workspace,
    '--jvm-arg=-javaagent:' .. mason .. '/jdtls/lombok.jar',
    '--jvm-arg=-Xmx4g',
    '--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false',
  },
  root_dir = root,
  capabilities = require('blink.cmp').get_lsp_capabilities(),
  init_options = { bundles = bundles },
  settings = {
    java = {
      project = {
        settings = {
          ['org.eclipse.jdt.core.compiler.codegen.methodParameters'] = 'generate',
        },
      },
      -- jdtls runs on JDK 21+; JDK 25 is the compile target. 'name' must match
      -- an Eclipse ExecutionEnvironment value. Adjust paths to your installs.
      configuration = {
        updateBuildConfiguration = 'automatic',
        runtimes = {
          { name = 'JavaSE-25', path = vim.fn.expand '/Library/Java/JavaVirtualMachines/microsoft-25.jdk/Contents/Home', default = true },
        },
      },

      -- Build import. Your Gradle wrapper checksum allow-list lives here, under
      -- the correct singular `import` key (NOT `imports`).
      import = {
        gradle = {
          enabled = true,
          version = '9.5.1', -- fallback when a project/included-build lacks its own wrapper
          annotationProcessing = { enabled = true }, -- needed for Lombok etc.
          wrapper = {
            enabled = true,
          },
        },
        maven = { enabled = true },
      },
      imports = {
        gradle = {
          wrapper = {
            checksums = {
              { sha256 = '497c8c2a7e5031f6aa847f88104aa80a93532ec32ee17bdb8d1d2f67a194a9c7', allowed = true },
            },
          },
        },
      },

      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      references = { includeDecompiledSources = true },
      signatureHelp = { enabled = true, description = { enabled = true } },
      contentProvider = { preferred = { 'fernflower' } },
      inlayHints = { parameterNames = { enabled = 'all' } }, -- none/literals/all

      -- Code lenses (correct names + shapes):
      referencesCodeLens = { enabled = true },
      implementationCodeLens = 'all', -- 'all' | 'types' | 'methods'

      completion = {
        favoriteStaticMembers = {
          'org.junit.jupiter.api.Assertions.*',
          'org.junit.jupiter.api.Assumptions.*',
          'org.mockito.Mockito.*',
          'org.assertj.core.api.Assertions.*',
        },
        importOrder = { 'java', 'javax', 'jakarta', 'org', 'com' },
        filteredTypes = { 'com.sun.*', 'sun.*', 'jdk.*' },
      },

      sources = {
        organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
      },
    },
  },

  on_attach = function(client, bufnr)
    -- DAP: register the Java adapter and discover main classes / Spring Boot apps.
    jdtls.setup_dap { hotcodereplace = 'auto' }
    require('jdtls.dap').setup_dap_main_class_configs()

    local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = 'Java: ' .. desc }) end
    -- <leader>j prefix keeps these out of kickstart's existing key groups.
    map('<leader>jo', jdtls.organize_imports, 'Organize imports')
    map('<leader>jv', jdtls.extract_variable, 'Extract variable')
    map('<leader>jc', jdtls.extract_constant, 'Extract constant')
    map('<leader>js', jdtls.super_implementation, 'Goto super implementation')
    -- map('<leader>jt', function() jdtls.test_class { config = { noDebug = true } } end, 'Test class')
    -- map('<leader>jT', function() jdtls.test_class() end, 'Test class (debug)')
    -- map('<leader>jn', function() jdtls.test_nearest_method { config = { noDebug = true } } end, 'Test nearest method')
    -- map('<leader>jN', function() jdtls.test_nearest_method() end, 'Test nearest method (debug)')
    vim.keymap.set('v', '<leader>jm', [[<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>]], { buffer = bufnr, desc = 'Java: Extract method' })

    -- If Java highlighting looks washed out (jdtls semantic tokens overriding
    -- Treesitter), uncomment to drop semantic tokens and let Treesitter drive:
    -- client.server_capabilities.semanticTokensProvider = nil
  end,
}

jdtls.start_or_attach(config)

vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost' }, {
  buffer = 0,
  callback = function() vim.lsp.codelens.enable(true, { bufnr = 0 }) end,
})

vim.lsp.inlay_hint.enable(true, { bufnr = 0 })

-- -- Neotest keymaps — buffer-local but not LSP-dependent
-- local neotest = require 'neotest'
-- local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = true, desc = 'Java: ' .. desc }) end
-- map('<leader>jt', neotest.run.run, 'Test nearest')
-- map('<leader>jT', function() neotest.run.run(vim.fn.expand '%') end, 'Test file')
-- map('<leader>jto', neotest.output.open, 'Test output')
-- map('<leader>js', neotest.summary.toggle, 'Test summary')
-- map('<leader>jx', neotest.run.stop, 'Stop test')

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true
