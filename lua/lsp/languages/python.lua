local M = {
  python = {
    lsp = {},
    -- formatter = 'ruff',
    linters = { 'ruff' },
    parsers = { 'python' },
    debug = { 'debugpy' },
  },
  htmldjango = {
    formatter = 'djlint',
    parsers = { 'htmldjango' },
    lsp = {
      -- 'djlsp', -- Django LSP server for HTML templates
      'django-template-lsp', -- Alternative Django LSP server
    },
  },
}

local lsp = {}
lsp.ruff = {
  -- cmd = { 'ruff-lsp' },
  -- root_dir = function(fname)
  --   return vim.fs.dirname(vim.fs.find({
  --     'pyproject.toml',
  --     'ruff.toml',
  --     '.ruff.toml',
  --     'setup.py',
  --     'setup.cfg',
  --     'requirements.txt',
  --     'Pipfile',
  --     'pyrightconfig.json',
  --     '.git',
  --   }, { upward = true, path = fname })[1])
  -- end,
  init_options = {
    settings = {
      -- Enable import sorting and organization
      organizeImports = true,
      fixAll = true,
      -- Configure ruff settings
      -- args = {
      --   '--select=I,F,E,W,UP,B,SIM,C90',  -- Enable import sorting (I) and other rules
      --   '--fix',
      --   '--format=json',
      -- },
      -- Import sorting configuration
      importStrategy = 'fromFirst',
      codeAction = {
        fixViolation = {
          enable = true,
        },
        organizeImports = {
          enable = true,
        },
      },
    },
  },
}

-- Configure pyright for type checking (disable overlapping features with ruff)
-- vim.lsp.config('pyright', {
--   cmd = { 'pyright-langserver', '--stdio' },
--   filetypes = { 'python' },
--   root_dir = function(fname)
--     return vim.fs.dirname(vim.fs.find({
--       'pyproject.toml',
--       'setup.py',
--       'setup.cfg',
--       'requirements.txt',
--       'Pipfile',
--       'pyrightconfig.json',
--       '.git',
--     }, { upward = true, path = fname })[1])
--   end,
--   capabilities = capabilities,
--   settings = {
--     python = {
--       analysis = {
--         -- Disable pyright's formatting and import organization since ruff handles it
--         autoImportCompletions = true,
--         typeCheckingMode = 'basic',
--         -- Disable overlapping functionality with ruff
--         autoSearchPaths = true,
--         diagnosticMode = 'openFilesOnly',
--         useLibraryCodeForTypes = true,
--       },
--     },
--   },
-- })
-- Snippet
-- -- Configure ruff-lsp (primary Python linter and formatter)
-- lspconfig.ruff_lsp.setup {
--   capabilities = capabilities,
--   init_options = {
--     settings = {
--       -- Any extra CLI arguments for `ruff` go here.
--       args = {},
--     }
--   }
-- }
--
-- -- Configure pyright for type checking (disable overlapping features with ruff)
lsp.pyright = {
  settings = {
    python = {
      analysis = {
        -- Disable pyright's formatting and import organization since ruff handles it
        autoImportCompletions = true,
        typeCheckingMode = 'basic',
        -- Disable overlapping functionality with ruff
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
}
--
-- -- Keep pylsp as backup but disable overlapping features with ruff
--
--
lsp.pylsp = {
  settings = {
    pylsp = {
      plugins = {
        -- Disable formatting and linting in pylsp since ruff handles it
        autopep8 = { enabled = false },
        black = { enabled = false },
        isort = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        pylint = { enabled = false },

        -- Keep completion and navigation features
        rope_completion = { enabled = true },
        jedi_completion = { enabled = true },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true },
      },
    },
  },
}

M.python.lsp = lsp

return M
