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
  {
    --- NOICE.NVIM
    --  Pretty command line UI
    -- TODO: Explore nvim command line configuration in snacks
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('lualine').setup {
        sections = {
          lualine_x = {
            {
              require('noice').api.status.message.get_hl,
              cond = require('noice').api.status.message.has,
            },
            {
              require('noice').api.status.command.get,
              cond = require('noice').api.status.command.has,
              color = { fg = '#ff9e64' },
            },
            {
              require('noice').api.status.mode.get,
              cond = require('noice').api.status.mode.has,
              color = { fg = '#ff9e64' },
            },
            {
              require('noice').api.status.search.get,
              cond = require('noice').api.status.search.has,
              color = { fg = '#ff9e64' },
            },
          },
        },
      }
      require('telescope').load_extension 'noice'
      local wk = require 'which-key'
      wk.add({
        { '<leader>n', group = '[N]otifications', icon = '󱥁 ' },
        { '<leader>ns', '<cmd>NoiceTelescope<CR>', desc = '[N]otification Search' },
        { '<leader>nd', '<cmd>NoiceDismiss<CR>', desc = 'Dismiss' },
        { '<leader>nh', '<cmd>NoiceHistory<CR>', desc = 'Show [H]istory' },
        { '<leader>nl', '<cmd>NoiceLast<CR>', desc = 'Show [L]ast' },
        { '<leader>na', '<cmd>NoiceAll<CR>', desc = '[A]ll Messages in a buffer' },
      }, { mode = 'n' })

      -- Print result from command line
      vim.keymap.set('c', '<S-Enter>', function()
        require('noice').redirect(vim.fn.getcmdline())
      end, { desc = 'Redirect Cmdline' })

      --- Navigate form lsp messages
      vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
        if not require('noice.lsp').scroll(4) then
          return '<c-f>'
        end
      end, { silent = true, expr = true })

      vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
        if not require('noice.lsp').scroll(-4) then
          return '<c-b>'
        end
      end, { silent = true, expr = true })
      local lsp_settings = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      }
      require('noice').setup {
        lsp = lsp_settings,
        preset = {
          command_palette = true,
          long_message_to_split = true,
        },
        health = {
          checker = false, -- Disable if you don't want health checks to run
        },
        all = {
          view = 'popup',
          opts = { enter = true, format = 'details' },
          filter = {},
        },
        -- cmdline = {
        --   enabled = true,
        --   view = 'cmdline_popup',
        --   opts = {},
        --   format = {
        --     cmdline = { pattern = '^:', icon = '', lang = 'vim' },
        --     search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
        --     search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
        --     filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
        --     lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
        --     help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
        --     input = { view = 'cmdline_input', icon = '󰥻 ' },
        --   },
        -- },
      }
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- dashboard = { enabled = true },
      -- explorer = { enabled = true },
      indent = { enabled = true },
      input = {
        enabled = true,
        win = { style = 'input' },
        icon = ' ',
        icon_hl = 'SnacksInputIcon',
        icon_pos = 'left',
        prompt_pos = 'title',
      },
      picker = { enabled = true },
      -- notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      -- words = { enabled = true },
    },
  },
}
