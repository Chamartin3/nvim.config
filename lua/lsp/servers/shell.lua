local capabilities = require 'lsp.utils.capabilities'

local custom_attach = function(client, buffnr)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('Format', { clear = true }),
      buffer = bufnr,
      callback = function()
        if vim.lsp.buf.formatting_seq_sync and type(vim.lsp.buf.formatting_seq_sync) == 'function' then
          vim.lsp.buf.formatting_seq_sync()
        else
          vim.lsp.buf.format { async = true }
        end
      end,
    })
  end
end

vim.lsp.config('bashls', {
  capabilities = capabilities,
  filetypes = { 'zsh', 'sh', 'bash' },
  -- on_attach = custom_attach,
})
