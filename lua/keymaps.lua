-- Keymaps for Neovim
-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move selected lines up and down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--@param infoname: string
--@param info: string
local function copyNotify(infoname, info)
  vim.cmd('let @+="' .. info .. '"')
  vim.notify(info, vim.log.levels.INFO, {
    title = 'Copied' .. infoname .. ' to cliboard:',
  })
end

vim.keymap.set('n', '<leader>cp', function()
  copyNotify('file path', vim.fn.expand '%:p')
end, { desc = 'Copy file [P]ath to clipboard' })

vim.keymap.set('n', '<leader>cf', function()
  copyNotify('file fullpath', vim.fn.expand '%')
end, { desc = 'Copy file [F]ullpath to clipboard' })

vim.keymap.set('n', '<leader>cn', function()
  copyNotify('file path', vim.fn.expand '%:t')
end, { desc = 'Copy file [N]ame to clipboard' })

-- Motion reminder plugin
require('experiments.motion_reminder').setup()
