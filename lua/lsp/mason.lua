return {
  {
    'mason-org/mason.nvim',
    dependencies = {
      'mason-org/mason-lspconfig.nvim',
      'whoissethdaniel/mason-tool-installer.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local mason = require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'
      local mason_tool_installer = require 'mason-tool-installer'

      mason.setup {
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }

      mason_lspconfig.setup {
        ensure_installed = {
          -- Python
          'ruff',
          'pyright',
          'pylsp',
          -- Lua
          'lua_ls',
          -- Go
          'gopls',
          -- Web / Frontend
          'ts_ls',
          'vtsls',
          'vue_ls',
          'svelte',
          'cssls',
          'emmet_ls',
          'eslint',
          'html',
          'tailwindcss',
          'css_variables',
          -- Data / Config
          'jsonls',
          'yamlls',
          'graphql',
          'sqlls',
          -- Shell / Infra
          'bashls',
          'dockerls',
          'docker_compose_language_service',
          'neocmake',
          -- Django
          'django-template-lsp',
          -- Solidity
          'solang',
        },
      }

      mason_tool_installer.setup {
        ensure_installed = {
          -- Linters
          'ruff',
          'eslint_d',
          'shellcheck',
          'hadolint',
          'solhint',
          -- Formatters
          'prettier',
          'stylua',
          'goimports',
          'djlint',
          'yamlfmt',
          'shfmt',
          'beautysh',
          'black',
          -- Debuggers
          'debugpy',
          'delve',
          'local-lua-debugger-vscode',
          'bash-debug-adapter',
        },
      }
    end,
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      { 'mason-org/mason.nvim' },
    },
  },
}
