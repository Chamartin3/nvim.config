return {
  -- {
  --   'PieterjanMontens/vim-pipenv',
  --   dependencies = { 'jmcantrell/vim-virtualenv' },
  -- },
  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local linters_by_ft = require('lsp.languages.config').get_linters_by_ft
      local lint = require 'lint'
      lint.linters_by_ft = linters_by_ft()
      -- lint.linters_by_ft = {V
      --   -- markdown = { 'markdownlint' },
      --   json = { 'jsonlint' },
      --   python = {
      --     'pylint',
      --     'ruff',
      --   },
      --   javascript = { 'eslint_d' },
      --   vue = { 'eslint_d' },
      --   typescript = { 'eslint_d' },
      --   javascriptreact = { 'eslint_d' },
      --   typescriptreact = { 'eslint_d' },
      --   svelte = { 'eslint_d' },
      --   dockerfile = { 'hadolint' },
      --   zsh = { 'zsh' },
      --   shell = { 'shellcheck' },
      -- }
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
