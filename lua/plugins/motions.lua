return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      local wk = require 'which-key'
      wk.setup {
        defaults = {
          preset = 'modern',
        },
      }
      wk.add {
        { '<leader>c', group = '[C]ode' },
        { '<leader>g', group = 'LSP', icon = { color = 'red', icon = '󰞋' } },
        { '<leader>h', group = 'Git' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch', icon = '' },
        { '<leader>y', group = '[Y]azi', icon = '🦆' },
        { '<leader>x', group = 'Trouble', icon = '⚠️' },
        { '<leader>q', group = '[Q]uick Fix Lists', icon = '' },
        { '<leader>w', group = '[W]orkspace', icon = { color = 'yellow', icon = '' } },
        {
          '[d',
          desc = 'Previous Diagnostic',
          icon = { icon = '', color = 'red' },
        },
        {
          ']d',
          desc = ' Next Diagnostic',
          icon = { icon = '', color = 'red' },
        },
        {
          ']h',
          desc = 'Next Git Hunk',
          icon = {
            icon = '',
            color = 'orange',
          },
        },
        {
          '[h',
          desc = 'Prev Git Hunk',
          icon = {
            icon = '',
            color = 'orange',
          },
        },
        {
          '[[',
          desc = 'Previous block',
          icon = {
            icon = '',
            color = 'cyan',
          },
        },
        {
          '][',
          desc = 'Current block end',
          icon = {
            icon = '',
            color = 'cyan',
          },
        },
        {
          '[]',
          desc = 'Current block start',
          icon = {
            icon = '',
            color = 'cyan',
          },
        },
        {
          ']]',
          desc = 'Next block',
          icon = {
            icon = '',
            color = 'cyan',
          },
        },
      }
    end,
  },
  {
    'tris203/precognition.nvim', ---> Inline keybind hints
    event = 'VeryLazy',
    opts = {
      keybinds = {
        enabled = true,
        show_in_cmdline = true,
        show_in_statusline = true,
        show_in_popup = true,
        show_in_float = true,
      },
      popup = {
        border = 'rounded',
        winblend = 0,
        width = 50,
        height = 10,
      },
      float = {
        border = 'rounded',
        winblend = 0,
      },
    },
  },
  {
    'doctorfree/cheatsheet.nvim',
    event = 'VeryLazy',
    dependencies = {

      { 'nvim-telescope/telescope.nvim' },
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'hrsh7th/nvim-cmp' },
    },
    config = function()
      local ctactions = require 'cheatsheet.telescope.actions'
      require('cheatsheet').setup {
        bundled_cheetsheets = {
          enabled = { 'default', 'lua', 'markdown', 'regex', 'netrw', 'unicode' },
          disabled = { 'nerd-fonts' },
        },
        bundled_plugin_cheatsheets = {
          enabled = {
            'auto-session',
            'avante.nvim',
            'nvim-cmp',
            -- 'octo.nvim',
            'telescope.nvim',
            -- 'vim-easy-align',
          },
          -- disabled = { 'gitsigns' },
        },
        include_only_installed_plugins = true,
        telescope_mappings = {
          ['<CR>'] = ctactions.select_or_fill_commandline,
          ['<A-CR>'] = ctactions.select_or_execute,
          ['<C-Y>'] = ctactions.copy_cheat_value,
          ['<C-E>'] = ctactions.edit_user_cheatsheet,
        },
      }
    end,
  },
}
