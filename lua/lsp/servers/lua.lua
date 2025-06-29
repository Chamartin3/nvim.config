-- ps://github.com/sumneko/lua-language-server

local capabilities = require 'lsp.utils.capabilities'

vim.lsp.config('lua_ls', {
  -- on_init = function(client)
  --   if client.workspace_folders then
  --     local path = client.workspace_folders[1].name
  --     if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
  --       return
  --     end
  --   end
  -- end,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'require' },
      },
      format = {
        enable = false,
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
