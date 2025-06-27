local M = {}

local DIM_CYAN = '#4c757a'
local DIM_PURPLE = '#7a4c77'
local BRIGTH_PINK = '#FB508F'
local DIM_PINK = '#D16D9E'
local FOCUS = '#063036'
local YELLOW = '#F2C94C'

M.themeColors = {
  blue = '#80a0ff',
  cyan = '#79dac8',
  black = '#080808',
  white = '#c6c6c6',
  red = '#ff5189',
  violet = '#d183e8',
  grey = '#303030',
}

M.LineNumberColors = function()
  vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = DIM_PURPLE })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = DIM_CYAN })

  vim.api.nvim_set_hl(0, 'LineNr', { fg = BRIGTH_PINK, bold = true })
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = FOCUS, bold = true })
  vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = YELLOW, bold = true })
end

M.setMarksHL = function()
  local markStyle = {
    fg = BRIGTH_PINK,
    bold = true,
  }
  vim.api.nvim_set_hl(0, 'SnacksStatusColumnMark', markStyle)
  vim.api.nvim_set_hl(0, 'MarkSignHL', markStyle)
  vim.api.nvim_set_hl(0, 'MarkSignNumHL', {
    fg = DIM_PINK,
    bold = true,
  })
end

M.setup = function()
  M.LineNumberColors()
  M.setMarksHL()
end

return M
