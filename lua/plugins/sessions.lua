return {
  {
    'rmagatti/auto-session',
    config = function()
      local auto_session = require 'auto-session'
      auto_session.setup {
        auto_restore_enabled = true,
        auto_session_use_git_branch = true,
        git_auto_restore_on_branch_change = true,
        -- auto_create = function()
        --   local cmd = '"[[$(git rev-parse --show-toplevel)" == "$(pwd)" ]] && echo "true" || echo "false"'
        --   return vim.fn.system(cmd) == 'true\n'
        -- end,
        auto_session_suppress_dirs = { '~/', '~/Downloads', '~/Documents', '~/Desktop/' },
        post_restore_cmds = {
          function()
            -- Re-trigger filetype detection and BufRead so LSP/treesitter attach to restored buffers
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= '' then
                vim.api.nvim_buf_call(buf, function()
                  vim.cmd 'silent! edit'
                end)
              end
            end
          end,
        },
        session_lens = {
          buftypes_to_ignore = {},
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
        save_extra_cmds = {
          function()
            -- TODO: Add hooks for git checkouts
            local qflist = vim.fn.getqflist()
            -- return nil to clear any old qflist
            if #qflist == 0 then
              return nil
            end
            local qfinfo = vim.fn.getqflist { title = 1 }

            for _, entry in ipairs(qflist) do
              -- use filename instead of bufnr so it can be reloaded
              entry.filename = vim.api.nvim_buf_get_name(entry.bufnr)
              entry.bufnr = nil
            end

            local setqflist = 'call setqflist(' .. vim.fn.string(qflist) .. ')'
            local setqfinfo = 'call setqflist([], "a", ' .. vim.fn.string(qfinfo) .. ')'
            return { setqflist, setqfinfo, 'copen' }
          end,
        },
      }

      local keymap = vim.keymap
      vim.keymap.set('n', '<leader>ss', require('auto-session.session-lens').search_session, {
        noremap = true,
        desc = 'Search Session',
      })
      keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', {
        desc = 'Restore session for cwd',
      })
      keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', {
        desc = 'Save session for auto session root dir',
      })
    end,
  },
  --- Local Project configurations
  { 'folke/neoconf.nvim' },
}
