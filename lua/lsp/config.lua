return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile', 'VeryLazy' },
    dependencies = {
      -- Tool installing (must load before lspconfig)
      { 'mason-org/mason.nvim', config = true },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- LSP extras
      { 'antosha417/nvim-lsp-file-operations', config = true },
      'hrsh7th/cmp-nvim-lsp',
      -- Notifications
      'j-hui/fidget.nvim',
    },
    config = function()
      -- ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
      -- LSP ATTACH AUTOCMD
      -- ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Helper function for setting keymaps
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = 'LSP: ' .. desc })
          end

          -- ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
          -- NAVIGATION KEYMAPS
          -- ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-T>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          map('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = ev.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = ev.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = ev.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
      end

      -- ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
      -- LSP SERVER CONFIGURATIONS
      -- ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
      local servers = {
        -- Python
        ruff = {
          init_options = {
            settings = {
              organizeImports = true,
              fixAll = true,
              importStrategy = 'fromFirst',
              codeAction = {
                fixViolation = { enable = true },
                organizeImports = { enable = true },
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                typeCheckingMode = 'basic',
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                autopep8 = { enabled = false },
                black = { enabled = false },
                isort = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                rope_completion = { enabled = true },
                jedi_completion = { enabled = true },
                jedi_hover = { enabled = true },
                jedi_references = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_symbols = { enabled = true },
              },
            },
          },
        },

        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim', 'require' } },
              format = { enable = false },
              workspace = {
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },

        -- Go
        gopls = {},

        -- Web / Frontend
        ts_ls = {
          filetypes = { 'javascript', 'typescript' },
        },
        vtsls = {
          filetypes = { 'javascript', 'typescript', 'vue' },
        },
        vue_ls = {
          filetypes = { 'vue' },
          init_options = {
            typescript = { tsdk = '' },
            vue = { hybridMode = false },
          },
          settings = {
            vue = {
              complete = { casing = { props = 'autoCamel' } },
              format = { enable = true },
              validate = true,
            },
          },
        },
        svelte = {
          on_attach = function(client, bufnr)
            local original_handler = vim.lsp.handlers['textDocument/publishDiagnostics']
            vim.lsp.handlers['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
              if result and result.diagnostics then
                result.diagnostics = vim.tbl_filter(function(diagnostic)
                  if diagnostic.code == 6133 then
                    local message = diagnostic.message or ''
                    if message:match("'%u[%w]*' is declared") then
                      return false
                    end
                  end
                  return true
                end, result.diagnostics)
              end
              return original_handler(err, result, ctx, config)
            end
          end,
          settings = {
            svelte = {
              validate = true,
              completion = { enabled = true },
              plugin = {
                pug = { enable = true },
                typescript = {
                  enabled = true,
                  diagnostics = { enable = true },
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
                imports = { autoDiscover = true },
              },
            },
          },
        },
        cssls = {
          settings = {
            css = {
              lint = { unknownAtRules = 'ignore' },
            },
          },
        },
        emmet_ls = {
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
        },
        eslint = {},
        html = {},
        tailwindcss = {},
        css_variables = {},

        -- Data / Config
        jsonls = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
                ['https://json.schemastore.org/ansible-playbook.json'] = '/playbooks/*',
              },
            },
          },
        },
        graphql = {},
        sqlls = {},

        -- Shell / Infra
        bashls = {},
        dockerls = {},
        docker_compose_language_service = {},
        neocmake = {},

        -- Django
        ['django-template-lsp'] = {},

        -- Solidity
        solang = {},
      }

      local get_capabilities = require('lsp.utils.capabilities').get_capabilities
      for server, sconfig in pairs(servers) do
        local config = sconfig or {}
        config.capabilities = get_capabilities(config.capabilities or {})
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },
}
