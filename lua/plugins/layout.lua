return {
  { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically
  {
    --  NOTE: Silly duck plugin
    'tamton-aquib/duck.nvim',

    config = function()
      local wk = require 'which-key'
      local duck = require 'duck'
      wk.add {
        { '<leader>u', group = 'Duck', desc = 'Duck commands' },
        { '<leader>ud', duck.hatch, desc = 'Hatch a [D]uck' },
        { '<leader>uk', duck.cook, desc = 'Coo[k] a Duck' },
        { '<leader>ua', duck.cook_all, desc = 'Cook [A]ll Ducks' },
      }
    end,
  }, -- lazy.nvim
  {
    'adelarsq/image_preview.nvim',
    event = 'VeryLazy',
    config = function()
      require('image_preview').setup()
    end,
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
  },
  { 'nanotee/zoxide.vim' },
  ---@type LazySpec
  {
    'mikavilpas/yazi.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>yy',
        '<cmd>Yazi<cr>',
        desc = 'Yazi 🦆: Open at the current file',
      },
      {
        -- Open in the current working directory
        '<leader>yr',
        '<cmd>Yazi cwd<cr>',
        desc = 'Yazi 🦆: Open the file manager in the project root',
      },
      {
        '<c-up>',
        '<cmd>Yazi toggle<cr>',
        desc = 'Yazi 🦆: Resume the last yazi session',
      },
    },
    ---@type YaziConfig
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = false,
      keymaps = {

        show_help = '<f1>',
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- TODO: This should maybe be moved to the theme config
      require('lualine').setup {
        options = {
          theme = 'tokyonight',
          disabled_filetypes = { 'NVimTree_1' },
        },
        sections = {
          lualine_c = {
            function()
              return require('auto-session.lib').current_session_name(true)
            end,
          },
        },
      }
    end,
  },
  {
    'sidebar-nvim/sidebar.nvim',
    init = function()
      local sidebar = require 'sidebar-nvim'

      sidebar.setup {
        disable_default_keybindings = 0,
        bindings = {
          ['q'] = function()
            require('sidebar-nvim').close()
          end,
        },
        open = false,
        side = 'left',
        initial_width = 35,
        hide_statusline = false,
        update_interval = 1000,
        sections = { 'datetime', 'git', 'diagnostics' },
        section_separator = { '', '-----', '' },
        section_title_separator = { '' },
        containers = {
          attach_shell = '/bin/sh',
          show_all = true,
          interval = 5000,
        },
        datetime = { format = '%a %b %d, %H:%M', clocks = { { name = 'local' } } },
        todos = { ignored_paths = { '~' } },
      }

      require('which-key').add {
        { '<leader>e', group = 'Sidebar' },
        { '<leader>ed', '<cmd>lua require("sidebar-nvim").open("diagnostics")<CR>', desc = 'Open Diagnostics' },
        { '<leader>ee', '<cmd>lua require("sidebar-nvim").toggle()<CR>', desc = 'Toggle Sidebar' },
        { '<leader>eg', '<cmd>lua require("sidebar-nvim").open("git")<CR>', desc = 'Open Git' },
        { '<leader>el', '<cmd>lua require("sidebar-nvim").open("loclist")<CR>', desc = 'Open Loclist' },
        { '<leader>et', '<cmd>lua require("sidebar-nvim").open("todos")<CR>', desc = 'Open Todos' },
      }
    end,
  },
  {
    --- BUFER NAVIGATION
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
      'folke/which-key.nvim',
    },
    init = function()
      vim.g.barbar_auto_setup = false
      local wk = require 'which-key'
      -- NOTE: requires standarization
      wk.add({
        { '<leader>b', group = '[B]uffer Tabs', icon = '󰈙' },
        { '<leader>bh', '<cmd>BufferPrevious<CR>', desc = '[h]-Previous', icon = '󰜱' },
        { '<leader>bl', '<cmd>BufferNext<CR>', desc = '[l]-Next', icon = '󰊍' },

        { '<leader>bH', '<Cmd>BufferGoto 1<CR>', desc = '[H]-First', icon = '󰘀' },
        { '<leader>bL', '<cmd>BufferLast<CR>', desc = '[L]-Last', icon = '󰘁' },

        -- { '<leader>bg', group = '[G]oto', },
        { '<leader>bg', '<cmd>BufferPick<CR>', desc = '[G]oto', icon = '' },

        { '<leader>bm', group = '[M]ove current', icon = '󰆾' },
        { '<leader>bmb', '<cmd>BufferMovePrevious<CR>', desc = '[B]ackward', icon = '󱞧' },
        { '<leader>bmf', '<cmd>BufferMoveNext<CR>', desc = '[F]orward', icon = '󱞫' },
        { '<leader>bp', '<cmd>BufferPin<CR>', desc = '[P]in', icon = '󰐃' },
        { '<leader>bs', group = 'Sort by', icon = '󰒺' },
        { '<leader>bsb', '<cmd>BufferOrderByBufferNumber<CR>', desc = '[B]uffer number' },
        { '<leader>bsd', '<cmd>BufferOrderByDirectory<CR>', desc = '[D]irectory' },
        { '<leader>bsl', '<cd>BufferOrderByLanguage<CR>', desc = '[L]anguage' },
        { '<leader>bsn', '<cmd>BufferOrderByName<CR>', desc = '[N]ame' },
        { '<leader>bsw', '<cmd>BufferOrderByWindowNumber<CR>', desc = '[W]indow Number' },
        { '<leader>bx', group = '[X]Close', icon = '󰅖' },
        { '<leader>bxl', '<cmd>BufferCloseBuffersLeft<CR>', desc = '[L]eft' },
        { '<leader>bxo', '<cmd>BufferCloseAllButCurrent<CR>', desc = 'All [O]ther' },
        { '<leader>bxp', '<cmd>BufferCloseAllButCurrentOrPinned<CR>', desc = 'All but [P]inned' },
        { '<leader>bxr', '<cmd>BufferCloseBuffersRight<CR>', desc = '[R]ight' },
        { '<leader>bxw', '<cmd>BufferCloseAll<CR>', desc = '[W]ipeout' },
        { '<leader>bxx', '<cmd>BufferClose<CR>', desc = 'Current' },
      }, {
        mode = 'n',
      })
    end,
    opts = {},
  },
  {
    'preservim/vimux',
    config = function()
      function get_session_name()
        local auto_session = require 'auto-session.lib'
        local name = vim.v.this_session or vim.fn.expand '%:p' or 'default'
        if auto_session then
          vim.notify(auto_session.current_session_name(true), vim.log.levels.INFO)
          name = auto_session.current_session_name(true)
        end
        name = name:gsub(' ', '_'):gsub('[()]', ''):gsub('[.]', ''):lower()
        return string.sub(name, 1, 250)
      end

      function get_random_uid()
        -- Generate a random hash for the session name
        local random_hash = string.gsub(string.sub(tostring {}, 10), '[^%w]', function()
          return string.format('%x', math.random(0, 15))
        end)
        return random_hash:sub(1, 6)
      end

      function run_vimux_command(vimux_cmd, session_name)
        local cmd = vimux_cmd
        local runner_name = 'let b:VimuxRunnerName = "' .. session_name .. '" \n'
        local command_shell_option = 'let b:VimuxCommandShell = 1' .. ' \n'
        local options = runner_name .. command_shell_option
        vim.notify('Running Vimux command: ' .. options .. cmd, vim.log.levels.INFO)
        vim.cmd(options .. cmd)
      end

      function withSession(cmd)
        -- Helper function to get the current session name
        local session_name = get_session_name()
        run_vimux_command(cmd, session_name)
      end

      function withInput(callback)
        -- Helper function to get input from the user
        local input_opts = {
          prompt = 'Enter command: ',
          completion = 'shellcmd',
        }
        vim.ui.input(input_opts, function(input)
          input = input or ''
          callback(input)
        end)
      end

      function promptCmd(detached)
        detached = detached or false
        local session_name = get_session_name()
        if detached then
          session_name = session_name .. '_' .. get_random_uid()
        end
        local onInput = function(input)
          local cmd = 'VimuxRunCommand' .. "'" .. input .. "'"
          run_vimux_command(cmd, session_name)
        end
        withInput(onInput)
      end

      vim.keymap.set('n', '<leader>rc', promptCmd, {
        desc = 'Run Shell command in current session',
      })
      vim.keymap.set('n', '<leader>rl', function()
        withSession 'VimuxRunLastCommand'
      end, { desc = 'Run last Shell command in current session' })

      vim.keymap.set('n', '<leader>rd', function()
        promptCmd(false)
      end, { desc = 'Run command detached from the session' })

      vim.keymap.set('n', '<leader>rx', function()
        local session_name = get_session_name()
        run_vimux_command('VimuxCloseRunner', session_name)
      end, { desc = 'Close current session runner' })
    end,
  },
}
