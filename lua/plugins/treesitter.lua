return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'scss',
        'json',
        'yaml',
        'svelte',
        'go',
        'typescript',
        'python',
        'sql',
        'html',
        'rust',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'vim',
        'vimdoc',
        'vue',
        'javascript',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
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
