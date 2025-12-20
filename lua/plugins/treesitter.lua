-- Treesitter configuration for Neovim
--
return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    priority = 1000,
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      opts.ensure_installed = {
        'python',
        'htmldjango',
        'lua',
        'luadoc',
        'go',
        'javascript',
        'typescript',
        'vue',
        'svelte',
        'html',
        'css',
        'scss',
        'pug',
        'json',
        'yaml',
        'toml',
        'graphql',
        'sql',
        'markdown',
        'markdown_inline',
        'vim',
        'vimdoc',
        'bash',
        'dockerfile',
        'cmake',
        'solidity',
      }
      opts.textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },

        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>]'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>[]'] = '@parameter.inner',
          },
        },
      }
      -- example: make gitsigns.nvim movement repeatable with ; and , keys.
      local gs = require 'gitsigns'

      -- make sure forward function comes first
      --
      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'
      local next_hunk_repeat, prev_hunk_repeat = ts_repeat_move.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
      -- Or, use `make_repeatable_move` or `set_last_move` functions for more control. See the code for instructions.

      vim.keymap.set({ 'n', 'x', 'o' }, ']h', next_hunk_repeat)
      vim.keymap.set({ 'n', 'x', 'o' }, '[h', prev_hunk_repeat)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      local treecontext = require 'treesitter-context'
      treecontext.setup {
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 4,
        trim_scope = 'outer',
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = nil,
        zindex = 20, --
        on_attach = nil,
      }
    end,
  },
  {
    'harrisoncramer/jump-tag',
    config = function()
      local htmlnav = require 'jump-tag'
      vim.keymap.set('n', '[<', htmlnav.jumpParent, { desc = 'Parent HTML Tag' })
      vim.keymap.set('n', ']<', htmlnav.jumpChild, { desc = 'Child HTML Tag' })
      --- jumpNextSibling
      vim.keymap.set('n', ']>', htmlnav.jumpNextSibling, { desc = 'Next HTML Tag' })
      vim.keymap.set('n', '[>', htmlnav.jumpPrevSibling, { desc = 'Previous HTML Tag' })
      -- local wk = require 'which-key'
      -- wk.register {
      --   ['[<'] = { htmlnav.jumpParent, 'Parent HTML Tag' },
      --   [']<'] = { htmlnav.jumpChild, 'Child HTML Tag' },
      --   [']>'] = { htmlnav.jumpNextSibling, 'Next Sibling HTML Tag' },
      --   ['[>'] = { htmlnav.jumpPrevSibling, 'Previous Sibling HTML Tag' },
      -- }
    end,
  },
}
