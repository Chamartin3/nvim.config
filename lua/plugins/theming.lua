return {
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      ---- Set header
      local custom_cfg = require 'style.dashboard'
      local logo = custom_cfg.getPikachuHeader(true)
      dashboard.section.header.val = logo.val
      dashboard.section.header.opts.hl = logo.opts.hl

      -- Set footer
      dashboard.section.footer.val = 'How we eat the elephant? \n One bite at a time'
      dashboard.section.footer.opts.hl = 'AlphaFooter'
      vim.api.nvim_set_hl(0, 'AlphaFooter', {
        fg = '#FFFFFF',
        italic = true,
        bold = true,
      })

      local pokebutton = custom_cfg.getPokeButton
      local base_buttons = {
        pokebutton('Sessions', {
          shortcut = 'ss',
          command = '<cmd>SessionSearch<CR>',
        }),
        pokebutton('Last Session', {
          shortcut = 'sl',
          command = '<cmd>SessionLoad<CR>',
        }),
        pokebutton('New File', {
          shortcut = 'e',
          command = '<cmd>ene<CR>',
        }),
        pokebutton('Find File', {
          shortcut = 'ff',
          command = '<cmd>Telescope find_files<CR>',
        }),
        pokebutton('Find Word', {
          shortcut = 'fg',
          command = '<cmd>Telescope live_grep<CR>',
        }),
        pokebutton('Quit NVIM', {
          shortcut = 'q',
          command = '<cmd>qa<CR>',
        }),
      }

      local gitMenu = require('style.dashboard').getGitMenu()
      for _, button in ipairs(gitMenu) do
        table.insert(base_buttons, button)
      end
      dashboard.section.buttons.val = base_buttons

      alpha.setup(dashboard.opts)
      -- Disable folding on alpha buffer
      vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
    end,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      require('tokyonight').setup {
        style = 'moon',
        transparent = true,
        sidebars = { 'qf', 'help' }, -- Set
        styles = {
          comments = {
            italic = true,
            bold = true,
            blend = 60,
          },
          keywords = { italic = true },
          functions = {
            bold = true,
          },
          docstrings = {
            italic = true,
          },
          sidebars = 'transparent',
          floats = 'transparent',
        },
        on_colors = function(colors)
          colors.line_numbers = '#CCCCCC'
          colors.comments = '#FF8800'
        end,
        on_highlights = function(hl, c)
          hl.pythonTripleQuotes = {
            italic = true,
          }
          hl.WhichKeyBorder = {
            fg = c.orange,
          }
          hl.WhichKeySeparator = {
            fg = c.green,
          }
          -- hl.AlphaShortcut = {
          --   fg = c.orange,
          -- }
          -- hl.AlphaFooter = {
          --   fg = c.white,
          --   italic = true,
          -- }
          hl.Comment = {
            fg = '#9b9b9b',
            italic = true,
          }
        end,
      }
      vim.cmd.hi 'Comment gui=none'
      vim.cmd.colorscheme 'tokyonight'
    end,
  },
  {
    'sphamba/smear-cursor.nvim',

    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = false,
      smear_insert_mode = true,
    },
  },
  {
    'yorickpeterse/nvim-pqf',
    config = function()
      require('pqf').setup {
        signs = {
          error = { text = 'E', hl = 'DiagnosticSignError' },
          warning = { text = 'W', hl = 'DiagnosticSignWarn' },
          info = { text = 'I', hl = 'DiagnosticSignInfo' },
          hint = { text = 'H', hl = 'DiagnosticSignHint' },
        },
        show_multiple_lines = false,
        max_filename_length = 0,
        filename_truncate_prefix = '[...]',
      }
    end,
  },
