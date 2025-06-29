local capabilities = require 'lsp.utils.capabilities'
local util = require 'lspconfig.util'
local is_npm_package_installed = require('lsp.utils.functions').is_npm_package_installed

-- Typescript Language Server
-- npm install -g typescript typescript-language-server
--
--

local on_attach = function(client, bufnr)
  -- format on save
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('Format', { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.formatting_seq_sync()
      end,
    })
  end
end

vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'javascript', 'typescript', 'vue' },
  plugins = {
    ['@vue/typescript-plugin'] = {
      location = '/usr/local/lib/node_modules/@vue/typescript-plugin',
      languages = { 'javascript', 'typescript', 'vue' },
    },
  },
})
vim.lsp.enable 'eslint'

-- Vue Language Server
-- local function get_typescript_server_path(root_dir)
--   local global_ts = '/usr/lib/node_modules/typescript'
--   local found_ts = ''
--   local function check_dir(path)
--     found_ts = util.path.join(path, 'node_modules', 'typescript', 'lib')
--     if util.path.exists(found_ts) then
--       return path
--     end
--   end
--
--   if util.search_ancestors(root_dir, check_dir) then
--     return found_ts
--   else
--     return global_ts
--   end
--   return nil
-- end
--
-- local filetypes = { 'vue' }
-- if is_npm_package_installed 'vue' then
--   filetypes = { 'vue', 'typescript', 'javascript', 'typescriptreact' }
-- end
--
-- vim.lsp.config('volar', {
--   capabilities = capabilities,
--   filetypes = filetypes,
--   -- root_dir = util.root_pattern 'package.json',
--   settings = {
--     typescript = {
--       tsdk = get_typescript_server_path(vim.fn.getcwd()),
--     },
--     vue = { complete = { casing = { props = 'autoCamel' } } },
--   },
-- })

vim.lsp.config('vue_ls', {
  capabilities = capabilities,
  filetypes = { 'vue', 'typescript', 'javascript', 'typescriptreact' },
  root_dir = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json'),
  settings = {
    vue = {
      comlete = {
        casing = { props = 'autoCamel' },
      },
      format = {
        enable = true,
      },
      validate = true,
    },
  },
})

-- Svelte Language Server
vim.lsp.config('svelte', {
  capabilities = capabilities,
  settings = {
    svelte = {
      validate = true,
      completion = {
        enabled = true,
      },
    },
  },
})

-- HTML, CSS, etc
vim.lsp.config('html', {
  capabilities = capabilities,
})

vim.lsp.enable 'emmet_ls'

vim.lsp.config('emmet_ls', {
  capabilities = capabilities,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'pug', 'css', 'sass', 'scss', 'less', 'svelte' },
})

vim.lsp.config('cssls', {
  capabilities = capabilities,
  settings = {
    css = {
      lint = {
        -- Do not warn for Tailwind's @apply rule
        unknownAtRules = 'ignore',
      },
    },
  },
})

vim.lsp.enable 'css_variables'
vim.lsp.enable 'tailwindcss'
