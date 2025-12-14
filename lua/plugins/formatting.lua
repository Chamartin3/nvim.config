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
    return {
      notify_on_error = false,
      formatters_by_ft = {
        python = { 'ruff', 'black' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        vue = { 'prettier' },
        svelte = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        pug = { 'prettier' },
        json = { 'prettier' },
        graphql = { 'prettier' },
        yaml = { 'yamlfmt', 'prettier' },
        lua = { 'stylua' },
        go = { 'goimports' },
        htmldjango = { 'djlint' },
        zsh = { 'beautysh', 'shfmt' },
        shell = { 'shfmt' },
      },
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
