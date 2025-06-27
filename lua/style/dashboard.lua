local M = {}
local alphaButtonFunction = require('alpha.themes.dashboard').button

function customAlphaButton(shortcut, text, command, opts)
  local button = alphaButtonFunction(shortcut, text, command)
  button.opts.hl = opts.hl or {}
  button.opts.hl_shortcut = opts.hl_shortcut or 'AlphaButtonsShortcut'
  return button
end

M.getGitButton = function(text, action)
  --- Set buttons
  vim.api.nvim_set_hl(0, 'GitButtonsIcon', { fg = '#ff6a00', bold = true })
  vim.api.nvim_set_hl(0, 'GitButtonsText', { fg = '#FFFFFF' })
  vim.api.nvim_set_hl(0, 'GitButtonsShortcut', { fg = '#ff6a00' })
  if not text or text == '' then
    return {}
  end
  local buttton_txt = '󰊢   ' .. text
  local shortcut = action.shortcut or ''
  local command = action.command or ''
  return customAlphaButton(shortcut, buttton_txt, command, {
    hl = {
      { 'GitButtonsIcon', 0, 2 },
      { 'GitButtonsText', 2, 50 },
    },
    hl_shortcut = 'GitButtonsShortcut',
  })
end

M.getGitMenu = function()
  local gitInfo = require('utils').getGitInfo()
  if not gitInfo then
    return {}
  end
  local gitButton = M.getGitButton
  local gitMenu = {
    {
      type = 'text',
      val = '󰊢  Git Repo:  ' .. gitInfo.name .. ' (' .. gitInfo.branch .. ')',
      opts = { hl = 'SpecialComment', position = 'center' },
    },
  }
  if gitInfo.last_commit then
    table.insert(gitMenu, {
      type = 'text',
      val = 'Last commit on ' .. gitInfo.last_commit.date .. ' (' .. gitInfo.last_commit.author .. ')',
      opts = { hl = 'Comment', position = 'center' },
    })
  end
  if not gitInfo.is_root then
    vim.notify 'You are not on the root of the git repository'
    table.insert(gitMenu, {
      type = 'text',
      val = 'Warning: You are not on the root of the git repository',
      opts = { hl = 'ErrorMsg', position = 'center' },
    })
    table.insert(
      gitMenu,
      gitButton('Move to root', {
        shortcut = 'gr',
        command = '<cmd>GoGitRoot<CR>',
      })
    )
    table.insert(gitMenu, {
      type = 'text',
      val = '_____________________________________',
      opts = { hl = 'ErrorMsg', position = 'center' },
    })
  end

  table.insert(
    gitMenu,
    gitButton('Repo', {
      shortcut = 'gl',
      command = '<cmd>LazyGit<CR>',
    })
  )
  table.insert(
    gitMenu,
    gitButton('Git Branches', {
      shortcut = 'gb',
      command = '<cmd>Telescope git_branches<CR>',
    })
  )
  table.insert(
    gitMenu,
    gitButton('Git Files', {
      shortcut = 'gf',
      command = '<cmd>Telescope git_files<CR>',
    })
  )
  table.insert(
    gitMenu,
    gitButton('Git Commits', {
      shortcut = 'gc',
      command = '<cmd>Telescope git_commits<CR>',
    })
  )
  return gitMenu
end
M.getPokeButton = function(text, action)
  vim.api.nvim_set_hl(0, 'PokeButtonsIcon', { fg = '#ed2d2d', bold = true })
  vim.api.nvim_set_hl(0, 'PokeButtonsText', { fg = '#FFFFFF' })
  vim.api.nvim_set_hl(0, 'PokeButtonsShortcut', { fg = '#ed2d2d' })
  if not text or text == '' then
    return {}
  end
  local buttton_txt = '󰐝   ' .. text
  local shortcut = action.shortcut or ''
  local command = action.command or ''
  return customAlphaButton(shortcut, buttton_txt, command, {
    hl = {
      { 'PokeButtonsIcon', 0, 2 },
      { 'PokeButtonsText', 2, 50 },
    },
    hl_shortcut = 'PokeButtonsShortcut',
  })
end

