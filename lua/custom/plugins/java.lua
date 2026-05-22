-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local home = os.getenv( "HOME" )
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.local/share/nvim/jdtls/' .. project_name
vim.lsp.config("jdtls", {
    cmd = {'jdtls', '-data', workspace_dir,},
    root_dir = vim.fs.root(0, {'gradlew', '.git', 'mvnw'}),
  settings = {
    java = {
        -- Custom eclipse.jdt.ls options go here
    },
  },
  init_options = {
      settings = {
        java = {
          implementationsCodeLens = { enabled = true },
          imports = { -- <- this
            gradle = {
              enabled = true,
              wrapper = {
                enabled = true,
                checksums = {
                  {
                    sha256 = '497c8c2a7e5031f6aa847f88104aa80a93532ec32ee17bdb8d1d2f67a194a9c7',
                    allowed = true
                  },
                  {
                      sha256 = '55243ef57851f12b070ad14f7f5bb8302daceeebc5bce5ece5fa6edb23e1145c',
                      allowed = true
                   }
                },
              }
            }
          },
        },
      }
    }
})
vim.lsp.enable("jdtls")

vim.pack.add {'https://codeberg.org/mfussenegger/nvim-jdtls.git'}
-- require('nvim-jdtls').setup{}