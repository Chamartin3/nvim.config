return {
  { 'folke/neoconf.nvim' },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      { 'antosha417/nvim-lsp-file-operations', config = true },
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      -- local lspconfig = require 'lspconfig'
      -- local mason_lspconfig = require 'mason-lspconfig'
      -- require('mason-tool-installer').setup { ensure_installed = {
      --   'bashls',
      --   'jsonls',
      --   'gopls',
      --} }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local bufopts = { noremap = true, silent = true, buffer = ev.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, bufopts)
        end,
      })

      local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end

      -- local capabilities = require 'lsp.utils.capabilities'

      -- mason_lspconfig.setup_handlers {
      --   function(server_name)
      --     lspconfig[server_name].setup {
      --       capabilities = capabilities,
      --     }
      --   end,
      -- }

      require 'lsp.servers.lua'
      require 'lsp.servers.shell'
      require 'lsp.servers.docker'
      require 'lsp.servers.python'
      require 'lsp.servers.go'
      require 'lsp.servers.jsts'
      require 'lsp.servers.data'
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup {
        autocmd = { enabled = true },
      }
    end,
  },
}