M.getPikachuHeader = function(light)
  local outline_color = '#000000'
  if light then
    outline_color = '#FFFFFF'
  end
  vim.api.nvim_set_hl(0, 'AlphaPikachuLogoYellow', { fg = '#FFD700' })
  vim.api.nvim_set_hl(0, 'AlphaPikachuLogoBlack', { fg = outline_color })
  vim.api.nvim_set_hl(0, 'AlphaPikachuLogoRed', { fg = '#bd4260' })
  local pikachu = {
    [[⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⣿⣿⡏⠛⠦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠘⣿⡇⠀⠀⠈⠛⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀]],
    [[⠀⠘⣧⠀⠀⠀⠀⠀⠉⠳⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠴⠒⠚⣿⣿⡿]],
    [[⠀⠀⠘⢧⠀⠀⠀⠀⠀⠀⠈⠳⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⡤⠖⠚⠉⠁⠀⠀⠀⢰⣿⡟⠀]],
    [[⠀⠀⠀⠈⢷⡀⠀⠀⠀⠀⠀⠀⠈⠛⠒⠒⠒⠒⠒⠒⠒⠒⠤⠤⠤⠤⠖⠚⠉⠁⠀⠀⠀⠀⠀⠀⠀⢀⣿⠏⠀⠀]],
    [[⠀⠀⠀⠀⠀⠻⣄⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡟⠁⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⠙⣷⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⣠⡴⠋⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠀⢠⠏⠀⠀⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⡤⠞⠁⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⢠⠏⠀⠀⠀⢰⣏⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡶⣿⣦⠀⠀⠀⠀⠀⢹⡄⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⡞⠀⠀⠀⠀⠈⠻⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⡿⠀⠀⠀⠀⠀⠀⣷⠀⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⢸⢁⣤⣤⣤⡀⠀⠀⠀⠀⠀⠀⠸⠿⠗⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡆⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⡿⢿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⢀⣀⣀⡀⠀⠀⠀⠀⠀⠀⢰⣾⣿⣿⣷⡄⠀⠈⣧⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⢷⠈⠙⠛⠋⠁⠀⠀⠀⠀⠀⢰⠟⠉⠀⠉⢻⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⠇⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⢘⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢦⣀⠀⣀⡼⠀⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀]],
    [[⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀]],
    [[    ███╗   ██╗██╗   ██╗██╗███╗   ███╗     ]],
    [[    ████╗  ██║██║   ██║██║████╗ ████║     ]],
    [[    ██╔██╗ ██║██║   ██║██║██╔████╔██║     ]],
    [[    ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║     ]],
    [[    ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║     ]],
    [[    ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝     ]],
  }

  vim.api.nvim_set_hl(0, 'AlphaTittleLogo1', { fg = '#2843c9' })
  vim.api.nvim_set_hl(0, 'AlphaTittleLogo2', { fg = '#1f78d1' })
  vim.api.nvim_set_hl(0, 'AlphaTittleLogo3', { fg = '#39babd' })
  vim.api.nvim_set_hl(0, 'AlphaTittleLogo4', { fg = '#37bd95' })
  vim.api.nvim_set_hl(0, 'AlphaTittleLogo5', { fg = '#37bd49' })
  vim.api.nvim_set_hl(0, 'AlphaTittleLogo6', { fg = '#87de5f' })

  local opts = {
    {
      { 'AlphaPikachuLogoBlack', 0, 25 },
    }, --1
    {
      { 'AlphaPikachuLogoBlack', 0, 15 },
      { 'AlphaPikachuLogoYellow', 15, 40 },
      { 'AlphaPikachuLogoBlack', 40, 150 },
    }, --2
    {
      { 'AlphaPikachuLogoBlack', 0, 15 },
      { 'AlphaPikachuLogoYellow', 15, 40 },
      { 'AlphaPikachuLogoBlack', 40, 150 },
    }, -- 3
    {
      { 'AlphaPikachuLogoYellow', 0, 110 },
      { 'AlphaPikachuLogoBlack', 110, 150 },
    }, -- 4
    {
      { 'AlphaPikachuLogoYellow', 0, 115 },
      { 'AlphaPikachuLogoBlack', 115, 150 },
    }, --- 5
    { { 'AlphaPikachuLogoYellow', 0, 150 } },
    { { 'AlphaPikachuLogoYellow', 0, 150 } },
    { { 'AlphaPikachuLogoYellow', 0, 150 } },
    {
      { 'AlphaPikachuLogoYellow', 0, 30 },
      { 'AlphaPikachuLogoBlack', 30, 90 },
      { 'AlphaPikachuLogoYellow', 90, 150 },
    }, -- 6
    {
      { 'AlphaPikachuLogoYellow', 0, 30 },
      { 'AlphaPikachuLogoBlack', 30, 90 },
      { 'AlphaPikachuLogoYellow', 90, 150 },
    }, -- 7
    {
      { 'AlphaPikachuLogoYellow', 0, 30 },
      { 'AlphaPikachuLogoBlack', 30, 90 },
      { 'AlphaPikachuLogoYellow', 90, 150 },
    }, --- 8
    {
      { 'AlphaPikachuLogoYellow', 0, 15 },
      { 'AlphaPikachuLogoRed', 15, 45 },
      { 'AlphaPikachuLogoBlack', 45, 75 },
      { 'AlphaPikachuLogoRed', 75, 90 },
      { 'AlphaPikachuLogoYellow', 90, 150 },
    },
    {
      { 'AlphaPikachuLogoYellow', 0, 15 },
      { 'AlphaPikachuLogoRed', 15, 45 },
      { 'AlphaPikachuLogoBlack', 45, 75 },
      { 'AlphaPikachuLogoRed', 75, 100 },
      { 'AlphaPikachuLogoYellow', 100, 150 },
    },

    {
      { 'AlphaPikachuLogoYellow', 0, 15 },
      { 'AlphaPikachuLogoRed', 15, 45 },
      { 'AlphaPikachuLogoBlack', 45, 75 },
      { 'AlphaPikachuLogoRed', 75, 100 },
      { 'AlphaPikachuLogoYellow', 100, 150 },
    },

    {
      { 'AlphaPikachuLogoYellow', 0, 25 },
      { 'AlphaPikachuLogoRed', 25, 45 },
      { 'AlphaPikachuLogoBlack', 45, 75 },
      { 'AlphaPikachuLogoRed', 75, 100 },
      { 'AlphaPikachuLogoYellow', 100, 150 },
    },

    {
      { 'AlphaPikachuLogoYellow', 0, 25 },
      { 'AlphaPikachuLogoBlack', 25, 75 },
      { 'AlphaPikachuLogoYellow', 75, 150 },
    },
    { { 'AlphaTittleLogo1', 0, 150 } },
    { { 'AlphaTittleLogo2', 0, 150 } },
    { { 'AlphaTittleLogo3', 0, 150 } },
    { { 'AlphaTittleLogo4', 0, 150 } },
    { { 'AlphaTittleLogo5', 0, 150 } },
    { { 'AlphaTittleLogo6', 0, 150 } },
    {},
    {},
  }
  return {
    val = pikachu,
    opts = {
      hl = opts,
    },
  }
end

return M
