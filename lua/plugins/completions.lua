--
-- NOTE: Complaetion hints
-- TODO: Add wk hints for these
-- 1. Whole lines						|i_CTRL-X_CTRL-L|
-- 2. keywords in the current file				|i_CTRL-X_CTRL-N|
-- 3. keywords in 'dictionary'				|i_CTRL-X_CTRL-K|
-- 4. keywords in 'thesaurus', thesaurus-style		|i_CTRL-X_CTRL-T|
-- 5. keywords in the current and included files		|i_CTRL-X_CTRL-I|
-- 6. tags							|i_CTRL-X_CTRL-]|
-- 7. file names						|i_CTRL-X_CTRL-F|
-- 8. definitions or macros				|i_CTRL-X_CTRL-D|
-- 9. Vim command-line					|i_CTRL-X_CTRL-V|
-- 10. User defined completion				|i_CTRL-X_CTRL-U|
-- 11. omni completion					|i_CTRL-X_CTRL-O|
-- 12. Spelling suggestions				|i_CTRL-X_s|
-- 13. keywords in 'complete'				|i_CTRL-N| |i_CTRL-P|
--

function env_vars_completion(cmp)
  local source = {}

  source.new = function()
    local self = setmetatable({}, { __index = source })
    return self
  end

  source.complete = function(self, request, callback)
    local items = {}
    for k, v in pairs(vim.fn.environ()) do
      table.insert(items, { label = k, insertText = '$' .. k, kind = cmp.lsp.CompletionItemKind.Variable })
    end
    callback { items = items }
  end
  return source
end

return {
  -- ------------------- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        -- Snippet engine
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',
      'folke/lazydev.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'onsails/lspkind.nvim',
      'honza/vim-snippets',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}
      local lspkind = require 'lspkind'
      lspkind.init {
        symbol_map = {
          Copilot = '',
        },
      }
      -- cmp.register_source('env_vars', env_vars_completion(cmp).new())
      local mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-j>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ['<C-k>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ['<A-]>'] = cmp.mapping.close(), -- Close when check copilot recomendations
        ['A-/'] = cmp.mapping.close(), -- Close when check copilot recomendations
        ['<C-Space>'] = cmp.mapping(cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }, { 'i', 's' })),
      }
      local sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'lazydev', group_index = 0 },
        { name = 'copilot' },
        { name = 'buffer' },
        -- { name = 'env_vars' },
        { name = 'luasnip' },
      }
      --- MAIN SETUP FUCTION
      cmp.setup {
        mapping = mapping,
        sources = sources,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        formatting = {
          format = require('lspkind').cmp_format {
            mode = 'symbol_text',
            ellipsis_char = '...',
            before = function(entry, vim_item)
              return vim_item
            end,
          },
        },
      }

      local preset_cmd_map = cmp.mapping.preset.cmdline()
      -- Appends ctrl-Space to the cmdline mapping
      preset_cmd_map['<C-Space>'] = {
        c = function(fallback)
          if not require('cmp').confirm { select = false } then
            fallback()
          end
        end,
      }
      -- NOTE:
      -- Setup for command line completion
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = preset_cmd_map,
        sources = {
          { name = 'buffer' },
        },
      })
      cmp.setup.cmdline(':', {
        mapping = preset_cmd_map,
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
          { name = 'buffer' },
          -- { name = 'env_vars' },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
      -- NOTE:
      -- TODO:
      -- Setup for Specific File Types
      -- cmp.setup.filetype('gitcommit', {
      --   sources = cmp.config.sources({
      --     { name = 'git' },
      --   }, {
      --     { name = 'buffer' },
      --   }),
      -- })
      -- require('cmp_git').setup()
      --
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
  },
  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
    config = function()
      local autopairs = require 'nvim-autopairs'
      autopairs.setup {
        check_ts = true,
        ts_config = {
          lua = { 'string' },
          javascript = { 'template_string' },
        },
      }
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'github/copilot.vim',
    version = 'v1.51.0',
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_no_maps = false
      --- from copilot.vim version v1.51.0
      --- TODO: Move this impletmetation to copilot.lua plugin
      vim.cmd [[
          imap <Plug>(copilot-dismiss)     <Cmd>call copilot#Dismiss()<CR>
         imap <Plug>(copilot-next)     <Cmd>call copilot#Next()<CR>
         imap <Plug>(copilot-previous) <Cmd>call copilot#Previous()<CR>
         imap <Plug>(copilot-suggest)  <Cmd>call copilot#Suggest()<CR>
         imap <script><silent><nowait><expr> <Plug>(copilot-accept-word) copilot#AcceptWord()
         imap <script><silent><nowait><expr> <Plug>(copilot-accept-line) copilot#AcceptLine()
      ]]
      local copilot_commands = {
        acceptWord = '<Plug>(copilot-accept-word)',
        acceptLine = '<Plug>(copilot-accept-line)',
        dismiss = '<Plug>(copilot-dismiss)',
        next = '<Plug>(copilot-next)',
        previous = '<Plug>(copilot-previous)',
        suggest = '<Plug>(copilot-suggest)',
      }

      vim.api.nvim_set_keymap('i', '<S-Tab>', copilot_commands.acceptLine, { silent = true })

      vim.api.nvim_set_keymap('i', '<A-]>', copilot_commands.next, { silent = true })

      vim.api.nvim_set_keymap('i', '<A-[>', copilot_commands.previous, { silent = true })

      --- TODO: Replace these
      vim.api.nvim_set_keymap('i', '<A-Right>', copilot_commands.acceptWord, { silent = true })
      -- vim.api.nvim_set_keymap('i', '<C-A-Right>', copilot_commands.acceptLine, { silent = true })
      vim.api.nvim_set_keymap('i', '<A-Left>', copilot_commands.dismiss, { silent = true })
      -- vim.api.nvim_set_keymap('i', '<A-Down>', copilot_commands.next, { silent = true })
      -- vim.api.nvim_set_keymap('i', '<A-Up>', copilot_commands.previous, { silent = true })
      vim.api.nvim_set_keymap('i', '<A-/>', copilot_commands.suggest, { silent = true })

      local wk = require 'which-key'
      vim.keymap.set('n', '<leader>acp', '<cmd>Copilot panel<CR>', {
        desc = 'Copilot: Panel',
      })
      vim.keymap.set('n', '<leader>acs', '<cmd>Copilot status<CR>', {
        desc = 'Copilot: Status',
      })
      wk.add({
        { '<leader>ac', group = 'Copilot', icon = '' },
      }, {
        mode = 'n',
      })
    end,
  },
  {
    'nickjvandyke/opencode.nvim',
    version = '*',
    dependencies = {
      { 'folke/snacks.nvim', optional = true },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true

      local wk = require 'which-key'
      wk.add({
        { '<leader>a', name = 'AI', icon = '✨' },
      }, { mode = 'n' })

      vim.keymap.set({ 'n', 'x' }, '<leader>aa', function() require('opencode').ask('@this: ', { submit = true }) end, { desc = 'Ask opencode' })
      vim.keymap.set({ 'n', 'x' }, '<leader>as', function() require('opencode').select() end, { desc = 'Opencode actions' })
      vim.keymap.set({ 'n', 't' }, '<leader>at', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
      vim.keymap.set({ 'n', 'x' }, '<leader>ao', function() return require('opencode').operator('@this ') end, { desc = 'Add range to opencode', expr = true })
    end,
  },
}
