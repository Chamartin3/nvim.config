return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = function()
    local get_formatters_by_ft = require('lsp.languages.config').get_formatters_by_ft
    -- formatters_by_ft = {
    --   lua = { 'stylua' },
    --   javascript = { 'prettier' },
    --   typescript = { 'prettier' },
    --   javascriptreact = { 'prettier' },
    --   typescriptreact = { 'prettier' },
    --   svelte = { 'prettier' },
    return {
      notify_on_error = false,
      formatters_by_ft = get_formatters_by_ft(),
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
      },
      formatters = {
        prettier = {
          prepend_args = {
            '-w',
            '--vue-indent-script-and-style',
            '--html-whitespace-sensitivity',
          },
        },
      },
    }
  end,
}
