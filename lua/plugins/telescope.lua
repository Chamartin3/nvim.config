return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    {
      'nvim-telescope/telescope-live-grep-args.nvim',
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = '^1.0.0',
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local action_state = require 'telescope.actions.state'
    local actions = require 'telescope.actions'

    local add_tag = function(prompt_bufnr, tag)
      local picker = action_state.get_current_picker(prompt_bufnr)
      local prompt = picker:_get_prompt()
      prompt = vim.trim(prompt)
      picker:set_prompt(prompt .. ' ' .. tag)
    end

    local fg_actions = {
      addarg_ignore_case = function(prompt_bufnr)
        -- Add the --ignore-case tag to the prompt
        add_tag(prompt_bufnr, '--ignore-case')
      end,
      addarg_match_whole_words = function(prompt_bufnr)
        add_tag(prompt_bufnr, '--word-regexp')
      end,
      addarg_invert_match = function(prompt_bufnr)
        add_tag(prompt_bufnr, '--invert-match')
      end,
      addarg_show_hidden = function(prompt_bufnr)
        add_tag(prompt_bufnr, '--hidden')
      end,
      addarg_condition = function(prompt_bufnr)
        add_tag(prompt_bufnr, '--glob')
      end,
      addarg_only_ending_in = function(prompt_bufnr)
        add_tag(prompt_bufnr, "--glob '*{.}'")
      end,
      addarg_path_included = function(prompt_bufnr)
        add_tag(prompt_bufnr, "--glob '{**//**}'")
      end,
    }

    -- local lga_actions = require 'telescope-live-grep-args.actions'
    require('telescope').setup {
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git' },
        use_git_ignore = false,
        path_display = { 'smart' }, -- the way that the list is shown 'smart', 'absolute', 'tail'
        mappings = {
          i = {
            ['<C-Enter>'] = 'to_fuzzy_refine',
            ['<C-/>'] = 'which_key',
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        ['live_grep_args'] = {
          auto_quoting = true,
          prompt_prefix = '🔍 ',
          path_display = { 'smart' },
          prompt_title = 'Rgrep search ([Ctrl+/] for help)',
          mappings = {
            i = {
              ['<C-i>'] = fg_actions.addarg_ignore_case,
              ['<C-w>'] = fg_actions.addarg_match_whole_words,
              ['<C-v>'] = fg_actions.addarg_invert_match,
              ['<C-h>'] = fg_actions.addarg_show_hidden,
              ['<C-c>'] = fg_actions.addarg_condition,
              ['<C-e>'] = fg_actions.addarg_only_ending_in,
              ['<C-p>'] = fg_actions.addarg_path_included,
              ['<C-space>'] = actions.to_fuzzy_refine,
              ['C-/'] = actions.which_key,
            },
          },
        },
      },
    }
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'live_grep_args')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files {
        find_command = {
          'rg',
          '--files',
          '--hidden',
        },
      }
    end, { desc = '[S]earch [F]iles' })

    vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[S]earch [T]elescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', function()
      require('telescope').extensions.live_grep_args.live_grep_args()
    end, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sc', builtin.git_status, { desc = '[S]earch [C]hanges in current git status' })
    vim.keymap.set('n', '<leader>s/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>s/', function()
      -- TODO: add hints for rgrep args
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
