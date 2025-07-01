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
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      svelte = { 'prettier' },
      css = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      -- markdown = { 'prettier' },
      graphql = { 'prettier' },
      liquid = { 'prettier' },
      python = {
        'autopep8',
        'black',
      },
      htmldjango = { 'djlint' },
      zsh = {
        'shfmt',
        'shellcheck',
        'prettier',
      },
      shell = { 'shfmt', 'shellcheck', 'prettier' },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
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
  },
}
