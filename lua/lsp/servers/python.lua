-- require('lspconfig').jedi_language_server.setup {}

vim.lsp.config('pylsp', {
  settings = {
    ['pylsp'] = {},
  },
})
vim.lsp.config('pyright', {
  settings = {
    ['pyright'] = {},
  },
})
