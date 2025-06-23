  local current_branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('\n', '')
  if not vim.fn.system('git rev-parse --verify ' .. branch):match '^%x+' then
    vim.notify("Branch '" .. branch .. "' does not exist", vim.log.levels.ERROR)
    return
  end

  if branch == current_branch then
    vim.notify('Cannot diff against current branch', vim.log.levels.ERROR)
    return
  end
  local diff_files = vim.fn.systemlist('git diff --name-only ' .. branch)
  if #diff_files > 0 then
    for _, file in ipairs(diff_files) do
      vim.cmd('edit ' .. file)
    end
  else
    vim.notify('No files in diff', vim.log.levels.INFO)
  end
end

-- [[ Autocommands ]]
-- NOTE:`:help lua-guide-autocommands`

function highlight_on_yank()
  local group = vim.api.nvim_create_augroup('HighlightYank', { clear = true })
  -- TextYankPost: Highlight when yanking (copying) text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = group,
    callback = function()
      vim.highlight.on_yank()
    end,
  })
end

--- Nvim configuration reload on save

function auto_reload_nvim_config()
  local NVIM_CONFIG_PATH = string.match(vim.fn.expand '$MYVIMRC', '(.+)/[^/]*$')
  vim.api.nvim_create_augroup('NvimConfigReload', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = NVIM_CONFIG_PATH .. '/**',
    group = 'NvimConfigReload',
    callback = function(ev)
      local changed_file = ev.match
      if vim.fn.expand '$MYVIMRC' ~= changed_file then
        local module_name = vim.fn.fnamemodify(ev.match, ':r'):gsub(NVIM_CONFIG_PATH .. '/lua/', ''):gsub('/', '.')
        vim.notify(string.format('Reloading module: %s', module_name), vim.log.levels.INFO, { title = 'Module Reload' })
        if package.loaded[module_name] then
          -- Clear the module from Lua's cache
          package.loaded[module_name] = nil
        end
      end
      vim.cmd 'source $MYVIMRC'
    end,
  })
end

local M = {}

M.setup_user_commands = function()
  vim.api.nvim_create_user_command('OpenDiffFiles', OpenDiffFiles, {
    nargs = '?',
    desc = 'Open files that differ from the specified branch',
  })
end

M.setup_autocommands = function()
  highlight_on_yank()
  auto_reload_nvim_config()
end

return M
