-- https://github.com/rcjsuen/dockerfile-language-server-nodejs
--
local capabilities = require 'lsp.utils.capabilities'

vim.lsp.config('dockerls', {
  capabilities = capabilities,
  settings = {
    docker = {
      filetypes = { 'dockerfile', 'docker-compose' },
      validate = true,
      completion = {
        enabled = true,
      },
    },
  },
})
