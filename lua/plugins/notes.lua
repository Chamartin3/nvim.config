local personal_vault = vim.env.PERSONAL_OBSIDIAN_VAULT or ''
local research_vault = vim.env.RESARCH_VAULT or ''
local date = os.date '*t'
local year = date.year
local quarter = math.ceil(date.month / 3)
local current_dailies = string.format('/%d/%d-Q%d/days', year, year, quarter)

return {
  {
    'epwalsh/obsidian.nvim',
    version = '3.o.0',
    -- lazy = true,
    ft = 'markdown',
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',

      -- see below for full list of optional dependencies 👇
    },
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          --- The conceal level hides some syntax elements
          vim.opt_local.conceallevel = 2
        end,
      })
      require('obsidian').setup {
        workspaces = {
          {
            name = 'Notes',
            path = personal_vault,
          },
          -- {
          --   name = 'Research',
          --   path = research_vault,
          -- },
        },
        templates = {
          folder = '_templates',
        },
        daily_notes = {
          folder = 'periodic' .. current_dailies,
          date_format = '%Y-%m-%d',
          --- TODO: Change the telescope `path_display` `smart` or `tail` for this picker.
          alias_format = '$DDDD %d %B',
          default_tags = { 'daily' },
          template = '_templates/periodic/daily.md',
        },
        ui = {
          enable = true,
          update_debounce = 200,
          max_file_length = 5000,
          checkboxes = {
            [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
            ['x'] = { char = '', hl_group = 'ObsidianDone' },
            ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
            ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
            ['!'] = { char = '', hl_group = 'ObsidianImportant' },
            ['r'] = { char = '🏆', hl_group = 'ObsidianImportant' },
          },
          -- Use bullet marks for non-checkbox lists.
          bullets = { char = '•', hl_group = 'ObsidianBullet' },
          external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
          reference_text = { hl_group = 'ObsidianRefText' },
          highlight_text = { hl_group = 'ObsidianHighlightText' },
          tags = { hl_group = 'ObsidianTag' },
          block_ids = { hl_group = 'ObsidianBlockID' },
          hl_groups = {
            ObsidianTodo = { bold = true, fg = '#f78c6c' },
            ObsidianDone = { bold = true, fg = '#89ddff' },
            ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
            ObsidianTilde = { bold = true, fg = '#ff5370' },
            ObsidianImportant = { bold = true, fg = '#d73128' },
            ObsidianBullet = { bold = true, fg = '#89ddff' },
            ObsidianRefText = { underline = true, fg = '#c792ea' },
            ObsidianExtLinkIcon = { fg = '#c792ea' },
            ObsidianTag = { italic = true, fg = '#89ddff' },
            ObsidianBlockID = { italic = true, fg = '#89ddff' },
            ObsidianHighlightText = { bg = '#75662e' },
          },
        },
      }
    end,
  },
  -- {
  --   'tadmccorkle/markdown.nvim',
  --   ft = 'markdown',
  --   opts = {},
  -- },
}
