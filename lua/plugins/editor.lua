return {
  {
    'cakebaker/scss-syntax.vim',
  },
  {
    'chentoast/marks.nvim',
    config = function()
      require('marks').setup {
        default_mappings = true,
        builtin_marks = { '.', '<', '>', '^' },
        cyclic = true,
        bookmark_0 = {
          sign = '⚑',
          hl = 'Todo',
        },
        mappings = {
          -- toggle = '<leader>m',
          -- toggle_line = 'm',
          -- goto_next = ']m',
          -- goto_prev = '[m',
          -- goto_bookmark = '<leader><leader>m',
          -- clear = '<leader>M',
          -- clear_all = '<leader>MM',
        },
      }
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {

    'norcalli/nvim-colorizer.lua',
    opts = { '*' },
  },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'ibl',
    opts = {
      indent = { char = '┊' },
    },
  },
  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup {}

      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic message' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {
        desc = 'Next Diagnostic message',
      })

      vim.keymap.set('n', '<leader>xm', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
      vim.keymap.set('n', '<leader>xq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
    end,
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  -- TODO: Try out
  -- {"tpope/vim-surround"},
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup {}
      vim.diagnostic.config {
        virtual_text = true,
        underline = true,
      }
    end,
  },
  -- BUG: Not working properly
  -- {
  --   'Bekaboo/deadcolumn.nvim',
  --   config = function()
  --     local opts = {
  --       scope = 'line', ---@type string|fun(): integer
  --       ---@type string[]|fun(mode: string): boolean
  --       modes = function(mode)
  --         return mode:find '^[ictRss\x13]' ~= nil
  --       end,
  --       blending = {
  --         threshold = 0.75,
  --         colorcode = '#000000',
  --         hlgroup = { 'Normal', 'bg' },
  --       },
  --       warning = {
  --         alpha = 0.4,
  --         offset = 0,
  --         colorcode = '#FF0000',
  --         hlgroup = { 'Error', 'bg' },
  --       },
  --       extra = {
  --         ---@type string?
  --         follow_tw = nil,
  --       },
  --     }
  --
  --     require('deadcolumn').setup(opts)
  --   end,
  -- },
}
