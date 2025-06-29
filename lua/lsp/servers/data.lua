local capabilities = require 'lsp.utils.capabilities'
vim.lsp.config('jsonls', {
  capabilities = capabilities,
})

vim.lsp.config('yamlls', {
  capabilities = capabilities,
  settings = {
    yaml = {
      schemas = {
        ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
        ['../path/relative/to/file.yml'] = '/.github/workflows/*',
        ['/path/from/root/of/project'] = '/.github/workflows/*',
      },
    },
  },
})

vim.lsp.config('graphql', {
  capabilities = capabilities,
})

vim.lsp.config('sqlls', {
  capabilities = capabilities,
})
