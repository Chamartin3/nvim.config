local M = {
  json = {
    lsp = { 'jsonls' },
    formatter = 'prettier',
    parsers = { 'json' },
  },
  yaml = {
    lsp = {
      ['yamlls'] = {
        settings = {
          yaml = {
            schemas = {
              ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
              ['https://json.schemastore.org/ansible-playbook.json'] = '/playbooks/*',
            },
          },
        },
      },
    },
    formatter = {
      'yamlfmt',
      'prettier',
    },
    parsers = { 'yaml' },
  },
  toml = {
    parsers = { 'toml' },
  },
  graphql = {
    lsp = { 'graphql' },
    formatter = 'prettier',
    parsers = { 'graphql' },
  },
  sql = {
    lsp = { 'sqlls' },
    parsers = { 'sql' },
  },
  markdown = {
    parsers = { 'markdown', 'markdown_inline' },
  },
  vim = {
    parsers = { 'vim', 'vimdoc' },
  },
}

return M
