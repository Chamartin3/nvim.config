return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
    'whoissethdaniel/mason-tool-installer.nvim',
    'folke/neoconf.nvim',
    'folke/neodev.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'neovim/nvim-lspconfig',
  },
  config = function()
    -- import mason
    local mason = require 'mason'
    -- import mason-lspconfig
    local mason_lspconfig = require 'mason-lspconfig'
    local mason_tool_installer = require 'mason-tool-installer'

    require('neodev').setup {}
    -- enable mason and configure icons
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
      -- list of servers for mason to install
      ensure_installed = {
        'vue_ls',
        'ts_ls',
        'gopls',
        'html',
        'cssls',
        'tailwindcss',
        'svelte',
        'lua_ls',
        'graphql',
        'emmet_ls',
        'prismals',
        'pyright',
        'pylsp',
      },
      mason_tool_installer.setup {
        ensure_installed = {
          'prettier', -- prettier formatter
          'stylua', -- lua formatter
          'isort', -- python formatter
          'black', -- python formatter
          'pylint',
          'eslint_d',
          'stylua',
          'lua-language-server',
          'bashls',
        },
      },
    }
  end,
}
