local M = {}


M.themeColors = {
  blue = '#80a0ff',
  cyan = '#79dac8',
  black = '#080808',
  white = '#c6c6c6',
  red = '#ff5189',
  violet = '#d183e8',
  grey = '#303030',
}

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
