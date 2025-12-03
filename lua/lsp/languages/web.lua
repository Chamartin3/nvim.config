-- local capabilities = require 'lsp.utils.capabilities'
-- local util = require 'lspconfig.util'
-- local is_npm_package_installed = require('lsp.utils.functions').is_npm_package_installed

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

local servers = {}
servers.ts_ls = {
  on_attach = on_attach,
  filetypes = { 'javascript', 'typescript' },
}

servers.vtsls = {
  filetypes = { 'javascript', 'typescript', 'vue' },
}

servers.vue_ls = {
  filetypes = { 'vue' },
  init_options = {
    typescript = {
      tsdk = '',
    },
    vue = {
      hybridMode = false,
    },
  },
  settings = {
    vue = {
      complete = {
        casing = { props = 'autoCamel' },
      },
      format = {
        enable = true,
      },
      validate = true,
    },
  },
}

-- Svelte Language Server
servers.svelte = {
  on_attach = function(client, bufnr)
    -- Override diagnostic handler to filter out "never read" errors for component imports
    local original_handler = vim.lsp.handlers['textDocument/publishDiagnostics']
    vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
      -- Filter diagnostics
      if result and result.diagnostics then
        result.diagnostics = vim.tbl_filter(function(diagnostic)
          -- Filter out "is declared but its value is never read" for capitalized imports
          -- (Svelte components are capitalized)
          if diagnostic.code == 6133 then
            local message = diagnostic.message or ''
            -- Check if it's about a capitalized identifier (component)
            if message:match("'%u[%w]*' is declared") then
              return false
            end
          end
          return true
        end, result.diagnostics)
      end
      -- Call original handler
      return original_handler(err, result, ctx, config)
    end
  end,
  settings = {
    svelte = {
      validate = true,
      completion = {
        enabled = true,
      },
      plugin = {
        pug = {
          enable = true,
        },
        typescript = {
          enabled = true,
          diagnostics = {
            enable = true,
          },
        },
        svelte = {
          compilerWarnings = {
            ['a11y-missing-attribute'] = 'ignore',
          },
        },
      },
    },
    typescript = {
      inlayHints = {
        parameterNames = { enabled = 'all' },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      suggest = {
        imports = {
          autoDiscover = true,
        },
      },
    },
  },
}

servers.cssls = {
  settings = {
    css = {
      lint = {
        -- Do not warn for Tailwind's @apply rule
        unknownAtRules = 'ignore',
      },
    },
  },
}

servers.emmet_ls = {
  filetypes = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'vue',
    'svelte',
    'pug',
  },
}

local M = {
  javascript = {
    lsp = servers,
    formatter = 'prettier',
    linters = { 'eslint_d' },
    parsers = { 'javascript' },
  },
  typescript = {
    formatter = 'prettier',
    linters = { 'eslint_d' },
    parsers = { 'typescript' },
  },
  javascriptreact = {
    lsp = { 'eslint' },
    formatter = 'prettier',
    linters = { 'eslint_d' },
    parsers = { 'javascript' },
  },
  typescriptreact = {
    formatter = 'prettier',
    linters = { 'eslint_d' },
    parsers = { 'typescript' },
  },
  vue = {
    lsp = { vtsls = servers.vtsls, vue_ls = servers.vue_ls },
    formatter = 'prettier',
    linters = { 'eslint_d' },
    parsers = { 'vue' },
  },
  svelte = {
    lsp = { svelte = servers.svelte, emmet_ls = servers.emmet_ls },
    formatter = 'prettier',
    linters = { 'eslint_d' },
    parsers = { 'svelte' },
  },
  html = {
    lsp = { 'html', 'emmet_ls' },
    formatter = 'prettier',
    parsers = { 'html' },
  },
  css = {
    lsp = { 'cssls', 'tailwindcss', 'css_variables' },
    formatter = 'prettier',
    parsers = { 'css' },
  },
  scss = {
    lsp = { 'cssls', 'tailwindcss', 'css_variables' },
    formatter = 'prettier',
    parsers = { 'scss' },
  },
  pug = {
    lsp = { 'emmet_ls' },
    formatter = 'prettier',
    parsers = { 'pug' },
  },
}

return M
