return {
  {
    'tpope/vim-fugitive',
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = true, -- Toggle with `:Gitsigns toggle_word_diff`
      --- NOTE: Consider custome pagers as
      ---  diff-so-fancy
      ---  https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        --
        -- NOTE: Usefull for code reviewing but not for daily use
        -- local function define_gitsigns_highlights()
        --   vim.api.nvim_set_hl(0, 'GitSignsAddLn', { link = 'Comment', guibg = '#b3f7b2' })
        --   -- vim.api.nvim_set_hl(0, "GitSignsChange", { link = "Constant", guibg = "#F0F0F0" })
        --   -- vim.api.nvim_set_hl(0, "GitSignsDelete", { link = "Error", guibg = "#F0F0F0" })
        --   -- vim.api.nvim_set_hl(0, "GitSignsDiff", { guifg = "#888888", guibg = "#F0F0F0" })
        --   -- vim.api.nvim_set_hl(0, "GitSignsHunk", { guibg = "#EEEEEE" })
        -- end
        -- define_gitsigns_highlights()
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        -- Navigation
        map('n', ']h', gs.next_hunk, 'Next Git Hunk')
        map('n', '[h', gs.prev_hunk, 'Prev Git Hunk')

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, 'Git: Stage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Git: Reset hunk')
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Git: Stage hunk')
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Git: Reset hunk')

        map('n', '<leader>hS', gs.stage_buffer, 'Git: Stage buffer')
        map('n', '<leader>hR', gs.reset_buffer, 'Git: Reset buffer')

        map('n', '<leader>hu', gs.undo_stage_hunk, 'Git: Undo stage hunk')

        map('n', '<leader>hp', gs.preview_hunk, 'Git: Preview hunk')

        map('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, 'Git: Blame line')
        map('n', '<leader>hB', gs.toggle_current_line_blame, 'Git: Toggle line blame')

        map('n', '<leader>hd', gs.diffthis, 'Git: Diff this')
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, 'Git: Diff this ~')
        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Gitsigns select hunk')
      end,
    },
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('telescope').load_extension 'lazygit'
    end,

    keys = {
      { '<leader>hl', '<cmd>LazyGit<cr>', desc = 'Open lazy git' },
      { '<leader>ht', '<cmd>lua require("telescope").extensions.lazygit.lazygit()<cr>', desc = 'telescope lazygit' },
    },
  },

  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = function()
      require('git-conflict').setup {
        default_mappings = {
          ours = 'o',
          theirs = 't',
          none = '0',
          both = 'b',
          next = 'n',
          prev = 'p',
        },
      }
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitConflictDetected',
        callback = function()
          vim.notify('Conflict detected in ' .. vim.fn.expand '<afile>')
          vim.keymap.set('n', 'cww', function()
            engage.conflict_buster()
            create_buffer_local_mappings()
          end)
        end,
      })
    end,
  },
  {
    'sindrets/diffview.nvim',
    -- TODO: Add a keybinding to open diffview in the source branch
    -- depending on the PR
  },
  -- GitHub related plugins
  { 'lukas-reineke/pr.nvim' },
  { 'miniatureape/quickpr' },
  -- {
  --   'pwntester/octo.nvim',
  --   BUG: Coflict with autosessions
  -- },
}
