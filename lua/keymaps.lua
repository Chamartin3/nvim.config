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

--- Window navigation keymaps
-- NOTE: `:help wincmd`
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

--- Drag selected lines up and down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

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

--- [[Key repetition tracking]]
--- Tracks the number of times a key is pressed in a row
--- and triggers a callback function when a certain number of repetitions is reached
local followed = {}
-- TODO: Moove this functionality to a separate module
--
--- Create a map of characters with its key representation
---@param keymap: table[string]
-- function followedKeysMap(keymap)
--   local charmap = {}
--   for _, keyrepr in ipairs(keymap) do
--     local char = vim.api.nvim_replace_termcodes(keyrepr, true, false, true)
--     charmap[char] = keyrepr
--   end
--   return charmap
-- end
--
local function followPressOnKey(key)
  local char = vim.api.nvim_replace_termcodes(key, true, false, true)
  followed[char] = {
    repr = key,
    count = 0,
  }
end

local function getKeyInfo(key)
  local char = vim.api.nvim_replace_termcodes(key, true, false, true)
  return followed[char] or { repr = key, count = 0 }
end

-- local charmap = followedKeysMap(followedKeys)
local lastPressedChar = nil
local repetitionCount = 0
vim.on_key(function(char)
  local repr = char
  local isFollowed = followed[char]
  if isFollowed then
    repr = isFollowed.repr
  end
  if lastPressedChar == repr then
    -- Add to the counter if the key has been pressed again
    repetitionCount = repetitionCount + 1
  else
    -- Reset the counter if a different key is pressed
    repetitionCount = 0
  end
  lastPressedChar = repr
  if isFollowed then
    followed[char].count = repetitionCount
  end
end, vim.api.nvim_create_namespace 'keypress_repetition')

---@param key: string
---@param breakpoints: table[number]
---@param callback: function
local function onRepeatedPress(key, breakpoints, callback)
  --- TODO: Add more breakpoint options
  --- - Add cooldown to this configuration
  ---  Maybe add combinations of keys?
  -- local char = vim.api.nvim_replace_termcodes(key, true, false, true)
  local count = getKeyInfo(key).count
  if breakpoints[count] then
    callback()
  end
end

-- Motion reminders
--- Remind to use the more advanced motion commands
--- TODO: Move these contants to a separate module as a Plugin
--- add the option to block keys when certain number of repetitions is reached
vim.g.motion_reminder_notification = true
vim.g.last_vertical_motion_reminder = 0
vim.g.last_horizontal_motion_reminder = 0
vim.g.motion_reminder_notification_cooldown = 300000 -- 5 minutes

vim.keymap.set('n', '<leader>nm', function()
  if vim.g.motion_reminder_notification then
    vim.motion_reminder_notification = false
  else
    vim.motion_reminder_notification = true
  end
end, {
  desc = 'Toggle motion reminder notification',
})

local function verticalMotionReminder()
  if vim.g.motion_reminder_notification then
    local current_time = vim.loop.now()
    local cooldown = vim.g.motion_reminder_notification_cooldown or 300000
    local last_motion_reminder = vim.g.last_vertical_motion_reminder
    local should_notify = current_time - last_motion_reminder > cooldown

    if should_notify then
      vim.notify(
        [[
    - <number><k or j> -> to move multiple lines at once.
    - % -> to move to the matching parenthesis, bracket, or brace.
    - {} -> to move to the next or previous block of code.
    ]],
        vim.log.levels.INFO,
        {
          title = 'Remember that you can move vertically with <j>, <k>',
        }
      )
      vim.g.last_vertical_motion_reminder = current_time
    end
  end
end

local function horizontalMotionReminder()
  if vim.g.motion_reminder_notification then
    local current_time = vim.loop.now()
    local cooldown = vim.g.motion_reminder_notification_cooldown or 300000
    local last_motion_reminder = vim.g.last_horizontal_motion_reminder
    local should_notify = current_time - last_motion_reminder > cooldown

    if should_notify then
      vim.notify(
        [[
    - <number><h or l> -> to move multiple characters at once.
    - ^ -> to move to the start of the line.
    - $ -> to move to the end of the line.
    - A -> to move to the end of the line and enter insert mode.
    - w -> to move to the start of the next word.
    - b -> to move to the start of the previous word.
    - e -> to move to the end of the current word.
    - ge -> to move to the end of the previous word.
    ]],
        vim.log.levels.INFO,
        {
          title = 'Remember that you can move horizontally with <h> and <l>',
        }
      )
      vim.g.last_horizontal_motion_reminder = current_time
    end
  end
end

followPressOnKey '<Up>'
followPressOnKey '<Down>'
followPressOnKey '<Right>'
followPressOnKey '<Left>'

vim.keymap.set({ 'n' }, '<Down>', function()
  onRepeatedPress('<Down>', { 5, 10 }, verticalMotionReminder)
  return '<Down>'
end, {
  expr = true,
  noremap = true,
})
vim.keymap.set({ 'n' }, '<Up>', function()
  onRepeatedPress('<Up>', { 5, 10 }, verticalMotionReminder)
  return '<Up>'
end, {
  expr = true,
  noremap = true,
})
vim.keymap.set({ 'n' }, '<Left>', function()
  onRepeatedPress('<Left>', { 5, 10 }, horizontalMotionReminder)
  return '<Left>'
end, {
  expr = true,
  noremap = true,
})
vim.keymap.set({ 'n' }, '<Right>', function()
  onRepeatedPress('<Right>', { 5, 10 }, horizontalMotionReminder)
  return '<Right>'
end, {
  expr = true,
  noremap = true,
})
