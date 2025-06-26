--- Lazy.nvim (plugin manager) configuration
-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
-- vim.cmd 'highlight LineNr ctermfg='#CCCCCC' ctermbg=NONE'
--
--
local M = {}

M.setup = function()
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  end

  vim.opt.rtp:prepend(lazypath)
  --TODO: Hay que limpiar esto un poquito

  -- [[ Configure and install plugins ]]
  -- NOTE: Here is where you install your plugins.
  -- TODO: Instalar Harpoon
  -- TODO:Instalar una herramienta  de pruebas
  require('lazy').setup({
    { import = 'plugins' },
    -- NOTE: La carpeta custom deberia ser para los experimentos
    -- { import = 'custom.plugins' },
    -- {import }
    { import = 'lsp' },
  }, {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  })
end

return M
